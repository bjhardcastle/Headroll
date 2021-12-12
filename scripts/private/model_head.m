function dydt = model_head(t,y,J,k,c,sY,sYt,sV,sVt,rY,rYt)
% input vars:
%   J moment of inertia
%   k rotational stiffness of neck
%   c rotational damping of neck
%   sY stim (thorax) angle, time-dependent
%   sYt time vector for stim angle
%   sV stim velocity, time-dependent
%   sVt time vector for stim velocity
%   rY head response (stabilization effort by plant (muscles) to counter thorax roll)
%   rYt time vector for head response
%   y head angle
% 
% output:
%   dydt(1): head vel
%   dydt(2): head accel

% Interpolate to ensure same lengths
sY = interp1(sYt,sY,t); % stim angle sY at time t
sV = interp1(sVt,sV,t); % stim vel sV at time t
rY = interp1(rYt,rY,t); % resp angle rY at time t

% Evaluate ODE at time
dydt = zeros(2,1);
dydt(1)= y(2);
dydt(2)= -(k/J)*y(1) + (k/J).*sY -(c/J)*y(2) + (c/J).*sV - (1/J).*rY;
