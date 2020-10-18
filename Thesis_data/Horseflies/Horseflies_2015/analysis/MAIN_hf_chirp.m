% Main file for processing Tabanus bromius chirp data
% C1 Intact, light
% C2 Intact, dark
% C3 Hs off, light
% C4 Hs off, dark

clear all

flies = [2,3,4,5];
freqs = [51];

project_path = '..\bkup_mats\';
fly_path = 'fly_';

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 800;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

clear headroll;
for flyidx = 1:length(flies)
    fly = flies(flyidx);
    
    for cidx = 1:4
        data_path = [project_path,fly_path,num2str(fly),'\C',num2str(cidx),'\'];


            freq = 51; freqidx = 1;
            
            trial_nexist_flag = 0; 
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
                resp_fname = ['C',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_resp.mat'];
                stim_fname = ['C',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_stim.mat'];
                
                if exist([data_path resp_fname]) && exist([data_path stim_fname])
                                        
                    load([data_path,resp_fname]);
                    resp_data = data;                   
                    % Clean resp data
                   hf_clean_up;

                    load([data_path,stim_fname]);
                    stim_data = data;
                    
                    if length(stim_data)-length(resp_data) ~= 0
                        
                       sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                       sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                      
                    else
                     
                   % Get reference stim and aligned response data
                   [stim,trimmed_data,aligned_stim,fps] = hf_remove_prestim(stim_data,resp_data,freqs(freqidx),0);
                   
                   resp = trimmed_data;
                   stim = aligned_stim;
                   

                   

                   headroll.fly(flyidx).cond(cidx).trial(:,trialidx) = resp;
                   stims.fly(flyidx).cond(cidx).trial(:,trialidx) = stim;
                    end
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;
                    headroll.fly(flyidx).cond(cidx).trial(:,trialidx) = NaN;
                    stims.fly(flyidx).cond(cidx).trial(:,trialidx) = NaN;

                end % If stim & resp files exist
            end
        end
    end

save(['DATA_horsefly_chirp.mat'],'headroll','stims')


