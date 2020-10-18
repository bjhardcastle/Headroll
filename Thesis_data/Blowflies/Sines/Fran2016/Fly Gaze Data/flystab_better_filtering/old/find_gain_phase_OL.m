stimperiod = round(Fs/stimfreq);                 % Stimulus Period in samples

num_steps = floor(length(stim)/stimperiod)-1;    % Number of windows/steps 
                                                 % at which the xcorr is to 
                                                 % be evaluated.
                                                
L = 2*floor(stimperiod/2);                       % Window length

corr = [];              % Vector with x-correlations of individual windows/steps.
phase = [];             % Vector with est. phases of indivisual windows/steps.
gain = [];              
gain1 = [];             % Vector with gains estimated by normalized xcorr
gain2 = [];
OL_phase = [];          
OL_gain = [];


% At the end the vectors step_vector_F (open-loop) and step_vector_G (closed-loop) will
% contain open- and closed-loop gain estimates for all steps/windows for
% this one (fly,condition,frequency)-triple.

step_vector_F = [];
step_vector_G = [];


% Define commands to save individual open-loop and closed-loop gain
% estimates. Here, "gain" refers to the complex gain including amplitude
% and phase as a complex number, or phasor.

save_command_F = strcat('F_fly',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.freq',int2str(p),'=step_vector_F;');
save_command_G = strcat('G_fly',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.freq',int2str(p),'=step_vector_G;');


% 



for step = 1:num_steps
    
    stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+L+1);
    stim_win = stim_win - mean(stim_win);
    
    corr_est = [];
    
    for k = 0:L
    
        resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);
        resp_win = resp_win - mean(resp_win);
        
        corr_est(k+1) = stim_win*resp_win';
        
    end
    
    [corr(step), phase(step)] = max(corr_est);
    [a, drift]  = max(corr_est);
    corr(step) = corr(step) / sqrt(sum(stim_win.^2));
    phase(step) = -(phase(step)-1) / stimperiod * 360;
    drift = drift-1;
    
    % Calculate gains
    
    resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);
    gain1(step) = corr(step) / sqrt( sum( stim_win.^2 ) );
    gain_array = resp_win./stim_win;
    gain2(step) = mean(gain_array);
    
    % Calculate phasor.
    % Calculate open-loop gain (Obviously, this only makes physical sense
    % for C3.
    
    G = gain1(step)*exp(1i*phase(step)*pi/180);
    F = G/(1-G);
    
    step_vector_F = [step_vector_F; F];
    step_vector_G = [step_vector_G; G];
    
end


% Save all complex gains as part of structs.

eval(save_command_F);
eval(save_command_G);

