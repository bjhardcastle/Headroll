
% Modified Sat 18 May 2013,
% Now calculates delay in ms
% Max corr often found at first point,
% needs to run correlation backwards too, to see phase advance

corr = [];
delay = [];
gain = [];

Fs = 500;
stimfreq = 1;

cgresp = resp{f,c,t}';
% cgstim = stim{f,c,t}';
cgstim = body'
stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(cgstim)/stimperiod)-1;                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)


step_vector_G = zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);

for step = 2:num_steps
    
    stim_win = cgstim((step-1)*stimperiod+1:(step-1)*stimperiod+L+1);         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    for k = 0:L-1
    
        resp_win = cgresp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
        
        corr_est(k+1) = stim_win*resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        
    end
    
    [corr(step), delay(step)] = max(corr_est);                              % Find max of xcorr.

    delay(step) = delay(step)-1 *1000 / Fs;  % Estimate response 
    %delay in ms
    
%     if delay(step) < -4.7                                                   % Unwrap phase (yes, this is bad practice)
%         delay(step) = delay(step)+(2*pi);
%     end
    
    resp_win = cgresp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);     % Reconstruct shifted response at max. xcorr.
    gain(step) = corr(step) /  ( stim_win*stim_win' )  ;                    % Estimate gain.
    G = gain(step)*exp(1i*delay(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step-1) = G;                                              % Add cycle to step_vector.
 
    
end   

resp_off = resp_off-stim_off;                                               % Calculate DC offset


% Calculate mean and phase of the cgresp's response (closed loop).

CL_phase(f,c,t) = mean(delay);
CL_gain(f,c,t) = mean(gain);
CL_phase_std(f,c,t) = std(delay);
CL_gain_std(f,c,t) = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);
