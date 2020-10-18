

corr = [];
phase = [];
gain = [];


save_command_G = strcat('G_fly',int2str(fly),'C',int2str(cond),'A',int2str(amp),'.freq',int2str(freq),'=step_vector_G;');

stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod);                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)

if num_steps < 1,
    disp([resp_file]), disp(' has less than one cycle.')
else
    

step_vector_G = zeros(num_steps,1);
stim_off = zeros(num_steps,1);
resp_off = zeros(num_steps,1);

for step = 1:num_steps
%     if step == num_steps,
%        stim_win = stim((step-1)*stimperiod+1:end);     % special case for remainder of last cycle
%     else
       stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+L);     % One cycle of stimulus
%     end
       
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    if ((length(resp)-(stimperiod*step))/(stimperiod) < 1 && (length(resp)-(stimperiod*step))/(stimperiod) > 0 )                  % calc correlation right up to 
                                                                            % end of stimulus, incl. incomplete
        L_mod = rem(length(resp),stimperiod)-1;                             % cycles
    else 
        L_mod = L;
    end
    
    for k = 0:L_mod
    
        if (step-1)*stimperiod+L+k > length(resp)
           resp_win = resp((step-1)*stimperiod+k+1:end);
           stim_win = stim_win(1:length(resp_win));
        
        else           
        resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k);  % One cycle of stimulus, shifted by k samples w.r.t stim_win
        end
        
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
        
        corr_est(k+1) = stim_win*resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        
    end
    
    [corr(step), phase(step)] = max(corr_est);                              % Find max of xcorr.
    
    phase(step) = -( phase(step)-1 ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
    
    if phase(step) < -4.7                                                   % Unwrap phase (yes, this is bad practice)
        phase(step) = phase(step)+(2*pi);
    end
    
%     resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);     % Reconstruct shifted response at max. xcorr.
    gain(step) = corr(step)./(stim_win*stim_win');                    % Estimate gain.
    
    if gain(step) == Inf   %%Added 5/6/2013 to temporarily ignore problem of inifinite gains.
        gain(step) = NaN   %% below, changed mean(gain) to nanmean
    end
    
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

CL_phase = mean(phase*180/pi);
CL_gain = nanmean(gain);
CL_phase_std = std(phase*180/pi);
CL_gain_std = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);

end
