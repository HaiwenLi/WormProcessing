function allFl=allFl(vn,vl) %force as a function of normal and parallel velocity

% Cnbase=0.5108;
% Cn=6.2817;   
% Cl=0.2770; 
% cline=4.0587;
% theta=atan2(vn,vl);
% betaA=atan2(cline*sin(theta),sign(cos(theta)));
% %allFn=-(Cnbase*sin(betaA)+Cl*sin(theta));
% allFl=-Cl*cos(theta);

%{
Cnbase=0.7216;
Cn=-0.0072;   
Cl=0.1896; 
cline=2.2603;
%}
%{
Cnbase=1.2117;
Cn=-0.3194;
Cl=0.4390;
cline=1.575;
%}
%{
theta=atan2(vn,vl);

Cnbase=0.8765;
Cn=-0.2744;
Cl=0.3623;
cline=1.9256;

betaA=atan2(cline*sin(theta),sign(cos(theta)));
%}
%allFl=-(Cl*cos(theta)+Cn*(1-abs(sin(theta))).*sign(cos(theta))).*(vn>0);%.*atan(abs(vn)*30)*0.6366;
%allFl=-(Cl*cos(theta)+Cn*(1-abs(sin(theta))).*sign(cos(theta))).*(vn>0);%.*atan(abs(vn)*30)*0.6366;
%allFl=-(Cl*cos(theta)+Cn*(1-abs(sin(theta)))).*(vn>0);

%allFl=-(Cl*cos(theta)+Cn*(1-abs(sin(theta)))); %%granular


%vmag=(vn.^2+vl.^2).^0.5;
%allFl=-vl./vmag.*(vn>0);
%theta=atan2(vn,vl);
%allFl=-cos(theta)*0.5;
%u_f=0.3;u_b=1.3*u_f;u_t=1.8*u_f;
%allFl=-cos(theta).*u_f.*(vl>0)-cos(theta).*u_b.*(vl<0);

% allFl=-vl*0.67; %viscous fluid
allFl=-vl*0.1; %agar
