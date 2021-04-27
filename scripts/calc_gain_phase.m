

corr = [];
phase = [];
gain = [];

% save_command_G = strcat('G_fly',int2str(flyidx),'.cond',int2str(cidx),'.freq',int2str(freqs(freqidx)),'=step_vector_G;');

stimperiod = (Fs/stimfreq);                                            % Stimulus Period in samples

L = round(Fs/stimfreq);
num_steps = floor(length(stim)/L)-1;                               % number of cycles which can be individually analyzed

if length(stim) == stimperiod
    num_steps = 1;
end

step_vector_G = zeros(num_steps-1,1);
stim_off = zeros(num_steps-1,1);
resp_off = zeros(num_steps-1,1);
rel_resp_off = zeros(num_steps-1,1);
gain = zeros(num_steps-1,1);

% if  round(freq) == 3, figure, end
for step = 1:num_steps
    
    
    
    stim_win = stim(round((step-1)*stimperiod+1):round((step-1)*stimperiod+L));         % One cycle of stimulus
    stim_off(step) = mean(stim_win);
    stim_win = stim_win - stim_off(step);                                   % Remove offset
    
    corr_est = [];                                                          % crosscorrelation vector
    
    for k = 0:L-1
        
        % here we make use of both rel_resp and resp so we can store a
        % record of individual cycles of both:
        
        resp_win = resp(round((step-1)*stimperiod+k+1):round((step-1)*stimperiod+L+k)); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        resp_off(step) = mean(resp_win);
        resp_win = resp_win - resp_off(step);                               % Remove offset
       
        rel_resp_win = rel_resp(round((step-1)*stimperiod+k+1):round((step-1)*stimperiod+L+k)); % One cycle of stimulus, shifted by k samples w.r.t stim_win
        rel_resp_off(step) = mean(rel_resp_win);
        rel_resp_win = rel_resp_win - rel_resp_off(step);                               % Remove offset
       
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
        if ~exist('bode_rel_first','var') || ~bode_rel_first
            corr_est(k+1) = stim_win*(stim_win-resp_win)';                                 % Calculate inner product, that is, xcorr at phase k.
        else
            corr_est(k+1) = stim_win*rel_resp_win';                                 % Calculate inner product, that is, xcorr at phase k.
        end
        

        
%          if k == 0 && round(freq) == 3 
%            
%             subplot(1,2,1)
%             hold on
%             plot(stim_win)
%             title([ num2str(stimfreq) ', ' num2str(Fs)])
% 
%             subplot(1,2,2)
%             hold on
%             plot(resp_win)
%         end
    end
    
    [corr(step), phaseIdx] = nanmax(corr_est);                              % Find max of xcorr.
    
    phase(step) = -( phaseIdx-1 ) / stimperiod * 2 * pi;                 % Estimate response shift in radians.
    %      if phaseIdx == 1
    %         phase(step) = NaN;
    %     end
%     if phase(step) < -4.7                                                   % Unwrap phase (yes, this is bad practice)
%         phase(step) = phase(step)+(2*pi);
%     end
    
%{
    % % take 'raw' head angle, subtract from thorax angle
     resp_win = -( stim_win - resp_used(round((step-1)*stimperiod+1):round((step-1)*stimperiod+L)) );         % One cycle of stimulus
    
    % take aligned head angle, subtract from thorax angle
    resp_win = -( stim_win - resp_used(round((step-1)*stimperiod+phaseIdx):round((step-1)*stimperiod+L+phaseIdx-1)));     % Reconstruct shifted response at max. xcorr.
        
      % % raw signal:
    % resp_rel = stim_win - (resp_win);
    % % or subtract off mean:
    % resp_rel = stim_win - (resp_win-mean(resp_win));
        
    % % ratio of body/head roll:
    gain(step) =  (resp_win/stim_win);
         gain(step) = (stim_win - resp_win)/stim_win;
         
    % % or relative headroll (neck actuation):
    gain(step) =  abs(resp_win/stim_win);
    gain(step) = (stim_win - resp_used(round((step-1)*stimperiod+phaseIdx):round((step-1)*stimperiod+L+phaseIdx-1)))/stim_win;

   %}


if ~exist('bode_rel_first','var') || ~bode_rel_first
    % take aligned head angle, subtract from thorax angle
    resp_win = ( stim_win - resp_used(round((step-1)*stimperiod+phaseIdx):round((step-1)*stimperiod+L+phaseIdx-1)));     % Reconstruct shifted response at max. xcorr.
else
    % just take aligned head angle (resp is already relative to thorax
    % angle)
    resp_win = -resp_used(round((step-1)*stimperiod+phaseIdx):round((step-1)*stimperiod+L+phaseIdx-1));     % Reconstruct shifted response at max. xcorr.
end
 gain(step) =  abs(resp_win/stim_win);
   

   

    G = gain(step)*exp(1i*phase(step));                                     % Calculate phasor for this cycle.
    
    step_vector_G(step) = G;                                              % Add cycle to step_vector.
    
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
