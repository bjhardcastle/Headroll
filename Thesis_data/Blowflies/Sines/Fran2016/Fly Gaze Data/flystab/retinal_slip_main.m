% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% folder into stimulus_<freq_number>_1. (I used modified versions (with 'fran' in the file names) of Daniel's load files)


fly_array = [9, 10, 12, 14, 17]     % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [2,3]                     % numbers of conditions to be included
num_freqs = 9;
framerates = [50, 50, 60, 125, 250, 500, 500, 500, 1000];
freq = [0.06 0.1 0.3 0.6 1 3 6 10 15];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters                                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                
tol = 500;                     % Matching score below which interpolation is performed
power_tol = 1;                 % importance of tol in filtering. Higher, tol is more important. 0, tol is not considered. -> 1
sigma = 3;                     % sigma of the gaussian filter



for fly = 1:length(fly_array)
    for cond = 1:length(cond_array)
        
        % load dataset for one fly/condition pair
        run(strcat('FLY',int2str(fly_array(fly)),'\loadfran',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.m'));
        
        % Go through frequency numbers (p), load stimulus and response,
        % calculate and load time, frequency, HR and TR.
        
        for p = 1:num_freqs
            
            Fs = framerates(p);
            
            % For fly10, there is problem for 1 Hz and C3: The sampling
            % frequency / frame rate was as 125 Hz instead of 250 Hz.
            
            if ( fly_array(fly)*10+cond_array(cond) == 103 ) && (p == 5)
                Fs = Fs/2;
            end
            
            % Copy average time-courses into data_resp and data_stim, resp.
            
            eval(strcat('data_resp = response_',int2str(name_array(2,p+2)),'_1;')); 
            eval(strcat('data_stim = stimulus_',int2str(name_array(2,p+2)),'_1;'));
            resp = data_resp(:,3)';
            stim = data_stim(:,3)';
            
                     
            resp_diff = conv(resp,[1,-1]);
            stim_diff = conv(stim,[1,-1]);
            resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
            stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                        
            xvalues = linspace(0,4*2*pi*freq(p)*30,50); %4 times the maximum angular speed of stim
            
            [n,x] = hist(resp_vel,xvalues);
            result(fly,cond,p).x_resp=x;
            result(fly,cond,p).n_resp=n/length(resp_vel);
            [n,x] = hist(stim_vel,xvalues);
            result(fly,cond,p).x_stim=x;
            result(fly,cond,p).n_stim=n/length(stim_vel);
            
        end
    end
end

for p = 4:num_freqs
    figure(p)
    
    for fly = 1:length(fly_array)
        subplot(length(fly_array),1,fly)
        
        hist_stim_1(:,fly) = result(fly,1,p).n_stim / diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fly) = result(fly,2,p).n_stim / diff(result(fly,2,p).x_stim([1,2]));
        hist_resp_1(:,fly) = result(fly,1,p).n_resp / diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fly) = result(fly,2,p).n_resp / diff(result(fly,2,p).x_resp([1,2]));
                
        plot(result(fly,1,p).x_stim,hist_stim_1(:,fly))
        hold on
        plot(result(fly,2,p).x_stim,hist_stim_2(:,fly),'--')
        plot(result(fly,1,p).x_resp, hist_resp_1(:,fly),'r')
        plot(result(fly,2,p).x_resp,hist_resp_2(:,fly),'r--')
        hold off       
        
    end
    
    title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
    figure(100*p)
    
        shadedErrorBar(result(1,1,p).x_stim, mean([hist_stim_1 , hist_stim_2]'),std([hist_stim_1 , hist_stim_2]'),'-k',1)
        hold on
        shadedErrorBar(result(1,2,p).x_resp, mean(hist_resp_1'),std(hist_resp_1'),{'g','LineWidth',2},1)
        shadedErrorBar(result(1,2,p).x_resp, mean(hist_resp_2'),std(hist_resp_2'),{'b','LineWidth',2},1)
        hold off   
        
        title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
end
