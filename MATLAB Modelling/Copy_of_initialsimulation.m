% =============================================================
%
%                    Convertible Roof Model
%     Engineering Practice Summative Assessment - Group 21B
%      Imran Rizki Putranto, Will Beamish, Sheila Shafira
%
% =============================================================

clc;
clear;

% ======== Adjustable Parameters ========

% ### Ask user if they want retracting or deploying simulation ###
isretract = 1;
while isretract == 1 % Loop to ensure user enters valid input
    retract = str2double(input('Enter 1 for retracting simulation and 0 for deploying: ','s'));
    retract = round(retract);
    while retract ~= 0 & retract ~= 1 | isempty(retract) | isnan(retract)
        retract = str2double(input('Invalid input! \nEnter a value of 1 for retracting simulation and 0 for deploying: ','s'));
        round(retract);
    end
    if retract == 1 | retract == 0
        isretract = 0;
    end
end
 
g = 9.81;            % gravity
r = 0.3893;          % radius of CoM when deployed
m = 100;             % total mass of roof system
c = 30;              % damping constant
T = 15;              % simulation time

% Range of gear ratios to try
VR = [700, 750, 800];            % Velocity Ratio/Gear Ratio
thet_vr = cell(size(VR));        

% ======== Choosing which motor to use ========

Proceed = 1;
while Proceed  == 1 
    MOTORCHOICE = input('\n\nWhich motor family you would like to use(APM, NSA-I): ','s'); 
    MOTORCHOICE = lower(MOTORCHOICE); % Convert input to lowercase

    % Loop to prevent user from entering invalid inputs
    while MOTORCHOICE ~= "apm" & MOTORCHOICE ~= "nsa-i" | isempty(MOTORCHOICE);
        disp('Invalid Input');
        MOTORCHOICE = input('Which motor family you would like to use(APM, NSA-I): ','s');
        MOTORCHOICE = lower(MOTORCHOICE);
    end

    % Defining motor properties for each motor
    if MOTORCHOICE == "apm"
            T_s = 0.19;
            omega_noload = 5000;
            Proceed  = 0; % Switch off loop  
            
    elseif MOTORCHOICE == "nsa-i"
        isnsa = 1;
        while isnsa == 1 
            disp('This family consists of three motors (1,2,3).')
            NSACHOICE = str2double(input('Please choose which motor you would like to use: ','s'));
            NSACHOICE = round(NSACHOICE);
            while NSACHOICE ~= 1 & NSACHOICE ~= 2 & NSACHOICE ~= 3 | isempty(NSACHOICE) | isnan(NSACHOICE)
                NSACHOICE = str2double(input('Invalid input! \nPlease choose which motor you would like to use(1,2,3): ','s'));
                round(NSACHOICE);
            end
            if NSACHOICE == 1 | NSACHOICE == 2 | NSACHOICE == 3
                isnsa = 0;
            end
        end     
        if NSACHOICE == 1
            T_s = 0.43;
            omega_noload = 2750;
            Proceed  = 0; % Switch off loop
        
        elseif NSACHOICE == 2
            T_s = 0.48;
            omega_noload = 8000;
            Proceed  = 0; % Switch off loop
        
        elseif NSACHOICE == 3
            T_s = 0.69;
            omega_noload = 3700;
            Proceed  = 0; % Switch off loop
        end
    end   
end


% Body

if retract == 0
    thet_end = 4.31108478;      %assigns end position
    thet_start = 2.229180482;   %assigns start position
    mDir = 1;                   %direction variable
elseif retract ==1
    thet_end = 2.229180482;
    thet_start = 4.31108478;
    mDir = -1;
end

k = T_s/(omega_noload*2*pi/60);
% T_m = 0.1173;
% T_gear = VR*T_m;

% ======== ODE Solver ========

VRstr = [];
for i = 1:length(VR)

    % ### ODE Options ###
    opts = odeset('RelTol', 10^-4,'Events',@Simple_Pendulum_Event);
    IC = [thet_start, 0];

    % ### Torque components ###
    radius = @(t,z) r - (z(1) - thet_start) * (1/(thet_end-thet_start)) * (r - 0.22254); 
    gravity = @(t,z) -(g/radius(t,z))*cos(z(1)-pi/2);
    motor = @(t,z) (-k*z(2)*VR(i)+mDir*T_s)*VR(i)/(m*radius(t,z)^2);
    damping = @(t,z) -c*z(2)/(m*radius(t,z)^2);
    % snow = 
    % wind = 

    % ### ode45 solver ###
    dz = @(t,z)[ z(2);
                 gravity(t,z) + motor(t,z) + damping(t,z)];

    [t1,z1] = ode45(dz,[0,T],IC,opts);
    thet_vr{i} = z1;

    % ======== Plotting results in a graph ========
    % Graph of angle covered by the roof against time in seconds
    hold on
    plot(t1,z1(:,1));
    % ======== Pendulum Animation Function ========
    % animate_pendulum(t1,z1(:,1))

end
plot(t1,thet_end*ones(size(t1)));
title('Plot of Angle Covered Against Time');
xlabel('time [s]');
ylabel('Angle [rad]');

