clear all


flies = [2,3,4,5];
stimfreqs = [0.1,1,3.003,6.006,10.01];
freqs = roundn(stimfreqs,-1);

project_path = 'Z:\Ben\Horseflies_2015\bkup_mats\';
fly_path = 'fly_';

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

% nb different fps used through these experiments
% C1 Intact, light
% C2 Intact, dark
% C3 Hs off, light
% C4 Hs off, dark

clear headroll;

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);

    for cidx = 1:4
        cidx;
        data_path = [project_path,fly_path,num2str(fly),'\C',num2str(cidx),'\'];
        
        for freqidx = 1:length(freqs),
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
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
                        
                        % Get reference stim and aligned response data
                        [stim,trimmed_data,aligned_stim,fps] = hf_remove_prestim(stim_data,resp_data,freqs(freqidx),0);
                        
                        % Clean resp data
                        hf_clean_up;
                        
                        
                        % Remove baseline drift by filtering freqs <0.5Hz
                        resp_DC = trimmed_data(:,3);
                        dt_s = 1/fps;
                        f0_hz = 1/dt_s;
                        fcut_hz = 1;
                        [b,a] = butterhigh1(fcut_hz/f0_hz);
                        resp_AC = filtfilt(b,a,resp_DC);
                        % Find offset of response baseline
                        os = mean(resp_AC);
                        resp = resp_AC - os;
                        
                        
                        
                        % Thorax roll - head roll
                        rel_resp = stim - resp;
                        
                        
                        % Smooth response
                        rel_resp = smooth(rel_resp,8);
                        
%                         eval(strcat('headroll.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=rel_resp;'));
%                         eval(strcat('framerates.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=fps;'));
                        
                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = rel_resp;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                        
                    end
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                    
                end % If stim & resp files exist
            end
        end
    end
end
save(['DATA_hf_fixed_sines.mat'],'headroll','framerates','flies','stimfreqs')


