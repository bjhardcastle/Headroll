%% Possible velocities, in deg/s

steps_per_revolution = 10000;    %max 512000
samp_freq = 125000;             %max 125000
corr_time_scale = 5000;               %microseconds

degrees_per_step = 360/steps_per_revolution;
dt = 1e6/samp_freq;              %microseconds

%individual pulses must be at least 2*time_steps apart
step_unit = 2*dt; 

avail_pulse_time = corr_time_scale - dt;
steps_per_second = 1e6./(step_unit * [1 : (floor(avail_pulse_time / step_unit))] );
V = steps_per_second*degrees_per_step; 

plot(V,'.')
axis([0 250 0 600])



%% Velocity distribution
stim_time = 50;%s
corr_time = 5; %ms
nsamples = 50*samp_freq;
timestep = 1/samp_freq;
corr_time_samples = corr_time*samp_freq/1000;
pmax = floor(corr_time_samples / 2);  %max number of pulses possible per corr_time
pmin = -pmax;

Vdist = zeros(nsamples,1);
Vdist = randi([20],nsamples,1);
wmax = pmax * samp_freq *degrees_per_step /  corr_time_samples;
[n xout] = hist(Vdist,1000);

% OM = zeros(nsamples,1);
% for n = 2:nsamples
%     OM(n,1) = OM(n-1,1) + (1/corr_time_samples)*(-OM(n-1,1)) + randi([pmin,pmax],1,1);
% end
% %OM = OM*stim_sd / std(OM);
% 
% for n = 2:nsamples,
