stim_sd = 18;
corr_Tau = 150;
corr_Tau_samples = corr_Tau * 200 /1000;
N_frames = 50*200;
frameshift = zeros(N_frames,1);
frameshift_tf = zeros(N_frames,1);
frameshift_phase = zeros(N_frames,1);



for n = 2:N_frames
    frameshift_tf(n,1) = frameshift_tf(n-1,1) + (1/corr_Tau_samples)*(-frameshift_tf(n-1,1)) + randn(1,1); 
end
frameshift_tf = frameshift_tf*stim_sd / std(frameshift_tf);

plot(frameshift_tf)
