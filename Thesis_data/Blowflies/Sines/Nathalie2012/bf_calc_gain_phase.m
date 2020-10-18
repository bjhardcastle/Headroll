

corr = [];
phase = [];
gain = [];

% save_command_G = strcat('G_fly',int2str(flyidx),'.cond',int2str(cidx),'.freq',int2str(freqs(freqidx)),'=step_vector_G;');

stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod)-1;                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)


step_vector_G = zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);

for step = 1:num_steps
    
    stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+L+1);         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    for k = 0:L-1
    
        resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
        
        corr_est(k+1) = stim_win*resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        
    end
    
    [corr(step), phase(step)] = max(corr_est);                              % Find max of xcorr.
    
    phase(step) = -( phase(step)-1 ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
    
    if phase(step) < -4.7                                                   % Unwrap phase (yes, this is bad practice)
        phase(step) = phase(step)+(2*pi);
    end
    
    resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);     % Reconstruct shifted response at max. xcorr.
    gain(step) = corr(step) /  ( stim_win*stim_win' )  ;                    % Estimate gain.
    G = gain(step)*exp(1i*phase(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step-1) = G;                                              % Add cycle to step_vector.

end   

resp_off = resp_off-stim_off;                                               % Calculate DC offset

% eval(save_command_G);                                                       % Save vector with phasors estimated for each cycle.
   
step_G(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = step_vector_G;

% Calculate mean and phase of the fly's response (closed loop).

CL_phase = mean(phase*180/pi);
CL_gain = mean(gain);
CL_phase_std = std(phase*180/pi);
CL_gain_std = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);
