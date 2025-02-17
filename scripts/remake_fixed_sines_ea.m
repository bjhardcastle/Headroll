clear all

getHRplotParams
% or manually: bodefilterflag = 0;

flies = [2,3,4,5,6,7,8]; % flies 9 & 10 weren't flying well; Problem with fly1 at 1Hz pr
stimfreqs = [0.03,0.06,0.1,0.3,0.6,1,3.003,6.00,10.0,15,20,25];
freqs = roundn(stimfreqs,-2);

addpath(cd)
cd('..\Thesis_data\Hoverflies\Aenus_sine_chirp\');
project_path = '.\data\';
fly_path = 'hoverfly';

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter


% nb different fps used through these experiments
trial_nexist_flag = 1;
% headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN(1,10000);
% framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
% stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)=  NaN(1,10000);

headroll = struct();
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
    
    
    for cidx = 1:3
        cidx;
        data_path = [project_path,fly_path,num2str(fly),'\c',num2str(cidx),'\'];
        
        for freqidx = 1:length(freqs)
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;
            trialidx=0;
            
            for trialidx = 1:10
                
                trialstr=num2str(trialidx);
                if trialidx == 1
                    trialstr =[];
                end
                resp_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzresp',trialstr,'.mat'];
                stim_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzstim',trialstr,'.mat'];
                
                if exist([data_path resp_fname]) && exist([data_path stim_fname])
                    
                    load([data_path,resp_fname]);
                    resp_data = data;
                    load([data_path,stim_fname]);
                    stim_data = data;
                      
                    % Get reference stim and aligned response data
                    [stim,trimmed_data,aligned_stim,fps] = ea_remove_prestim(stim_data,resp_data,freqs(freqidx),bodecheckplots);
                    aligned_stim = aligned_stim(:,3);
                    
                    data = trimmed_data;
                    %aligned_stim = aligned_stim(:,3);
                    
                    % Clean resp data
                    ea_clean_up;
                    
                    
                    resp_DC = trimmed_data(:,3);
                    % Remove baseline drift by filtering freqs <0.5Hz
                    if bodefilterflag
                        dt_s = 1/fps;
                        f0_hz = 1/dt_s;
                        fcut_hz = 1;
                        [b,a] = butterhigh1(fcut_hz/f0_hz);
                        resp_AC = filtfilt(b,a,resp_DC);
                    else
                        resp_AC = resp_DC;
                    end
                    
                    % Find offset of response baseline
                    os = mean(resp_AC);
                    resp = resp_AC - os;
                    
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
                    
                    headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = resp_used;
                    framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                    stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= aligned_stim;
                    
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
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;
                    headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                    framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                    stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)=  NaN;
                    resp_gain(flyidx,freqidx,trialidx,cidx) = NaN;
                    resp_phase(flyidx,freqidx,trialidx,cidx) = NaN;
                    resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                    resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;
                    
                end % If stim & resp files exist
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
    save(fullfile(rootpathHR,'..\mat\DATA_ea_fixed_sines_rel_first.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_ea_gain_phase_rel_first.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
else
    save(fullfile(rootpathHR,'..\mat\DATA_ea_fixed_sines.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_ea_gain_phase.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
end
