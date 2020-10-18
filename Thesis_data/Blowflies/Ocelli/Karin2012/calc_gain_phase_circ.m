

corr = [];
phase = [];
gain = [];

save_command_G = strcat('G_fly',int2str(fly),'C',int2str(cond),'A',int2str(amp),'.freq',int2str(freq),'=step_vector_G;');
stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod)-1;                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)

% Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod);                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)


step_vector_G = zeros(num_steps,1);
stim_off = zeros(num_steps,1);
resp_off = zeros(num_steps,1);

for step = 2:num_steps
%     if step == num_steps,
%        stim_win = stim((step-1)*stimperiod+1:end);     % special case for remainder of last cycle
%     else
       stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+stimperiod);     % One cycle of stimulus
%     end
       
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    resp_win = resp((step-1)*stimperiod+1:(step-1)*stimperiod+stimperiod);  % One cycle of stimulus
    
    resp_off(step) = mean(resp_win);
    resp_win = resp_win - resp_off(step);
    
%     if max(resp_win) - min(resp_win) > max(stim_win)-min(stim_win)
%         % if head roll is bigger than stimulus ("negative" gain)
%         % a downwards peak results, away from stimulus. This results in a
%         % phase pi rad out 
        
%     rel_resp_win = stim_win - resp_win;
        rel_resp_win = resp_win;
    
     % shift both resp and stim to align zero crossings.
%      stimvel = conv(stim_win,[1 -1]);
%      [~,xing] = max(stimvel(2:end-1));
%      if xing > 2
%          rel_resp_win = circshift(rel_resp_win,-xing,2);
%          stim_win = circshift(stim_win,-xing,2);
%      end
%      
%      figure(100+freq_nr), hold on, plot(stim_win), hold off
    
    
    for k = 0:stimperiod-1
    
        stim_shifted = circshift(stim_win,k,2); % shift stim_win "backwards" in time by one sample 
        
        corr_est(k+1) = stim_shifted*rel_resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        
    end
    
    [corr(step), phase(step)] = max(corr_est);                              % Find max of xcorr.
    
    phase(step) = -( phase(step) ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
    
    
    if phase(step) < -4.71                                                % Unwrap phase (yes, this is bad practice)
        phase(step) = phase(step)+(2*pi);
    end
    
    gain(step) = corr(step)./(stim_win*stim_win');                    % Estimate gain.
    
    G = gain(step)*exp(1i*phase(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step) = G;                                                % Add cycle to step_vector.
 
 % add a point to a scatter plot for the gain of each cycle
%     if cond_nr == 3 
%     figure(99), hold on, plot(freq,gain,'bx'), hold off 
%     elseif cond_nr == 4
%     figure(99), hold on, plot(freq,gain,'rx'), hold off 
%     end

end   

resp_off = resp_off-stim_off;                                               % Calculate DC offset

eval(save_command_G);                                                       % Save vector with phasors estimated for each cycle.

% Calculate mean and phase of the fly's response (closed loop).

CL_phase = max(phase*180/pi);
CL_gain = nanmean(gain);
CL_phase_std = std(phase*180/pi);
CL_gain_std = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);


