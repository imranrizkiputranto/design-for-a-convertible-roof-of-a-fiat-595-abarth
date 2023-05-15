function [value, isterminal, direction] = Simple_Pendulum_Event(t,z)
if z(2) > 0     %changes termination angle based on direction of motion
    value = z(1) - 4.31108478; 
elseif z(2) < 0
    value = z(1) - 2.229180482;
else
    value = 1;  %prevents trigger when z(2) = 0
end
isterminal = 1;     % End the ode solver
direction = 0;      % Triggered regardless of direction