clear all

load ref_stim.mat
ref_stim = ref_stim(1:8000);

wind_cond{1} =('wind');
wind_cond{2} =('no_wind');
flies = [9,10,11,12,13,14,15,16];
% fy 8 has 'no_wind' only
project_path = 'Z:\Karin2015\';
fly_path = 'fly_';
fps = 800;

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 850;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter


for wind_cond_counter = 1:1,
    clear headroll;
    for fly_counter = 1:length(flies)
        fly_name = flies(fly_counter);
        display(['fly ',num2str(fly_name),'']);
        
        for c = 1:5
            data_path = [project_path,fly_path,num2str(fly_name),'\matlab_files\',wind_cond{wind_cond_counter},'\C',num2str(c),'\'];
            
            trial_counter=0;
            if exist(data_path)
                mat_files = dir([data_path,'*.mat']);
                
                % Check even number of files exist (1 stim for each resp)
                if ~mod(length(mat_files),2)
                    num_trials = 0.5*length(mat_files);
                    
                    
                    for trial_num = 1: 2: 2*num_trials,
                        trial_counter=trial_counter+1;
                        load([data_path,mat_files(trial_num).name]);
                        
                        clean_up;
                        
                        resp_old_data = data;
                        
                        load([data_path,mat_files(trial_num+1).name]);
                        stim_old_data = data;
                        %                         [data_path,mat_files(trial_num).name]
                        [stim_data,resp_data] = remove_prestim_chirp(stim_old_data,resp_old_data,ref_stim  );
                        % also subtracts head offset
                        
                        lenrd = length(resp_data);
                        if  lenrd < 8000
                            resp = resp_data; resp(lenrd+1:8000) = NaN;
                            stim = stim_data; stim(lenrd+1:8000) = NaN;
                        else
                            resp = resp_data(1:8000);
                            stim = stim_data(1:8000);
                        end
                        
                        
                        %
                        %                         resp_DC = data(1:8000,3);
                        %                         % Remove baseline drift by filtering freqs <0.5Hz
                        %                         dt_s = 1/1000;
                        %                         f0_hz = 1/dt_s;
                        %                         fcut_hz = 0.5;
                        %                         [b,a] = butterhigh1(fcut_hz/f0_hz);
                        %                         resp_AC = filtfilt(b,a,resp_DC);
                        %
                        %                         % Find offset of response baseline
                        %                         os = mean(resp_AC);
                        %                         resp = resp_AC - os;
                        %
                        %                         % Thorax roll - head roll
                        %                         resp = ref_stim - resp;
                        %                         % Smooth response
                        %                         resp = smooth(resp,8);
                        %
                        headroll.wind(wind_cond_counter).fly(fly_counter).cond(c).trial(:,trial_counter) = resp;
                        stims.wind(wind_cond_counter).fly(fly_counter).cond(c).trial(:,trial_counter) = stim;
                        %                         offset(fly_counter).cond(c).trial(:,trial_counter) = os;
                        %
                        %
                        %                         %Plot trials within condition
                        %                         %                     figure
                        %                         %                     plot(resp)
                        
                        
                        
                    end
                else
                    sprintf('Odd number of .mat files in folder. Check for repeated responses.')
                    data_path
                    break
                end
                
            else % condition folder doesn't exist
                trial_counter=trial_counter+1;
                headroll.wind(wind_cond_counter).fly(fly_counter).cond(c).trial(:,trial_counter) = NaN;
                %                 offset(fly_counter).cond(c).trial(:,trial_counter) = NaN;
                stims.wind(wind_cond_counter).fly(fly_counter).cond(c).trial(:,trial_counter) = NaN;
                
                
                
                
                %             else
            end
        end
    end
    save([wind_cond{wind_cond_counter},'.mat'],'headroll','stims')
end


