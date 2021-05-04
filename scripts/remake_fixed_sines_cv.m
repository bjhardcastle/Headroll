clear all

getHRplotParams
% or manually: bodefilterflag = 0;

cd('..\Thesis_data\Blowflies\Sines\Fran2016\Fly Gaze Data\flystab_better_filtering')

fly_array = [9, 10, 12, 14, 17];     % numbers of flies to be included in study (remove fly8, no publishable data)
f2ly_array = [1:9];

cond_array(1,:) = [2,3];                     % numbers of conditions to be included
cond_array(2,:) = [1,3];
% array2: karin2016:
% c1: intact, lights on
% c2: intact, dark
% c3: no halteres, lights on
% c4: no halteres, dark

% f1 = [0.06 0.1 0.3 0.6 1.001 3.003 6.006 10.01 15.148];
f1 = [0.06 0.1 0.3 0.6 1 3 6 10 15];
f2 = [15,20,25];
fpsarray = [50, 50, 60, 125, 250, 500, 500, 500, 1000];

stimfreqs = sort(unique([f1,f2]));
freqs = roundn(stimfreqs,-2);
flies = [fly_array,f2ly_array];
switchIdx = 6; % < switchIdx = first dataset, >= switchIdx = second

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters
%
% They will be used to clean and filter the signal
tol = 700;                     % Matching score below which interpolation is performed - 600
ugly_fractions = [];           % fractions of points removed
N_sigma_in_a_cycle = 25;       % how many sigmas per oscillation cycle - 12,25,50

% for freqs > 15
sig_filter = [1 2 4 2 1]/10;     % smoothing filter
clean_runs = 3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trial_nexist_flag = 1;
headroll = struct();
stims = struct();
respcycles = struct('cond',struct('freq',[]));
relrespcycles = struct('cond',struct('freq',[]));
stimcycles = struct('cond',struct('freq',[]));
resp_gain = nan(length(flies),length(stimfreqs),10,3);
resp_phase = nan(length(flies),length(stimfreqs),10,3);
resp_gain_std = nan(length(flies),length(stimfreqs),10,3);
resp_phase_std = nan(length(flies),length(stimfreqs),10,3);


for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);
    
    for cidx = 1:size(cond_array,2)
        
        %%%%%%%%% inital setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if flyidx < switchIdx
%             %{
            % Fran data folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            condidx = cond_array(1,cidx);
            
            strcat('FLY',int2str(fly));
            cd(strcat('FLY',int2str(fly)))
            run(strcat('loadfran',int2str(fly),'C',int2str(condidx),'.m'));
            cd('../')
            
            % Go through frequency numbers, load stimulus and response, one
            % fly/condition pair
            for freqidx = 1:length(freqs)
                freq = freqs(freqidx);
                if ismember(freq,f1)
                    
                    %                 trial_nexist_flag = 0;
                    trialidx=1;
                    
                    fps = fpsarray(freqidx);
                    % For fly10, there is problem for 1 Hz and C3: The sampling
                    % frequency / frame rate was as 125 Hz instead of 250 Hz.                                       
                    if ( fly*10+condidx == 103 ) && (freq == 1)
                        fps = fps/2;
                    end
                 
                    
                    % Load raw Labview data: (8 channels)
                    eval(strcat('resp_data = response_',int2str(name_array(2,freqidx+2)),'_1;'));
                    eval(strcat('stim_data = stimulus_',int2str(name_array(2,freqidx+2)),'_1;'));
             
%                     try
%                         
%                     [stim,trimmed_data,aligned_stim,fps] = cv_remove_prestim(stim_data,resp_data,freqs(freqidx),bodecheckplots);
%                     
%                     aligned_stim = aligned_stim(:,3);
%                     catch
%                     end
                     
                    % Clean stim data
                    data = stim_data;
                    cv_clean_up;
                    aligned_stim = data(:,3);
                    
                    % Clean resp data
                    data = resp_data;
                    cv_clean_up;
                    resp_DC = data(:,3);
                    
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
                    
                    
                    if size(aligned_stim,2) == size(resp,1) && size(aligned_stim,1) == size(resp,2)
                        aligned_stim = aligned_stim';
                    end
                    
                    % flip resp and stim for this dataset, so initial
                    % deflection is positive angle
                    if freq ~= 15
                    resp = -resp;
                    aligned_stim = -aligned_stim;
                    else
                        resp(1:16)=[];
                        aligned_stim(1:16)=[];
                    end
                    
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
                    stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = aligned_stim;
              
                    
                    % calculate closed loop gain and phase
                    clear CL_*
                    Fs = fps;
                 
                    stim = aligned_stim;
                    if size(stim,1) > size(stim,2)
                        stim = stim';
                    end
                    stimfreq = freq;
                    switch freq
                        case 15
%                             stimfreq = 15.15;
                        stimfreq = 15.148;  
                        case 10
                            stimfreq = 10.01; 
                        case 6
                            stimfreq = 6.006;
                        case 3 
                            stimfreq = 3.003;
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
            %}
        else %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Karin data folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            condidx = cond_array(2,cidx);
            
            project_path = '.\karin2016';
            fly_path = ['\blowfly',num2str(fly),''];
            data_path = [project_path,fly_path,'\c',num2str(condidx),'\'];
            
            % Go through frequency numbers, load stimulus and response, one
            % fly/condition pair
            for freqidx = 1:length(freqs)
                freq = freqs(freqidx);
                
                if ismember(freq,f2)
                    %trial_nexist_flag = 0;
                    trialidx=1;
                    
                    for trialidx = 1:size(resp_gain,3)
                        
                        resp_fname = ['c',num2str(condidx),'_',num2str(freq),'Hz_',num2str(trialidx),'resp.mat'];
                        stim_fname = ['c',num2str(condidx),'_',num2str(freq),'Hz_',num2str(trialidx),'stim.mat'];
                        
                        if exist([data_path resp_fname]) && exist([data_path stim_fname])
                            
                            % Load raw Labview data: (8 channels)
                            load([data_path,resp_fname]);
                            resp_data = data;
                            load([data_path,stim_fname]);
                            stim_data = data;
                                            
                            if length(stim_data)-length(resp_data) ~= 0                                
                                sprintf(['Different lengths: FlyIdx ',num2str(flyidx),' C',num2str(condidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                                sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                            end
                                                
                            [stim,trimmed_data,aligned_stim,fps] = cv_remove_prestim(stim_data,resp_data,freqs(freqidx),bodecheckplots);

                            
                            aligned_stim = aligned_stim(:,3);
                            
                            % Clean resp data
                            data = trimmed_data;
                            cv_clean_up;
                            resp_DC = data(:,3);
                            
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
                            
                            
                            if size(aligned_stim,2) == size(resp,1) && size(aligned_stim,1) == size(resp,2)
                                aligned_stim =aligned_stim';
                            end
                            
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
                            
                            headroll(flyidx).cond(cidx).freq(freqidx).trial(1:length(resp_used),trialidx) = resp_used;
                            framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                            stims(flyidx).cond(cidx).freq(freqidx).trial(1:length(aligned_stim),trialidx) = aligned_stim;
                            
                            % calculate closed loop gain and phase
                            clear CL_*
                            Fs = fps;
                            stim = aligned_stim;
                            if size(stim,1) > size(stim,2)
                                stim = stim';
                            end
                            stimfreq = freq;
                            
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
                        end
                    end
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
    save(fullfile(rootpathHR,'..\mat\DATA_cv_fixed_sines_rel_first.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_cv_gain_phase_rel_first.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
else
    save(fullfile(rootpathHR,'..\mat\DATA_cv_fixed_sines.mat'),'headroll','framerates','stims','flies','stimfreqs','respcycles','stimcycles','relrespcycles');
    save(fullfile(rootpathHR,'..\mat\DATA_cv_gain_phase.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
end

        
