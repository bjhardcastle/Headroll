% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% folder into stimulus_<freq_number>_1. (I used modified versions (with 'fran' in the file names) of Daniel's load files)
clear all

fly_array = [9, 10, 12, 14, 17]     % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [2,3]                     % numbers of conditions to be included
num_freqs = 9;
framerates = [50, 50, 60, 125, 250, 500, 500, 500, 1000];
freq = [0.06 0.1 0.3 0.6 1 3 6 10 15];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters        
%
% They will be used by the script clean_up.m                            
tol = 600;                     % Matching score below which interpolation is performed
%power_tol = 1;                % importance of tol in filtering. Higher, tol is more important. 0, tol is not considered. -> 1
sigma = 3.5; % sigma of the gaussian filter
N_filter = ceil(3*sigma);  % half-width of the gaussian filter, ideally >> sigma
ugly_fractions = [];           %fractions of points removed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for fly = 1:length(fly_array)
    for cond = 1:length(cond_array)
        
        % load dataset for one fly/condition pair
        strcat('FLY',int2str(fly_array(fly)))
        cd(strcat('FLY',int2str(fly_array(fly))))
        run(strcat('loadfran',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.m'));
        cd('../')
        
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
                        
            xvalues = linspace(0,2*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
            
            [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
            result(fly,cond,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
            result(fly,cond,p).n_resp=N;
            result(fly,cond,p).mean_resp=mean(resp_vel);
            [N,edges] = histcounts(stim_vel,xvalues,'Normalization','pdf');
            result(fly,cond,p).x_stim=(edges(1:end-1)+edges(2:end))/2;
            result(fly,cond,p).n_stim=N;
            result(fly,cond,p).mean_stim=mean(stim_vel);

            
        end
    end
end


%%% PLOT HISTOGRAMS

for p = 4:num_freqs
    figure(p)
    
    for fly = 1:length(fly_array)
        subplot(length(fly_array),1,fly)
        
        hist_stim_1(:,fly) = result(fly,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fly) = result(fly,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_resp_1(:,fly) = result(fly,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fly) = result(fly,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
                
        plot(result(fly,1,p).x_stim,hist_stim_1(:,fly))
        hold on
        plot(result(fly,2,p).x_stim,hist_stim_2(:,fly),'b--')
        plot(result(fly,1,p).x_resp, hist_resp_1(:,fly),'r')
        plot(result(fly,2,p).x_resp,hist_resp_2(:,fly),'r--')
        hold off       
        
    end
    
    title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
    figure(100*p)
    
    shadedErrorBar(result(1,1,p).x_stim, mean([hist_stim_1 , hist_stim_2]'),std([hist_stim_1 , hist_stim_2]'),'-k')
    hold on
    shadedErrorBar(result(1,1,p).x_resp, mean(hist_resp_1'),std(hist_resp_1'),{'g','LineWidth',2})
    shadedErrorBar(result(1,2,p).x_resp, mean(hist_resp_2'),std(hist_resp_2'),{'b','LineWidth',2})
    
    % A vertical line for the theoretical peak of the thorax
    plot([2*pi*freq(p)*30 2*pi*freq(p)*30],get(gca,'ylim'),'k') 
    
    hold off   
    title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
    [maxval, index] = max(mean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    [maxval, index] = max(mean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);
    [maxval, index] = max(mean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    
    mean_s(p)= mean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    mean_1(p)= mean([result(:,1,p).mean_resp]);
    mean_2(p)= mean([result(:,2,p).mean_resp]);
    
    std_s(p)= std([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    std_1(p)= std([result(:,1,p).mean_resp]);
    std_2(p)= std([result(:,2,p).mean_resp]);
    
end

figure(666)
plot(freq(4:num_freqs), maxi_s(4:num_freqs),'k'); hold on
plot(freq(4:num_freqs), maxi_1(4:num_freqs),'g')
plot(freq(4:num_freqs), maxi_2(4:num_freqs),'b')

figure(667)
shadedErrorBar(freq(4:num_freqs), mean_s(4:num_freqs),std_s(4:num_freqs),{'k','LineWidth',2})
hold on
shadedErrorBar(freq(4:num_freqs), mean_1(4:num_freqs),std_1(4:num_freqs),{'g','LineWidth',2})
shadedErrorBar(freq(4:num_freqs), mean_2(4:num_freqs),std_2(4:num_freqs),{'b','LineWidth',2})

fprintf('a fraction %f of ugly points was removed on average (maximum was %f)',mean(ugly_fractions),max(ugly_fractions))