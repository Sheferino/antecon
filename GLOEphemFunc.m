function [ dA ] = GLOEphemFunc( t, A )
%% Function of GLO ephemeris

% Constants
mu=398600.4418E9;
ae=6378136;
J0=1082625.75E-9;
w=7.292115E-5;
% input args
x=A(1);
y=A(2);
z=A(3);
Vx=A(4);
Vy=A(5);
Vz=A(6);
ax=A(7);
ay=A(8);
az=A(9);

r=sqrt(x^2+y^2+z^2);
% Function
dx=Vx;
dy=Vy;
dz=Vz;
dVx=-mu*x/(r^3)-1.5*(J0^2)*mu*(ae^2)*(r^(-5))*x*(1-5*(z^2)/(r^2))+(w^2)*x+2*w*Vy+ax;
dVy=-mu*y/(r^3)-1.5*(J0^2)*mu*(ae^2)*(r^(-5))*y*(1-5*(z^2)/(r^2))+(w^2)*y+2*w*Vx+ay;
dVz=-mu*z/(r^3)-1.5*(J0^2)*mu*(ae^2)*(r^(-5))*z*(1-5*(z^2)/(r^2))+az;
dax=0;
day=0;
daz=0;
% Output arguments
dA=[dx dy dz dVx dVy dVz dax day daz]';
end

