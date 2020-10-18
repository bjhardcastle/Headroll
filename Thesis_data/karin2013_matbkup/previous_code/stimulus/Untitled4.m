corr_time = 100; %ms
samp_freq = 20000;

steps_per_revolution = 10000;    %max 512000

degrees_per_step = 360/steps_per_revolution;
dt = 1e6/samp_freq;              %microseconds

nsamples = 1*samp_freq;
timestep = 1/samp_freq;
corr_time_samples = corr_time*samp_freq/1000;
pmax = floor(corr_time_samples / 2);  %max number of pulses possible per corr_time
pmin = -pmax;

Vdist = zeros(nsamples,1);
Vdist = randi([20],nsamples,1);
wmax = pmax * samp_freq *degrees_per_step /  corr_time_samples;
[n xout] = hist(Vdist,1000);

OM = zeros(nsamples,1);
for n = 2:nsamples
    OM(n,1) = OM(n-1,1) + (1/corr_time_samples)*(-OM(n-1,1)) + randi([-45,45],1,1);
end

plot(OM)

crossings = find(OM == 0);