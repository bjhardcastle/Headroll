

corr = [];
phase = [];
gain = [];

% save_command_G = strcat('G_fly',int2str(flyidx),'.cond',int2str(cidx),'.freq',int2str(freqs(freqidx)),'=step_vector_G;');

stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod)-1;                               % number of cycles which can be individually analyzed
if length(stim) == stimperiod
    num_steps = 1;
end
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)


step_vector_G = zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);

for step = 1:num_steps
    
    stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+L);         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    pcorr_est = [];                                                          % crosscorrelation vector
    
    for k = 0:L-1
        
        resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
        %         resp_win = (stim_win - resp_win);                                   % Relative head roll, with sign inverted. (+ve direction = same dir as stimulus)
        pcorr_est(k+1) = stim_win*resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        gcorr_est(k+1) = stim_win*(stim_win-resp_win)';
    end
    
    [corr(step),phaseIdx] = nanmax(pcorr_est);                              % Find max of xcorr.
    %     [,~] = max(gcorr_est);
    
    
    
    %     if phase(step) == 1
    %         phase(step) = NaN;
    %     end
    phase(step) = -( phaseIdx-1 ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
    
    
%     if phase(step) < -4.7                                                  % Unwrap phase (yes, this is bad practice)
%         phase(step) = phase(step)+(2*pi);
%     end
    
    
    
    % gain(step) = corr(step) /  ( stim_win*stim_win' )  ;                    % Estimate gain.
    
    % % take 'raw' head angle, subtract from thorax angle
    % resp_win = resp((step-1)*stimperiod+1:(step-1)*stimperiod+L);         % One cycle of stimulus
    
    % take aligned head angle, subtract from thorax angle
    resp_win = resp((step-1)*stimperiod+phaseIdx+1:(step-1)*stimperiod+L+phaseIdx);     % Reconstruct shifted response at max. xcorr.
    
    % % raw signal:
    % resp_rel = stim_win - (resp_win);
    % % or subtract off mean:
    % resp_rel = stim_win - (resp_win-mean(resp_win));
        
    % % ratio of body/head roll:
    %gain(step) = 1 - (resp_win/stim_win);
    % % or relative headroll (neck actuation):
    %gain(step) =  abs(resp_rel/stim_win);

    gain(step) = (resp_win/stim_win);
    
    % Estimate gain.
    G = gain(step)*exp(1i*phase(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step) = G;                                              % Add cycle to step_vector.
    
end

resp_off = resp_off-stim_off;                                               % Calculate DC offset

% eval(save_command_G);                                                       % Save vector with phasors estimated for each cycle.

step_G(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = step_vector_G;

% Calculate mean and phase of the fly's response (closed loop).
CL_phase=nan;
CL_phase_std=nan;

CL_phase = (circ_mean(phase')*180/pi);
CL_gain = mean(gain);
CL_phase_std = (circ_std(phase')*180/pi);
CL_gain_std = std(gain);

CL_offset = nanmean(sqrt(resp_off.^2));
CL_offset_std = nanstd(resp_off);
