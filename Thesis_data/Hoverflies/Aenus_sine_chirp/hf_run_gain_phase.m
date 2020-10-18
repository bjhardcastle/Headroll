load DATA_hf_fixed_sines.mat

freqs = roundn(stimfreqs,-2);

% (flyidx,freqidx,trialidx,cidx)
resp_gain = nan(length(flies),13,1,3);
resp_phase = nan(length(flies),13,1,3);
resp_gain_std = nan(length(flies),13,1,3);
resp_phase_std = nan(length(flies),13,1,3);

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);
    
    for cidx = 1:3

        for freqidx = 1:13,
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0; 
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
                if (~isnan(headroll(flyidx).cond(cidx).freq(freqidx).trial(1,trialidx))) && ...
                        (size(headroll(flyidx).cond(cidx).freq(freqidx).trial,1) ~= 1) 
                    
                stimfreq = freq;
                Fs = framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx);                         
                resp = headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx); 
                stim = stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx);
                resp = resp';
                stim = stim';
%                 if freq > 12
%                     stim = stim(2401:9600);
%                 end
                hf_calc_gain_phase_REL;
 
                
           %%% Original %%%
           %{
%                 % Attempt to plot negative of gains as -180deg phase shifts
%                 % instead
                if CL_gain < 0 && cidx == 3
                    CL_gain = 0;
%                     CL_phase = CL_phase - 180;
                end
           %}
                   
           
            %%% Added 9/9/2016 %%%               
%                 % Negative gains meaningless so interpret these as gain
%                 of zero
                if CL_gain < 0 
                    CL_gain = 0;
%                     CL_phase = CL_phase - 180;
                end
                    
                resp_gain(flyidx,freqidx,trialidx,cidx) = CL_gain;
                resp_phase(flyidx,freqidx,trialidx,cidx) = CL_phase;
                resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;

                
                else
                    trial_nexist_flag = 1;
                    
                resp_gain(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_phase(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;

                end
                
            end
        end
    end
end


% Plot Bode plot for each condition/amplitude combo
% Get trial mean
resp_gain_mean = nanmean(resp_gain,3);
resp_phase_mean = nanmean(resp_phase,3);
resp_gain_std_mean = nanmean(resp_gain_std,3);
resp_phase_std_mean = nanmean(resp_phase_std,3);

save('DATA_hf_gain_phase.mat','resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std','step_vector_G');

