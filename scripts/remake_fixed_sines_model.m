clear all

getHRplotParams
% or manually: bodefilterflag = 0;

flies = [1];

load('..\mat\DATA_model_fixed_sines');
freqs = roundn(stimfreqs,-2);
% hrdata = headroll;
% sdata = stims;
% fdata = framerates;

trial_nexist_flag = 1;

% headroll = struct();
respcycles = struct('cond',struct('freq',[]));
relrespcycles = struct('cond',struct('freq',[]));
stimcycles = struct('cond',struct('freq',[]));
resp_gain = nan(length(flies),length(stimfreqs),10,3);
resp_phase = nan(length(flies),length(stimfreqs),10,3);
resp_gain_std = nan(length(flies),length(stimfreqs),10,3);
resp_phase_std = nan(length(flies),length(stimfreqs),10,3);


for flyidx = 1:length(flies)
    fly = flies(flyidx);
    disp(['fly ',num2str(fly),'']);
    
    
    for cidx = 1
        cidx;
        
        for freqidx = 1:length(freqs)
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;

            for trialidx = 1
                
                    fps = framerates.cond.freq(freqidx).trial;
                    resp_data = headroll.cond.freq(freqidx).trial;
                    stim_data = stims.cond.freq(freqidx).trial;
                    stim_data = stim_data - mean(stim_data);
                    
                    aligned_stim = stim_data;             
                    
                    % Find offset of response baseline
                    os = mean(resp_data);
                    resp = resp_data - os;
                    
                    % relative response:
                    % Thorax roll - head roll
                    rel_resp = -(aligned_stim - resp);
                    % Smooth response
                    rel_resp = smooth(rel_resp,8);
                    
                    % abs response:
                    % Smooth response
                    resp = smooth(resp,8);
                    
                    if bode_rel_first
                        resp_used = rel_resp;
                    else
                        resp_used = resp;
                    end
                                        
                    clear CL_*
                    Fs = fps;
                    stim = aligned_stim;
                    stimfreq = freq;
                    switch freq
                        case 15
                            %                             stimfreq = 15.15;
                            stimfreq = 15;
                        case 10
                            stimfreq = 10;
                        case 6
                            stimfreq = 6.006;
                        case 3
                            stimfreq = 3.003;
                    end
                    if size(stim,1) > size(stim,2)
                        stim = stim';
                    end
                    if size(resp_used,1) > size(resp_used,2)
                        resp_used = resp_used';
                    end
                    
                    calc_gain_phase;
                    
                    
                    resp_gain(flyidx,freqidx,trialidx,cidx) = CL_gain;
                    resp_phase(flyidx,freqidx,trialidx,cidx) = CL_phase;
                    resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                    resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;
                    
                    % reshape resp to store individual cycles: keep adding
                    % to store all cycles from all trials to the same fly
                    if length(respcycles)<flyidx || length(respcycles(flyidx).cond)<cidx || length(respcycles(flyidx).cond(cidx).freq)<freqidx || isempty(respcycles(flyidx).cond(cidx).freq)
                        respcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.resp;
                        relrespcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.rel_resp;
                        stimcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.stim;
                    else
                        respcycles(flyidx).cond(cidx).freq{freqidx} = [respcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.resp ];
                        relrespcycles(flyidx).cond(cidx).freq{freqidx} = [relrespcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.rel_resp ];
                        stimcycles(flyidx).cond(cidx).freq{freqidx} = [stimcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.stim ];
                    end
                    
            end
        end
    end
end
resp_gain_mean = nanmean(resp_gain,3);
resp_phase(isnan(resp_gain)) = nan;
resp_phase_mean = circ_mean(resp_phase*pi/180,[],3)*180/pi;
resp_phase_mean(isnan(resp_gain_mean)) = nan;
resp_phase_std(isnan(resp_gain)) = nan;
resp_gain_std_mean = nanmean(resp_gain_std,3);
resp_phase_std_mean = circ_std(resp_phase_std*pi/180,[],[],3)*180/pi;
resp_phase_std_mean(isnan(resp_gain_std_mean)) = nan;

if bode_rel_first
    save(fullfile(rootpathHR,'..\mat\DATA_model_fixed_sines_rel_first.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_model_gain_phase_rel_first.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
else
    save(fullfile(rootpathHR,'..\mat\DATA_model_fixed_sines.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_model_gain_phase.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
end
