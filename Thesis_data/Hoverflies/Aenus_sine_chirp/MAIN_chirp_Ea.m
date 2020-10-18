% MAIN FILE FOR PROCESSING Eristalinus aeneus CHIRP DATA
% c1 - intact
% c2 - ocelli painted, lights on
% c3 - ocelli painted, without halteres, lights on

clear all

load '.\reference_stim\chirp_1200.mat'

flies = [1,2,3,4,5,7];

project_path = '.\data\';
fly_path = 'hoverfly';

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 800;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

% nb different fps used through these experiments
ref_stim = x(1:12000);
fps = 1200;

clear headroll;
for fly_counter = 1:length(flies)
    fly_name = flies(fly_counter);
    display(['fly ',num2str(fly_name),'']);
    
    for cidx = 1:3
        data_path = [project_path,fly_path,num2str(fly_name),'\c',num2str(cidx),'\'];
        
        trial_counter=0;
        if exist(data_path)
            mat_files = dir([data_path,'*chirpHz*.mat']);
            
            % Check even number of files exist (1 stim for each resp)
            if ~mod(length(mat_files),2)
                num_trials = 0.5*length(mat_files);
                
                
                for trial_num = 1: 2: 2*num_trials,
                    trial_counter=trial_counter+1;
                    load([data_path,mat_files(trial_num).name]);
                    
                    %                         clean_up;
                    
                    resp_old_data = data;
                    
                    load([data_path,mat_files(trial_num+1).name]);
                    
                    stim_old_data = data;
                    %                         [data_path,mat_files(trial_num).name]
                    
                    % For fly 1, the framerate is different to the
                    % rest. Upsample, then downsample, to get to the
                    % same framerate..
                    if fly_name == 1
                        S = upsample(stim_old_data,12);
                        R = upsample(resp_old_data,12);
                        stim_old_data = downsample(S,10);
                        resp_old_data = downsample(R,10);
                    end
                    
                    
                    [stim_data,resp_data] = remove_prestim_chirp(stim_old_data,resp_old_data,ref_stim);
                    % also subtracts head offset
                    
                    lenrd = length(resp_data);
                    if  lenrd < 12000
                        resp = resp_data; resp(lenrd+1:12000) = NaN;
                        stim = stim_data; stim(lenrd+1:12000) = NaN;
                    else
                        resp = resp_data(1:12000);
                        stim = stim_data(1:12000);
                    end
                    
                    
                    headroll.fly(fly_counter).cond(cidx).trial(:,trial_counter) = resp;
                    stims.fly(fly_counter).cond(cidx).trial(:,trial_counter) = stim;
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
            
        else % trial doesn't exist
            trial_counter=trial_counter+1;
            headroll.fly(fly_counter).cond(cidx).trial(:,trial_counter) = NaN;
            %                 offset(fly_counter).cond(c).trial(:,trial_counter) = NaN;
            stims.fly(fly_counter).cond(cidx).trial(:,trial_counter) = NaN;
            
            
            
            
        end % condition folder doesn't exist
        trial_counter=trial_counter+1;
        headroll.fly(fly_counter).cond(cidx).trial(:,trial_counter) = NaN;
        %                 offset(fly_counter).cond(c).trial(:,trial_counter) = NaN;
        stims.fly(fly_counter).cond(cidx).trial(:,trial_counter) = NaN;
        
    end
end
save(['DATA_chirp.mat'],'headroll','stims')



