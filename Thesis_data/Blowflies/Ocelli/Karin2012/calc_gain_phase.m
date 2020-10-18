

corr = [];
phase = [];
gain = [];


% save_command_G = strcat('',int2str(fly),'C',int2str(cond),'A',int2str(amp),'.freq',int2str(freq),'=step_vector_G;');
save_command_G = strcat('Gunit.A',int2str(amp_nr),'C',int2str(cond),'.freq',int2str(freq),'(',int2str(fly),',:)=step_vector_G;');
save_command_H = strcat('Gunit.phaseA',int2str(amp_nr),'C',int2str(cond),'.freq',int2str(freq),'(',int2str(fly),',:)=phase_vector_H;');

% save_command_G = strcat('Pa.',flying_str,'.Gcomplex_C',int2str(cond),'.freq',int2str(freq),'fly(',int2str(fly),',:)=step_vector_G;');

stimperiod = round(Fs/stimfreq);                                            % Stimulus Period in samples
num_steps = floor(length(stim)/stimperiod)-2;                               % number of cycles which can be individually analyzed
L = 2*floor(stimperiod/2);                                                  % Length of each cycke (in samples)


step_vector_G = zeros(num_steps-1,1);
phase_vector_H=zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);

for step = 2:num_steps
    
    stim_win = stim((step-1)*stimperiod+1:(step-1)*stimperiod+L+1);         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    for k = 0:L%+floor(L/4)
    
        resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
        
        corr_est(k+1) = stim_win*resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        
    end
    
    [corr(step), phase(step)]= max(corr_est);                              % Find max of xcorr.
    
%     if phase(step) > L                                                  % Unwrap phase (yes, this is bad practice)
%         phase(step) = phase(step)-L;
%     end
     
    phase(step) = -( phase(step)-1 ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
      
    if phase(step) < -4.7                                                   % Unwrap phase (yes, this is bad practice)
        phase(step) = phase(step)+(2*pi);
    end

    resp_win = resp((step-1)*stimperiod+k+1:(step-1)*stimperiod+L+k+1);     % Reconstruct shifted response at max. xcorr.
    gain(step) = corr(step) /  ( stim_win*stim_win' )  ;                    % Estimate gain.
    G = gain(step)*exp(1i*phase(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step-1) = G;                                              % Add cycle to step_vector.
    phase_vector_H(step-1)=phase(step)*180/pi;
end   

resp_off = resp_off-stim_off;                                               % Calculate DC offset
eval(save_command_G);   
eval(save_command_H);                                                       % Save vector with phasors estimated for each cycle.

% Calculate mean and phase of the fly's response (closed loop).

CL_phase = mean(phase*180/pi);
CL_gain = mean(gain);
CL_phase_std = std(phase*180/pi);
CL_gain_std = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);
