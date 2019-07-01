clear all
global XLength DX waveslope taperangle segwidth DT frame_rate

global Output_Folder
Output_Folder = 'L:\codes\torque_swim\';
frame_rate = 4;

DX=0.005;DT=0.005; %spatial and temporal discretization
A=1.2*2*pi; %amplitude

HD=0;  %head size 
XLength=1; %body length

% [s t]=meshgrid(0:DX:XLength,0:DT:(T-2)/frame_rate);  %s: position , t: time
[s t]=meshgrid(0:DX:XLength,0:DT:1);  %s: position , t: time

segwidth=s(1,:)*0+1;  %segment width
omega=zeros(size(t,1),3); % translation velocity and angular velocity

%solve the force=torque=zero equations
fval=zeros(size(t,1),3);
fflag=zeros(size(t,1),1);

options = optimset('MaxFunEvals', 10000, 'MaxIter', 10000,'TolFun',0.0001, 'TolX',0.0001,'Display', 'off');
w1=0.0941;w2=-0.0464;w3= -0.0259;

for j=1:size(t,1); %loop over time

	ss=s(j,:);
	
	%prescribe the curvature and it's changing rate
	curvature=A.*sin(2*pi*(ss+t(j,:)));   %replace this by data from experiment
	dcurv=2*pi*A.*cos(2*pi*(ss+t(j,:)));  %replace this by data from experiment
    
	[omega(j,:) fval(j,:) solveflag]=fsolve(@(w)torqueerr10(curvature,dcurv,HD,w),[w1 w2 w3],options);
	if solveflag>0 w1=omega(j,1);w2=omega(j,2);w3=omega(j,3); end
	if solveflag~=1
		[j solveflag fval(j,:)]
		omega(j,1)=w1;omega(j,2)=w2;omega(j,3)=w3;
	end
end

% calculate the orientation and displacement in the lab frame
orientation=cumsum((omega(:,3)))*DT;  
dispx=cumsum((omega(:,1).*cos(orientation)-omega(:,2).*sin(orientation)))*DT;
dispy=cumsum((omega(:,2).*cos(orientation)+omega(:,1).*sin(orientation)))*DT;

tor=s*0;
ss=s(j,:);

for jj=1:size(t,1)
	j=jj;
	comvx=omega(j,1);
	comvy=omega(j,2);
	ome=omega(j,3);
	ss=s(j,:);

	%prescribe the curvature and it's changing rate
	curvature=A.*sin(2*pi*(ss+t(j,1))); 
	dcurv=2*pi*A.*cos(2*pi*(ss+t(j,1))); 
    
	%calculate the orientation, position, velocity, force on the body and on the head from the prescribed curvature and dcurvature
	oangle=cumsum(curvature)*DX;
	xx=cumsum(cos(oangle)*DX);
	yy=cumsum(sin(oangle)*DX);
	vvx=cumsum(-sin(oangle).*cumsum(dcurv)*DX)*DX;
	vvy=cumsum(cos(oangle).*cumsum(dcurv)*DX)*DX;

	vvx=vvx-ome*yy+comvx;
	vvy=vvy+ome*xx+comvy;

	vl=cos(oangle).*vvx+sin(oangle).*vvy; 
	vn=-sin(oangle).*vvx+cos(oangle).*vvy;
	Fn=allFn(vn,vl).*segwidth;
	Fl=allFl(vn,vl).*segwidth;
	Fx=Fn.*-sin(oangle)+Fl.*cos(oangle);
	Fy=Fn.*cos(oangle) +Fl.*sin(oangle);

	Fxhead=-vvx(end)*HD/DX;
	Fyhead=-vvy(end)*HD/DX;

	Fx(end)=Fx(end)+Fxhead;
	Fy(end)=Fy(end)+Fyhead;
	
	%calculate the torque
	for i=1:size(s,2);
		tortemp(i)=-((xx(i:end)-xx(i))*Fy(i:end)'-(yy(i:end)-yy(i))*Fx(i:end)')*DX;
	end
	
	tor(j,:)=tortemp;
	
	%compute the torque using the function
%	tor(j,:)=shorttorque(xx,yy,vvx,vvy,oangle,segwidth,HD,DX);

	%visualize the simulation
	figure(124)
	showskip=16;

	if mod(jj-1,frame_rate)==0	
		clf
		Fscale=0.1;vscale=0.1;
		plot(xx*cos(orientation(j))-yy*sin(orientation(j))+dispx(j),yy*cos(orientation(j))+xx*sin(orientation(j))+dispy(j),'b-','linewidth',4);hold on;
		quiver(xx(1:showskip:end)*cos(orientation(j))-yy(1:showskip:end)*sin(orientation(j))+dispx(j),yy(1:showskip:end)*cos(orientation(j))+xx(1:showskip:end)*sin(orientation(j))+dispy(j),(vvx(1:showskip:end)*cos(orientation(j))-vvy(1:showskip:end)*sin(orientation(j)))*vscale ,(vvy(1:showskip:end)*cos(orientation(j))+vvx(1:showskip:end)*sin(orientation(j)))*vscale,0,'linewidth',4,'color','m');
		quiver(xx(1:showskip:end)*cos(orientation(j))-yy(1:showskip:end)*sin(orientation(j))+dispx(j),yy(1:showskip:end)*cos(orientation(j))+xx(1:showskip:end)*sin(orientation(j))+dispy(j),(Fx(1:showskip:end)*cos(orientation(j))-Fy(1:showskip:end)*sin(orientation(j)))*Fscale ,(Fy(1:showskip:end)*cos(orientation(j))+Fx(1:showskip:end)*sin(orientation(j)))*Fscale,0,'linewidth',4,'color','g');
		h=legend('Body','Velocity','Force','Location','NorthEastOutside');
		set(h,'Fontsize',12);
		Ftotal(j)=norm([sum(Fx) sum(Fy)]);
		Ftotalx(j)=xx(end)*cos(orientation(j))-yy(end)*sin(orientation(j))+dispx(j);
		Ftotaly(j)=yy(end)*cos(orientation(j))+xx(end)*sin(orientation(j))+dispy(j);
		
		title(['t=' num2str(j*DT-DT)]);
		xlabel('x','fontsize',24);ylabel('y','fontsize',24);
		axis image
		axis([-0.2 0.6 -0.2 1.1]);
        % axis([-0.1 1.1 -0.6 0.6]);
		set(gcf,'color','w');
% 		saveas(124, ['./move_' num2str(floor(j/10))], 'png')
        saveas(124, [ Output_Folder 'move_', num2str(floor(j/10)) '.png']);
		% pause(0.1);
	end
end

figure(1278);clf;
tor=tor/max(tor(:))*0.999;
imagesc(s(1,:),t(:,1),tor);
title(['Torque '],'fontsize',18);
xlabel('Tail <--  Position  --> Head','fontsize',24);
ylabel('Time','fontsize',24);
set(gca,'YDir','normal')
set(gca,'fontsize',24,'box','on');
set(gcf,'color','w');
% axis([0 1 0 1]);
% saveas(1278, ['./tor', '.png']);
saveas(1278, [Output_Folder 'tor', '.png']);
