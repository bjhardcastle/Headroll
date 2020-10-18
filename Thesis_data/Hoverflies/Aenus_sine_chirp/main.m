clear all

load ref_stim.mat
ref_stim = ref_stim(1:8000);

flies = [2,3,4,5];
project_path = 'Z:\Karin2016\';
fly_path = 'hoverfly';

% Preprocessing parameters
clean_runs = 10;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter


    clear headroll;
    for fly_counter = 1:length(flies)
        fly = flies(fly_counter)
        
        for c = 1:3
            data_path = [project_path,fly_path,num2str(fly),'\c',num2str(c),'\'];
            
            trial_counter=0;
            if exist(data_path)
                mat_files = dir([data_path,'*.mat']);
                
                % Check even number of files exist (1 stim for each resp)
                if ~mod(length(mat_files),2)
                    num_trials = 0.5*length(mat_files);
                    
                    
                    for trial_num = 1: 2: 2*num_trials,
                        trial_counter=trial_counter+1;
                        load([data_path,mat_files(trial_num).name]);
                        resp_data = data;
                        load([data_path,mat_files(trial_num+1).name]);
                        stim_data = data;
                        
                        [stim_data,resp_data] = remove_prestim(stim_data,resp_data,ref_stim);
                        
                        %                     stim = stim_data(1:8000,3);
                        
                        % Plot scores
                        %                     figure(f)
                        %                     subplot(ceil(0.5*num_trials),2,ceil(0.5*t))
                        %                     plot(resp_data(:,4))
                        %
                        % Clean resp data
                        data = resp_data;
                        clean_up;
                        
                        
                        resp_DC = data(1:8000,3);
                        % Remove baseline drift by filtering freqs <0.5Hz
                        dt_s = 1/1000;
                        f0_hz = 1/dt_s;
                        fcut_hz = 0.5;
                        [b,a] = butterhigh1(fcut_hz/f0_hz);
                        resp_AC = filtfilt(b,a,resp_DC);
                        
                        % Find offset of response baseline
                        os = mean(resp_AC);
                        resp = resp_AC - os;
                        
                        % Thorax roll - head roll
                        resp = ref_stim - resp;
                        % Smooth response
                        resp = smooth(resp,8);
                        
                        headroll(fly_counter).cond(c).trial(:,trial_counter) = resp;
                        offset(fly_counter).cond(c).trial(:,trial_counter) = os;
                        
                        
                        %Plot trials within condition
                        %                     figure
                        %                     plot(resp)
                        
                        
                        
                    end
                else
                    sprintf('Odd number of .mat files in folder. Check for repeated responses.')
                    data_path
                    break
                end
                
            else % condition folder doesn't exist
                trial_counter=trial_counter+1;
                headroll(fly_counter).cond(c).trial(:,trial_counter) = NaN;
                offset(fly_counter).cond(c).trial(:,trial_counter) = NaN;
                
                
                
%             else 
            end
        end
    end
    save(['chirp.mat'],'headroll')


