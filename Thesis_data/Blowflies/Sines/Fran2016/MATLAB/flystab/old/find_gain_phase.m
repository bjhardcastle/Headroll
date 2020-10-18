stimperiod = Fs/stimfreq;                       % Stimulus Period in samples

num_steps = floor(length(stim)/stimperiod)-2;    % Number of windows/steps 
                                                % at which the xcorr is to 
                                                % be evaluated.
                                                
L = 2*floor(stimperiod/2);                     % Window length

corr = [];
phase = [];
gain = [];
gain1 = [];
gain2 = [];

for step = 1:num_steps
    
    stim_win = stim(step*stimperiod-L/2:step*stimperiod+L/2);
    stim_win = stim_win - mean(stim_win);
    
    corr_est = [];
    
    for k = 0:L
    
        resp_win = resp(step*stimperiod-L/2+k:step*stimperiod+L/2+k);
        resp_win = resp_win - mean(resp_win);
        
        corr_est(k+1) = stim_win*resp_win';
        
    end
    
    [corr(step), phase(step)] = max(corr_est);
    [a, drift]  = max(corr_est);
    corr(step) = corr(step) / sqrt(sum(stim_win.^2));
    phase(step) = -(phase(step)-1) / stimperiod * 360;
    drift = drift-1;
    
    % Calculate gain differently
    
    resp_win = resp(step*stimperiod-L/2+drift:step*stimperiod+L/2+drift);
    gain1(step) = corr(step) / sqrt( sum( stim_win.^2 ) );
    gain_array = resp_win./stim_win;
    gain2(step) = mean(gain_array);
    
    gain_mean(fly_array(fly),cond_array(cond),p) = mean(gain1);
    gain_std(fly_array(fly),cond_array(cond),p) = std(gain1);
    phase_mean(fly_array(fly),cond_array(cond),p) = mean(phase);
    phase_std(fly_array(fly),cond_array(cond),p) = std(phase);
    
end