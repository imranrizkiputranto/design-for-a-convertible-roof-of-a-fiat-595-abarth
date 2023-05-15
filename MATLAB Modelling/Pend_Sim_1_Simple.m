clc; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Parameters
L = 0.5;
g = 9.81;

% Define System
dz = @(t,z) [   z(2);
                -g/L*sin(z(1))];

% Run ODE solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulation parameters
T = 10;
opts = odeset('RelTol',1e-6);

% Low-amplitude simulation
IC = [pi*0.1, 0];
[t1,z1] = ode45(dz,[0,T],IC,opts);

% % Animate (uncomment to run)
% animate_pendulum(t1,z1(:,1))

% High-amplitude simulation
IC = [pi*0.9, 0];
[t2,z2] = ode45(dz,[0,T],IC,opts);

% Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
plot(t1,z1(:,1))
plot(t2,z2(:,1))
xlabel('t [s]')
ylabel('\theta [rad]')
legend('Low','High')

