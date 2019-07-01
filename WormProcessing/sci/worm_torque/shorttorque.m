function [tor,Fx,Fy] =shorttorque(xx,yy,vvx,vvy,oangle,segwidth,HD,DX)
% calculate force and torque by position, speed, orientation at each frame
% Params:
% position, velocity, segment orientation, segment width, head width an DX

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

for i=1:length(Fx);
	tortemp(i)=-((xx(i:end)-xx(i))*Fy(i:end)'-(yy(i:end)-yy(i))*Fx(i:end)')*DX;
end

for i=1:length(Fx);
	tortemp2(i)=((xx(1:i)-xx(i))*Fy(1:i)'-(yy(1:i)-yy(i))*Fx(1:i)')*DX;
end 
tor = (tortemp+tortemp2)*0.5;