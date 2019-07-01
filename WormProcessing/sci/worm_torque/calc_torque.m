% calculate torquq and force of freely moving/crawling worm
Output_Folder = '';

% 
HD = 0;
segwidth = 1.0;
DX = 1/100; % actual segment width
frame_rate = 24;
[s t] = meshgrid(0:DX:1,0:DT:(T-2)/frame_rate);%s: position, t: time

% load worm position, displacement

% calculate speed, angle chain along centerline

for i=1:T
	[tor(i,:), Fx(i,:), Fy(i,:)] = shorttorque(xx,yy,vvx,vvy,oangle,segwidth,HD,DX);
end

% visualize force and torque
figure(124)
showskip = 16;
orientation = 0; dispx = 0; dispy = 0;

if mod(i-1,frame_rate)==0
	clf
	Fscale=0.1;vscale=0.1;
	plot(xx*cos(orientation)-yy*sin(orientation)+dispx, yy*cos(orientation)+xx*sin(orientation)+dispy,'b-','linewidth',4);hold on;
	quiver(xx(1:showskip:end)*cos(orientation)-yy(1:showskip:end)*sin(orientation)+dispx, yy(1:showskip:end)*cos(orientation)+xx(1:showskip:end)*sin(orientation)+dispy, (vvx(1:showskip:end)*cos(orientation)-vvy(1:showskip:end)*sin(orientation))*vscale ,(vvy(1:showskip:end)*cos(orientation)+vvx(1:showskip:end)*sin(orientation))*vscale,0,'linewidth',4,'color','m');
	quiver(xx(1:showskip:end)*cos(orientation)-yy(1:showskip:end)*sin(orientation)+dispx, yy(1:showskip:end)*cos(orientation)+xx(1:showskip:end)*sin(orientation)+dispy, (Fx(1:showskip:end)*cos(orientation)-Fy(1:showskip:end)*sin(orientation))*Fscale ,(Fy(1:showskip:end)*cos(orientation)+Fx(1:showskip:end)*sin(orientation))*Fscale,0,'linewidth',4,'color','g');
	h = legend('Body','Velocity','Force','Location','NorthEastOutside');
	set(h,'Fontsize',12);
	Ftotal(i)=norm([sum(Fx) sum(Fy)]);
	Ftotalx(i)=xx(end)*cos(orientation)-yy(end)*sin(orientation)+dispx;
	Ftotaly(i)=yy(end)*cos(orientation)+xx(end)*sin(orientation)+dispy;
	
	title(['t=' num2str(i*DT-DT)]);
	xlabel('x','fontsize',24);ylabel('y','fontsize',24);
	axis image
	axis([-0.2 0.6 -0.2 1.1]);
	set(gcf,'color','w');
    saveas(124, [Output_Folder 'move_', num2str(floor(j/10)) '.png']);
	% pause(0.1);
end

figure(1278);clf;
tor = tor/max(tor(:))*0.999;
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