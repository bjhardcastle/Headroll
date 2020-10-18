clc, clear all, 
%%%
%%% % Updated version of 'load_responses.m'
%%%  % Fly 7, C1 shows a good response
%%% Fly numbers in saved data are +1 from the saved data name
%%% So Fly 8 is the good example
%%%
%%% Mean of initial head angle, pre-stim start, is subtracted from the
%%% entire headroll response trace. This aligns all traces well, except C4,
%%% which has large, varying offsets throughout
%%% C4 only exists for 1 fly. (Fly_0)


% Plot to check the region of the stimulus startpoint
plot_stim_startpoint = 1;

% Trial parameters
fps = 500;
trial_duration = 50; % seconds
num_frames = fps*trial_duration;
% time_vect = [0:1/fps:trial_duration-1];

% Preprocessing parameters
clean_runs = 5;                 % number of interpolation runs on raw data
tol = 800;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

conditions{1} = '_WN_no_ocelli_';
conditions{2} = '_WN_dark_';
conditions{3} = '_WN_without_halteres_';
conditions{4} = '_WN_without_halteres_dark_';

for fidx = 0:8
    
    for cidx = 1:4
        
        trial_counter = 0;
        for tidx = 1:15
            trial_counter = trial_counter + 1;
            
            clear data
            data_path = ['.\data\FLY' int2str(fidx) '\'];
            resp_file = ['Fly' int2str(fidx),conditions{cidx},int2str(tidx),'resp.mat'];
            stim_file = ['Fly' int2str(fidx),conditions{cidx},int2str(tidx),'stim.mat'];
            
            if exist(([data_path,resp_file]),'file') &&  exist(([data_path,stim_file]),'file')
                
                
                load([data_path,resp_file])
                disp(resp_file)
                 clean_up;
                resp = data;
                
                clear data
                load([data_path,stim_file]);
                 clean_up;
                stim = data;
                
                [ref_stim,aligned_resp,aligned_stim] = wn_remove_prestim(stim,resp,99,0);
                % Files with errorscore (:,4) of 0 returned as NaNs
                
                
                head = aligned_resp(:,3)*1.15; % Correction applied for camera perspective
                body = aligned_stim(:,3);
                
                headroll.fly(fidx + 1).cond(cidx).trial(:,trial_counter) = head(1:25000);
                stims.fly(fidx + 1).cond(cidx).trial(:,trial_counter) = body(1:25000);
                
            else
                
                headroll.fly(fidx + 1).cond(cidx).trial(:,trial_counter) = nan(25000,1);
                stims.fly(fidx + 1).cond(cidx).trial(:,trial_counter) = nan(25000,1);
            end
            
        end
    end
end

save('WN_DATA.mat', 'headroll', 'stims')