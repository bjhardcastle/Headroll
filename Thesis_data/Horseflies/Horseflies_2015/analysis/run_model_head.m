
% model_head(t,y,I,k,c,sYt,sY,sV,sVt)

stim_freq = 1;
amp = 30;
fps = 1000;
t_step = 1/fps;
t_max = 10; %s
t_length = t_max/t_step;
% Make stimulus trace 
sYt = linspace(t_step,t_max,t_length);
sY = amp*sin(stim_freq*2*pi*st);
% Get stimulus velocity
sV = diff(s(:,1))/t_step;
sVt = linspace(t_step,t_max,length(sV));

% Physical parameters
I = 3.5e-10;
k = 1e-7;
c = 1e-8;

% Solve model equations
tspan = [1 5];
ic = 1;
opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
[t,y] = ode45(@(t,y) model_head(t,y,I,k,c,sYt,sY,sV,sVt), tspan, ic, opts);
