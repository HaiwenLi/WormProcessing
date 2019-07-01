function torqueerr10 = torqueerr10(curvature,dcurv,HD,para)  %net force and torque combined in scaler
global XLength DX segwidth DT
comvx=para(1);
comvy=para(2);
ome=para(3);

oangle=cumsum(curvature)*DX;
xx=cumsum(cos(oangle)*DX);
yy=cumsum(sin(oangle)*DX);

vvx=cumsum(-sin(oangle).*cumsum(dcurv)*DX)*DX;
vvy=cumsum(cos(oangle).*cumsum(dcurv)*DX)*DX;

vvx=vvx-ome*yy+comvx;
vvy=vvy+ome*xx+comvy;

midangle=oangle;
vl=cos(midangle).*vvx+sin(midangle).*vvy; 
vn=-sin(midangle).*vvx+cos(midangle).*vvy;
Fn=allFn(vn,vl).*segwidth;
Fl=allFl(vn,vl).*segwidth;
Fx=Fn.*-sin(midangle)+Fl.*cos(midangle);
Fy=Fn.*cos(midangle) +Fl.*sin(midangle);
midangle=oangle;

Fxhead=-vvx(end)*HD/DX;
Fyhead=-vvy(end)*HD/DX;

Fx(end)=Fx(end)+Fxhead;
Fy(end)=Fy(end)+Fyhead;

torqueerr10=[(xx*Fy'-yy*Fx')'*DX 0.5*XLength*sum(Fx')*DX 0.5*XLength*sum(Fy')*DX];

