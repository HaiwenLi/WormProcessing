global XLength DX waveslope taperangle segwidth DT frame_rate

global Output_Folder
Output_Folder = 'L:\codes\torque_curvature_b19\';

frame_rate = 24;
T = length(DataCurvature);
PNum = size(DataCurvature,2);

% DX=0.005;DT=0.005; %spatial and temporal discretization
DX=1/(PNum-1);
DT=1/frame_rate; %spatial and temporal discretization  

HD=0;  %head size 
XLength=1; %body length

[s t]=meshgrid(0:DX:XLength,0:DT:(T-2)/frame_rate);  %s: position , t: time

segwidth=s(1,:)*0+1;  %segment width
omega=zeros(size(t,1),3); % translation velocity and angular velocity

%solve the force=torque=zero equations
fval=zeros(size(t,1),3);
fflag=zeros(size(t,1),1);

options = optimset('MaxFunEvals', 10000, 'MaxIter', 10000,'TolFun',0.0001, 'TolX',0.0001,'Display', 'off');
w1=0.0941;w2=-0.0464;w3= -0.0259;

for j=1:size(t,1) %loop over time   
	%prescribe the curvature and it's changing rate
    curvature = DataCurvature(j+1,:);
    dcurv = (DataCurvature(j+1,:) - DataCurvature(j,:))*frame_rate; % backward difference
    
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
    curvature = DataCurvature(j+1,:);
    dcurv = (DataCurvature(j+1,:) - DataCurvature(j,:))*frame_rate; % backward difference
    
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
	for i=1:size(s,2)
		tortemp(i)=-((xx(i:end)-xx(i))*Fy(i:end)'-(yy(i:end)-yy(i))*Fx(i:end)')*DX;
	end
	
	tor(j,:)=tortemp;
	
	%compute the torque using the function
%	tor(j,:)=shorttorque(xx,yy,vvx,vvy,oangle,segwidth,HD,DX);


	%visualize the simulation
	figure(124)
	showskip=8;

	if mod(jj-1,frame_rate)==0	
		clf
		Fscale=0.5;vscale=0.5;
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
% 		axis([-0.2 0.6 -0.2 1.1]);
        axis([-2 9 -6 0]);
		set(gcf,'color','w');
% 		saveas(124, ['./move_' num2str(floor(j/10))], 'png')
        saveas(124, [ Output_Folder 'move_', num2str(floor(j/10)) '.png']);
		pause(0.1);
	end
end

smooth_tor = zeros(size(tor));
for i=1:PNum
    winsize = 24/2;
    smooth_tor(:,i) = smooth(tor(:,i),winsize);
end
% smooth_tor = tor;

figure(1278);clf;
tor=tor/max(tor(:))*0.999;
imagesc(t(:,1),s(1,:),smooth_tor');
title(['Torque '],'fontsize',18);
ylabel('Tail <--  Position  --> Head','fontsize',24);
xlabel('Time','fontsize',24);
set(gca,'YDir','normal');
set(gca,'fontsize',24,'box','on');
set(gcf,'color','w');
ylabel('Tail <-> Head','fontsize',24);

% figure(1278);clf;
% tor=tor/max(tor(:))*0.999;
% imagesc(s(1,:),t(:,1),tor);
% title(['Torque '],'fontsize',18);
% xlabel('Tail <--  Position  --> Head','fontsize',24);
% ylabel('Time','fontsize',24);
% set(gca,'YDir','normal')
% set(gca,'fontsize',24,'box','on');
% set(gcf,'color','w');
% % axis([0 1 0 1]);
% % saveas(1278, ['./tor', '.png']);
% saveas(1278, [Output_Folder 'tor', '.png']);
