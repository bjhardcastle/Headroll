% MAIN FILE FOR VARIANCE ANALYSIS FRAMEWORK
% author: das207@ic.ac.uk
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% folder into stimulus_<freq_number>_1. (See examples)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Summary_plot (bode plot of OL and CL response) parameteres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fly_array = [9, 10, 12, 14, 17]     % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [2,3]                     % numbers of conditions to be included
num_freqs = 9;
framerates = [50, 50, 60, 125, 250, 500, 500, 500, 1000];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Summary_plot (bode plot of OL and CL response) parameteres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


k_factor = 3;                   % Error-bar size, number of std's

                                % Plot in dB or linear units
PlotdB = 0;                     % 1.. dB w/ std in linear space
                                % 2.. dB w/std in log space
                                % 0.. gain 
                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                
clean_runs = 0;                 % Interpolation runs of clean-up files in individual data folders.
tol = 900;                      % Matching score below which interpolation is performed





close all

for fly = 1:length(fly_array)
    for cond = 1:length(cond_array)
        
        % load dataset for one fly/condition pair
%         eval(strcat('load ',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),';'));
        % Go through frequency numbers (p), load stimulus and response,
        % calculate and load time, frequency, HR and TR.
        strcat('FLY',int2str(fly_array(fly)))
        cd(strcat('FLY',int2str(fly_array(fly))))
        run(strcat('loadfran',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.m'));
        cd('../')

        for p = 1:num_freqs
            
            Fs = framerates(p);
            
            
            % For fly10, there is problem for 1 Hz and C3: The sampling
            % frequency / frame rate was as 125 Hz instead of 250 Hz.
            
            if ( fly_array(fly)*10+cond_array(cond) == 103 ) && (p == 5)
                Fs = Fs/2;
            end
            
            
            % Copy average time-courses into data_resp and data_stim, resp.
            
            eval(strcat('data_resp = response_',int2str(name_array(2,p)),'_1;')); 
            eval(strcat('data_stim = stimulus_',int2str(name_array(2,p)),'_1;'));
            resp = data_resp(:,3)';
            stim = data_stim(:,3)';
            
            
            % Response should be in the fly's frame of reference:
            
            resp = stim-resp;
            
            
            find_freq;                  % Find stimulus frequency.
                                        % Max. of FFT of data_stim
            stimfreq = stimfreq_f;

            
%             figure(fly_array(fly)*10+cond_array(cond))
            find_gain_phase_OL;         % Calculate gain and phase using correlation
%             plot_scatter;               % Add points to the scatter plot
            
%             figure(fly_array(fly)*10+cond_array(cond)+5)
            calc_avcycle;               % Extract individual cycles
%             plot_avcycle;               % Plot all cycles            
            
            
            % Add some titles and labels to the figures
            
%             if (p == 8)
%                 xlabel(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
%                 figure(fly_array(fly)*10+cond_array(cond))
%                 xlabel('log10( Frequency / Hz )');
%                 subplot(2,1,1)
%                 ylabel('Magnitude / dB');
%                 subplot(2,1,2)
%                 ylabel('Phase / deg');
%                 mtit(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
%             end
                       
            
        end
        
    end
    
    
   
   
end

calculate_variances;                    % Calculate variances using the (complex) arrays calculated above.
% plot_summary;                           % Plot open-loop and closed-loop bode-plots.
% Tplot_mean_gain_phase; % For bode plot
