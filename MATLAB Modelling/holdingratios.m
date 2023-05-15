clc;
clear;

% ======== Calculating Holding Ratio =========

% Variables
m = 100;
g = 9.81;
r = 0.3893;
theta = 37.7226*pi/180;
T_gear = m*g*r*cos(theta)

% Motor 1 - APM
T_s1 = 0.19;
ratio1 = T_gear/T_s1;

% Motor 2 - NSA-I(1)
T_s2 = 0.43;
ratio2 = T_gear/T_s2;

% Motor 3 - NSA-I(2)
T_s3 = 0.48;
ratio3 = T_gear/T_s3;

% Motor 4 - NSA-I(3)
T_s4 = 0.69;
ratio4 = T_gear/T_s4;

ratios =  [ratio1, ratio2, ratio3, ratio4]