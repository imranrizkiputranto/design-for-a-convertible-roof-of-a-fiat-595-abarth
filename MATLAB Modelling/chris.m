% Car Roof Model - Group 21B

% Mechanism Parameters
g = 9.81;
r = 0.3893; % length of CoM from origin 
m = 2.201; % total length of members in system (m) - proportional to mass
thet_start = 120*pi/180;
thet_end = 210*pi/180;

% Motor Parameters
T_s = 0.43; 
omega_noload = 2750; %rpm
k = T_s/omega_m; 
T_m = 0.1173;

% Gear Parameters
omega_gear = 0.9111; % to close in 15s

VR = 1975
T_gear = VR*T_m;

% ODE Parameters
T = 16;
opts = odeset('RelTol', 10^-6);
IC = [thet_start, 0];

% ODE Solver
dz = @(t,z)[ z(2);
             -(g/r)*sin(z(1)) + (-(T_s/2750)*z(2)*VR+T_s)*VR/(m*r^2) ];

[t1,z1] = ode45(dz,[0,T],IC,opts);

% Animate Pendulum
animate_pendulum(t1,z1(:,1))


% 1. actual mass?
% 2. VR = GR?
% 3. 