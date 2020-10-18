clear all
load DATA_hf_fixed_sines;

freqs = roundn(stimfreqs,-1);
resp_gain = nan(4,5,6,4);
resp_phase = nan(4,5,6,4);
resp_gain_std = nan(4,5,6,4);
resp_phase_std = nan(4,5,6,4);


for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);
    
    for cidx = 1:4

        for freqidx = 1:5,
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
                stimmat = dir(['reference_stim\',num2str(roundn(stimfreqs(freqidx),-1)),'_',num2str(Fs),'_*.mat']);
                load (['reference_stim\' stimmat.name])
                resp = resp';
                stim = x';
                hf_calc_gain_phase;
                                
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

save('DATA_hf_gain_phase.mat','resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G');

