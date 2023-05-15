% Car Roof Model - Group 21B

clc;
clear;

% Adjustable Parameters
retract = 1;         %set to 0 to sim deploy, 1 for retraction
g = 9.81;            %gravity
r = 0.3893;          %radius of CoM when deployed
m = 100;             %total mass of roof system
c = 30;              %damping constant
T_s = 0.69;          %stall torque
omega_noload = 3700; %noload speed (rpm)
VR = 600;            %velocity ratio
T = 15;              %simulation time

%Body

if retract == 0
    thet_end = 4.31108478;      %assigns end position
    thet_start = 2.229180482;   %assigns start position
    mDir = 1;                   %direction variable
else
    thet_end = 2.229180482;
    thet_start = 4.31108478;
    mDir = -1;
end

k = T_s/(omega_noload*2*pi/60);
% T_m = 0.1173;
% T_gear = VR*T_m;

% ODE Options
opts = odeset('RelTol', 10^-4,'Events',@Simple_Pendulum_Event);
IC = [thet_start, 0];

% ODE Solver
radius = @(t,z) r - (z(1) - thet_start) * (1/(thet_end-thet_start)) * (r - 0.22254);
gravity = @(t,z) -(g/radius(t,z))*cos(z(1)-pi/2);
motor = @(t,z) (-k*z(2)*VR+mDir*T_s)*VR/(m*radius(t,z)^2);
damping = @(t,z) -c*z(2)/(m*radius(t,z)^2);
% snow = 
% wind = 

dz = @(t,z)[ z(2);
             gravity(t,z) + motor(t,z) + damping(t,z)];

[t1,z1] = ode45(dz,[0,T],IC,opts);

% Animate Pendulum
animate_pendulum(t1,z1(:,1))
