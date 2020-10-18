close all

fly_array = [9,12,14,17]        % numbers of flies to be included in study
cond_array = [2,3]              % numbers of conditions to be included

for fly = 1:length(fly_array)
    for cond = 1:length(cond_array)
        
        % load dataset for one fly/condition pair
        
        eval(strcat('load',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),';'));
        
        
        % open figure with number (fly,condition)
        
        
        figure(fly_array(fly)*10+cond_array(cond))

        
        % Go through frequency numbers (p), load stimulus and response,
        % calculate and load time, frequency, HR and TR.
        
        for p = 1:10
            eval(strcat('data_resp = response_',int2str(name_array(2,p)),'_1;')); 
            eval(strcat('data_stim = stimulus_',int2str(name_array(2,p)),'_1;'));
            Fs = data_resp(1,7);
            if ( data_stim(1,7) ~= Fs)
                disp(strcat('Warning: stim/resp sampling rates not identical for Fly',int2str(fly_array(fly)),' and Cond',int2str(cond_array(cond)), ' and freq ',int2str(p)));
            end
            
            time = data_resp(:,6)/Fs; % Create time, stimulus and response
            resp = data_resp(:,3);    % vectors.
            stim = data_stim(:,3);
            stim = stim';
            resp = stim-resp';
            
            stimfreq = name_array(1,p); % Name_array was defined in the load_script
            
            
            find_gain_phase_OL;         % Calculate gain and phase using correlation
            plot_scatter;               % Add point to the scatter plot
        end
    end
    
    
   
   
end

calculate_variances;                    % Calculate variances using the (complex) arrays calculated above.
%plot_summary;


