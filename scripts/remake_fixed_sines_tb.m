clear all

getHRplotParams
% or manually: bodefilterflag = 0;


flies = [2,3,4,5,6,7,8,9];    % numbers of flies to be included in study (remove fly8, no publishable data)

% flies =[2,6]

stimfreqs = [0.1,1,3.003,6.006,10.01,15,20,25];
freqs = roundn(stimfreqs,-1);

cd('..\Thesis_data\Horseflies\Horseflies_2015\analysis\');
project_path = '..\bkup_mats\';
% project_path = 'Z:\Ben\Horseflies_2015\bkup_mats\';
% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter


% nb different fps used through these experiments
% C1 Intact, light
% C2 Intact, dark
% C3 Hs off, light
% C4 Hs off, dark

headroll = struct();
respcycles = struct('cond',struct('freq',[]));
stimcycles = struct('cond',struct('freq',[]));
resp_gain = nan(length(flies),length(stimfreqs),6,4);
resp_phase = nan(length(flies),length(stimfreqs),6,4);
resp_gain_std = nan(length(flies),length(stimfreqs),6,4);
resp_phase_std = nan(length(flies),length(stimfreqs),6,4);

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);
    
    for cidx = 1:4
        cidx;
        
        
        if fly <= 5
            % load dataset for one fly/condition pair
            fly_path = 'fly_';
            data_path = [project_path,fly_path,num2str(fly),'\C',num2str(cidx),'\'];
            
        elseif fly >= 6
            fly69name = fly - 5;
            fly_path = 'fly_6-9\';
            data_path = [project_path,fly_path];
        end
        
        for freqidx = 1:length(freqs)
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;
            trialidx=0;
            
            switch fly
                case {1,2,3,4,5}
                    while trial_nexist_flag == 0 && trialidx<11
                        trialidx = trialidx + 1;
                        
                        if fly <= 5
                            
                            resp_fname = ['C',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_resp.mat'];
                            stim_fname = ['C',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_stim.mat'];
                            if exist([data_path resp_fname]) && exist([data_path stim_fname])
                                
                                load([data_path,resp_fname]);
                                resp_data = data;
                                load([data_path,stim_fname]);
                                stim_data = data;
                                
                                if length(stim_data)-length(resp_data) ~= 0
                                    
                                    sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                                    sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                                    
                                else
                                    if fly==3 && cidx==4 && strcmp(stim_fname,'C4_10Hz_1_stim.mat')
                                        stim_data = stim_data(1:9499,:);
                                        resp_data = resp_data(1:9499,:);
                                    end
                                    
                                    % Get reference stim and aligned response data
                                    [stim,trimmed_data,aligned_stim,fps] = tb_remove_prestim(stim_data,resp_data,freqs(freqidx),bodecheckplots);
                                    aligned_stim = aligned_stim(:,3);

                                    %                                     if size(stim,2) == size(trimmed_data,1) || size(stim,1) == size(trimmed_data,2)
                                    %                                         trimmed_data = trimmed_data';
                                    %                                     end
                                    data = trimmed_data;
                                    % Clean resp data
                                    hf_clean_up;
                                    
                                    
                                    resp_DC = data(:,3);
                                    
                                    if bodefilterflag
                                        % Remove baseline drift by filtering freqs <0.5Hz
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
                                 
                                    % Thorax roll - head roll
                                    if bode_rel_first
                                        rel_resp = aligned_stim - resp;
                                    else
                                        rel_resp =  resp;
                                    end
                                    
                                    % Smooth response
                                    rel_resp = smooth(rel_resp,8);
                                   
                                    
                                    %                         eval(strcat('headroll.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=rel_resp;'));
                                    %                         eval(strcat('framerates.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=fps;'));
     
                                    %{
                                    figure(round(freq*100))
                                    subplot(length(flies),1,flyidx)
                                    title(num2str(freq))
                                    hold on
                                    
                                    %plot(stim,'color','r') % actual
                                    plot(aligned_stim,'color','c') % reference
                                    plot(rel_resp,'color',[ 0.5 0.5 0.5])
                                    title(num2str(fps))
                                    %}
                                    
                                    headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = rel_resp;
                                    framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                                    stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= aligned_stim;
                                    
                                    
                                    clear CL_*
                                    Fs = fps;
                                    stim = aligned_stim';
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
                                    
                                    if size(rel_resp,1) > size(rel_resp,2)
                                        rel_resp = rel_resp';
                                    end
                                    resp = rel_resp;
                                    
                                  
                                    calc_gain_phase;
                                    
                                    
                                    resp_gain(flyidx,freqidx,trialidx,cidx) = CL_gain;
                                    resp_phase(flyidx,freqidx,trialidx,cidx) = CL_phase;
                                    resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                                    resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;
                                    
                              
                                    % reshape resp to store individual cycles: keep adding
                                    % to store all cycles from all trials to the same fly
                                    if length(respcycles)<flyidx || length(respcycles(flyidx).cond)<cidx || length(respcycles(flyidx).cond(cidx).freq)<freqidx || isempty(respcycles(flyidx).cond(cidx).freq)
                                        respcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.resp;
                                        stimcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.stim;
                                    else
                                        respcycles(flyidx).cond(cidx).freq{freqidx} = [respcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.resp ];
                                        stimcycles(flyidx).cond(cidx).freq{freqidx} = [stimcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.stim ];
                                    end
                                    
                                end
                                
                            else % condition folder doesn't exist
                                trial_nexist_flag = 1;
                                headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                                framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                                stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= NaN;
                                
                                resp_gain(flyidx,freqidx,trialidx,cidx) = NaN;
                                resp_phase(flyidx,freqidx,trialidx,cidx) = NaN;
                                resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                                resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;
                                
                            end % If stim & resp files exist
                            
                        end
                    end
                    
                otherwise
                    %only a single trialidx
                    trialidx = trialidx + 1;
                    
                    resp_fname = ['horsefly',num2str(fly69name),'_c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzresp.mat'];
                    stim_fname = ['horsefly',num2str(fly69name),'_c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzstim.mat'];
                    
                    if exist([data_path resp_fname]) && exist([data_path stim_fname])
                        load([data_path,resp_fname]);
                        resp_data = data;
                        load([data_path,stim_fname]);
                        stim_data = data;
                        
                        
                        
                        if length(stim_data)-length(resp_data) ~= 0
                            
                            sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                            sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                            
                        else
                            
                            % Get reference stim and aligned response data
                            [stim,trimmed_data,aligned_stim,fps] = tb_remove_prestim(stim_data,resp_data,freqs(freqidx),bodecheckplots);
                            
                            aligned_stim = aligned_stim(:,3);

                            data = trimmed_data;
                            % Clean resp data
                            hf_clean_up;
                            
                            resp_DC = data(:,3);
                            if bodefilterflag
                                % Remove baseline drift by filtering freqs <0.5Hz
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
                            
                            
                            
                            
                            % Thorax roll - head roll
                            if bode_rel_first
                                rel_resp = aligned_stim - resp;
                            else
                                rel_resp = resp;
                                
                            end
                            
                            % Smooth response
                            rel_resp = smooth(rel_resp,8);
                            
                            
                            
                            %                         eval(strcat('headroll.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=rel_resp;'));
                            %                         eval(strcat('framerates.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=fps;'));
                            
    
                            
                            headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = rel_resp;
                            framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                            stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= aligned_stim;
                            
                            %{
                            figure(round(freq*100))
                            subplot(length(flies),1,flyidx)
                            title(num2str(freq))
                            hold on
                            
                            %plot(stim,'color','r') % actual
                            plot(aligned_stim,'color','c') % reference
                            plot(rel_resp,'color',[0.5 0.5 0.5])
                            title(num2str(fps))
                            %}
                            
                            clear CL_*
                            Fs = fps;
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
                            stim = aligned_stim';
                            if size(stim,1) > size(stim,2)
                                stim = stim';
                            end
                            if size(rel_resp,1) > size(rel_resp,2)
                                rel_resp = rel_resp';
                            end
                            resp = rel_resp;
                            
                            calc_gain_phase;
                            
                            
                            resp_gain(flyidx,freqidx,trialidx,cidx) = CL_gain;
                            resp_phase(flyidx,freqidx,trialidx,cidx) = CL_phase;
                            resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                            resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;
                            
                                               
                            % reshape resp to store individual cycles: keep adding
                            % to store all cycles from all trials to the same fly
                            if length(respcycles)<flyidx || length(respcycles(flyidx).cond)<cidx || length(respcycles(flyidx).cond(cidx).freq)<freqidx || isempty(respcycles(flyidx).cond(cidx).freq)
                                respcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.resp;
                                stimcycles(flyidx).cond(cidx).freq{freqidx} = trial_cycles.stim;
                            else
                                respcycles(flyidx).cond(cidx).freq{freqidx} = [respcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.resp ];
                                stimcycles(flyidx).cond(cidx).freq{freqidx} = [stimcycles(flyidx).cond(cidx).freq{freqidx}, trial_cycles.stim ];
                            end
                    
                            
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
                    
            end % If stim & resp files exist
            
            
        end
    end
end

% Get trial mean
resp_gain_mean = nanmean(resp_gain,3);
resp_phase(isnan(resp_gain)) = nan;
resp_phase_mean = circ_mean(resp_phase*pi/180,[],3)*180/pi;
resp_phase_mean(isnan(resp_gain_mean)) = nan;
resp_phase_std(isnan(resp_gain)) = nan;
resp_gain_std_mean = nanmean(resp_gain_std,3);
resp_phase_std_mean = circ_std(resp_phase_std*pi/180,[],[],3)*180/pi;
resp_phase_std_mean(isnan(resp_gain_std_mean)) = nan;

if bode_rel_first
    save(fullfile(rootpathHR,'..\mat\DATA_tb_gain_phase_rel_first.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
    save(fullfile(rootpathHR,'..\mat\DATA_tb_fixed_sines_rel_first.mat'),'headroll','framerates','flies','stimfreqs','stims','respcycles','stimcycles')
else
    save(fullfile(rootpathHR,'..\mat\DATA_tb_gain_phase.mat'),'resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std', 'step_G','stimfreqs');
    save(fullfile(rootpathHR,'..\mat\DATA_tb_fixed_sines.mat'),'headroll','framerates','flies','stimfreqs','stims','respcycles','stimcycles')
end





