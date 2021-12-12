corr = [];
phase = [];
gain = [];

stimperiod = (Fs/stimfreq);                                                % Stimulus Period in samples

L = round(Fs/stimfreq);
num_steps = floor(length(stim)/L)-1;                                       % number of cycles which can be individually analyzed

if length(stim) == stimperiod
    num_steps = 1;
end

step_vector_G = zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);
rel_resp_off = zeros(num_steps-1,1);
gain = zeros(num_steps-1,1);

for step = 1:num_steps
    
    
    
    stim_win = stim(round((step-1)*stimperiod+1):round((step-1)*stimperiod+L));         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                  % Remove offset
    
    corr_est = [];                                                         % crosscorrelation vector
    
    for k = 0:L-1
        
        % here we make use of both rel_resp and resp so we can store a
        % record of individual cycles of both:
        
        resp_win = resp(round((step-1)*stimperiod+k+1):round((step-1)*stimperiod+L+k)); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                              % Remove offset
        
        rel_resp_win = rel_resp(round((step-1)*stimperiod+k+1):round((step-1)*stimperiod+L+k)); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        rel_resp_off(step) = mean(rel_resp_win);
        rel_resp_win = rel_resp_win - rel_resp_off(step);                  % Remove offset
        
        % store stim and resp cycles
        if step == 1
            trial_cycles = struct('resp',[],'rel_resp',[],'stim',[]);
        end
        if k == 0
            trial_cycles.resp(:,step) = resp_win;
            trial_cycles.rel_resp(:,step) = rel_resp_win;
            trial_cycles.stim(:,step) = stim_win;
        end
        
        % now calculate xcorr with either rel_resp OR resp
        resp_win = resp_used(round((step-1)*stimperiod+k+1):round((step-1)*stimperiod+L+k)); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        if ~exist('bode_rel_first','var') || ~bode_rel_first
            resp_win = -(stim_win-resp_win);
            resp_off(step) = mean(resp_win);
            resp_win = resp_win - resp_off(step);                          % Remove offset
        else
            resp_off(step) = mean(resp_win);
            resp_win = resp_win - resp_off(step);                          % Remove offset
        end
        corr_est(k+1) = stim_win*resp_win';                                % Calculate inner product, that is, xcorr at phase k.
        
        
    end
    
    [corr(step), phaseIdx] = nanmax(corr_est);                             % Find max of xcorr.
    
    if ~exist('bode_rel_first','var') || ~bode_rel_first
        
        phase(step) = -( phaseIdx-1 ) / stimperiod * 2 * pi;               % Estimate response shift in radians.
        
    else
        phase(step) = ( phaseIdx-1 ) / stimperiod * 2 * pi;                % Estimate response shift in radians.
        
    end
    
    
    % Reconstruct shifted response at max. xcorr.
    resp_win = resp_used(round((step-1)*stimperiod+phaseIdx):round((step-1)*stimperiod+L+phaseIdx-1));
    
    if ~exist('bode_rel_first','var') || ~bode_rel_first
        % take aligned head angle, subtract from thorax angle
        resp_win = ( stim_win - resp_win);
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                              % Remove offset
    else
        % just take aligned head angle (resp is already relative to thorax
        % angle)
        resp_win = resp_win;
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                              % Remove offset
    end
    gain(step) =  (resp_win/stim_win);
    
    
    
    
    G = gain(step)*exp(1i*phase(step));                                    % Calculate phasor for this cycle.
    
    step_vector_G(step) = G;                                               % Add cycle to step_vector.
    
end

resp_off = resp_off-stim_off;                                               % Calculate DC offset

% eval(save_command_G);                                                       % Save vector with phasors estimated for each cycle.

step_G(flyidx).cond(cidx).freq(freqidx).trial(1:length(step_vector_G),trialidx) = step_vector_G;

% Calculate mean and phase of the fly's response (closed loop).

CL_phase = (circ_mean(phase')*180/pi);
CL_gain = mean(gain);
CL_phase_std = (circ_std(phase')*180/pi);
CL_gain_std = std(gain);

CL_offset = mean(sqrt(resp_off.^2));
CL_offset_std = std(resp_off);
