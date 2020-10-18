% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% % % folder into stimulus_<freq_number>_1. (I used modified versions (with 'fran' in the file names) of Daniel's load files)
rerun = 0;
if rerun == 1
clear all

fly_array = [9, 10, 12, 14, 17]     % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [2,3]                     % numbers of conditions to be included
num_freqs = 9;
framerates = [50, 50, 60, 125, 250, 500, 500, 500, 1000];
freq = [0.06 0.1 0.3 0.6 1 3 6 10 15];
color = 'kgb'

plot_all_histograms = 0 % 1-> plot all histograms 2 -> Nein
plotted_as_fraction_of_max_stim = 1.5 %Histogram with be plotted up to speeds proportional to max stim speed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters        
%
% They will be used to clean and filter the signal                           
tol = 600;                     % Matching score below which interpolation is performed - 600
ugly_fractions = [];           % fractions of points removed
N_sigma_in_a_cycle = 12;       % how many sigmas per oscillation cycle - 12,25,50
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
            
            [resp,ugly_fraction] = clean_trace(data_resp, tol);
            ugly_fractions = [ugly_fractions, ugly_fraction]
            stim = clean_trace(data_stim, tol);

            sigma = framerates(p)/freq(p)/N_sigma_in_a_cycle
            resp = gaussian_filtering(resp,sigma)';
            stim = gaussian_filtering(stim,sigma)';

            resp_diff = conv(resp,[1,-1]);
            stim_diff = conv(stim,[1,-1]);
            resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
            stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                        
            xvalues = linspace(0,plotted_as_fraction_of_max_stim*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
            
            [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
            result(fly,cond,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
            result(fly,cond,p).n_resp=N;
            result(fly,cond,p).mean_resp=median(resp_vel);
            [N,edges] = histcounts(stim_vel,xvalues,'Normalization','pdf');
            result(fly,cond,p).x_stim=(edges(1:end-1)+edges(2:end))/2;
            result(fly,cond,p).n_stim=N;
            result(fly,cond,p).mean_stim=median(stim_vel);

            
        end
    end
end
save('DATA_slipspeed_blowfly')
else
    load('DATA_slipspeed_blowfly')
end
%%% PLOT HISTOGRAMS FRANORIG
% 
% for p = 4:num_freqs
%     
%     for fly = 1:length(fly_array)            
%         hist_stim_1(:,fly) = result(fly,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
%         hist_stim_2(:,fly) = result(fly,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
%         hist_resp_1(:,fly) = result(fly,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
%         hist_resp_2(:,fly) = result(fly,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
%     end
%     
%     if plot_all_histograms == 1
%         figure(p)
%         for fly = 1:length(fly_array)
%             subplot(length(fly_array),1,fly)
%             plot(result(fly,1,p).x_stim,hist_stim_1(:,fly))
%             hold on
%             plot(result(fly,2,p).x_stim,hist_stim_2(:,fly),'b--')
%             plot(result(fly,1,p).x_resp, hist_resp_1(:,fly),'r')
%             plot(result(fly,2,p).x_resp,hist_resp_2(:,fly),'r--')
%             hold off
%             
%         end
%         title (['Frequency = ', num2str(freq(p)), ' Hz'])
%     end
%     
%     figure(100*p)
%     
%     shadedErrorBar(result(1,1,p).x_stim, mean([hist_stim_1 , hist_stim_2]'),std([hist_stim_1 , hist_stim_2]'),color(1))
%     hold on
%     shadedErrorBar(result(1,1,p).x_resp, mean(hist_resp_1'),std(hist_resp_1'),{color(2),'LineWidth',2})
%     shadedErrorBar(result(1,2,p).x_resp, mean(hist_resp_2'),std(hist_resp_2'),{color(3),'LineWidth',2})
%     
%     % A vertical line for the theoretical peak of the thorax
%     plot([2*pi*freq(p)*30 2*pi*freq(p)*30],get(gca,'ylim'),'k') 
%     
%     hold off   
%     title (['Frequency = ', num2str(freq(p)), ' Hz'])
%     xlabel('Retinal slip speed (deg/s)')
%     ylabel('Probability density function (s/deg)')
%     
%     [maxval, index] = max(mean([hist_stim_1 , hist_stim_2]'));
%     maxi_s(p) = result(1,1,p).x_stim(index);
%     [maxval, index] = max(mean(hist_resp_1'));
%     maxi_1(p) = result(1,1,p).x_resp(index);
%     [maxval, index] = max(mean(hist_resp_2'));
%     maxi_2(p) = result(1,2,p).x_resp(index);
%     
%     mean_s(p)= mean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
%     mean_1(p)= mean([result(:,1,p).mean_resp]);
%     mean_2(p)= mean([result(:,2,p).mean_resp]);
%     
%     std_s(p)= std([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
%     std_1(p)= std([result(:,1,p).mean_resp]);
%     std_2(p)= std([result(:,2,p).mean_resp]);
%     
% end
% 
% figure(666)
% plot(freq(4:num_freqs), maxi_s(4:num_freqs),color(1)); hold on
% plot(freq(4:num_freqs), maxi_1(4:num_freqs),color(2))
% plot(freq(4:num_freqs), maxi_2(4:num_freqs),color(3))
% 
% xlabel('Frequency of oscillation (Hz)')
% ylabel('Most frequent retinal slip speed (deg/s)')
% 
% figure(667)
% shadedErrorBar(freq(4:num_freqs), mean_s(4:num_freqs),std_s(4:num_freqs),{color(1),'LineWidth',2})
% hold on
% shadedErrorBar(freq(4:num_freqs), mean_1(4:num_freqs),std_1(4:num_freqs),{color(2),'LineWidth',2})
% shadedErrorBar(freq(4:num_freqs), mean_2(4:num_freqs),std_2(4:num_freqs),{color(3),'LineWidth',2})
% xlabel('Frequency of oscillation (Hz)')
% ylabel('Average retinal slip speed (deg/s)')

%% PLOT HISTOGRAMS
startup;
close all
plotfreqs = [5:8];
% figure(100)
figure('Position', [143 341 600 150]);
for pSELECT = 1:length(plotfreqs)
    
    p = plotfreqs(pSELECT);
%     figure(p)
    
    for fly = 1:length(fly_array)
%         subplot(length(fly_array),1,fly)
        
        hist_stim_1(:,fly) = result(fly,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fly) = result(fly,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_resp_1(:,fly) = result(fly,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fly) = result(fly,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        
%         plot(result(fly,1,p).x_stim,hist_stim_1(:,fly))
%         hold on
%         plot(result(fly,2,p).x_stim,hist_stim_2(:,fly),'b--')
%         plot(result(fly,1,p).x_resp, hist_resp_1(:,fly),'r')
%         plot(result(fly,2,p).x_resp,hist_resp_2(:,fly),'r--')
%         hold off
        
    end
    
%     title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
%     figure(100)

    subplot(1,4,pSELECT)
    
   
    lineprops.linewidth = 1.5; 
    lineprops.col = {color_mat{6}};
%     mseb(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(4),lineprops,1);
    hold on
    lineprops.col = {color_mat{2}};
    mseb(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(4),lineprops,1);
    lineprops.col = {color_mat{4}};
    mseb(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(4),lineprops,1);
    hold off
    title (['', num2str(freq(p)), ' Hz'])
    
    if pSELECT == 2 || pSELECT == 2
        xlabel('                                   Retinal slip speed [deg/s]')
    end
    if pSELECT == 1 || pSELECT == 1
    ylabel('P.D.F. [s/{\circ}]')
    end


    [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    
    
    
    [maxval, index] = max(nanmean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);
    hold on
    
    % A vertical line for the theoretical peak of the thorax
    
    [maxval, index] = max(nanmean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    sl =  plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 2.3*maxval],'Color',color_mat{6},'LineWidth',1.5,'LineStyle',':')
    uistack(sl(1), 'bottom')
    ylim([0,1.5*maxval])
    xlim([0,3*pi*freq(p)*30])   
    set(gca,'xtick',[0,round(2*pi*freq(p)*30,-2)])
    
    mean_s(p)= nanmean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    mean_1(p)= nanmean([result(:,1,p).mean_resp]);
    mean_2(p)= nanmean([result(:,2,p).mean_resp]);
    
    std_s(p)= nanstd([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    std_1(p)= nanstd([result(:,1,p).mean_resp]);
    std_2(p)= nanstd([result(:,2,p).mean_resp]);
    
    set(gca,'yticklabel',[])    
    set(gca,'box','off')
    set(gca,'Layer','top')
    
    % %     % save figures
     set(gcf,'color','w');
% %     

end
%       export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\calliphora_slipspeedSTANDARDFREQS'], '-openGL','-r660')


%% PLOT MAX SLIPSPEEDS
close all
for p = 1:num_freqs
    
    for fly = 1:length(fly_array)        
        hist_stim_1(:,fly) = result(fly,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fly) = result(fly,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_resp_1(:,fly) = result(fly,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fly) = result(fly,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
    end
    
    [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    [maxval, index] = max(nanmean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);  
    [maxval, index] = max(nanmean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    mean_s(p)= nanmean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    mean_1(p)= nanmean([result(:,1,p).mean_resp]);
    mean_2(p)= nanmean([result(:,2,p).mean_resp]);
    
    std_s(p)= nanstd([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    std_1(p)= nanstd([result(:,1,p).mean_resp]);
    std_2(p)= nanstd([result(:,2,p).mean_resp]);
    
end
% figure(666)
% 
% plot(freq(4:num_freqs), maxi_s(4:num_freqs),'k'); hold on
% plot(freq(4:num_freqs), maxi_1(4:num_freqs),'g')
% plot(freq(4:num_freqs), maxi_2(4:num_freqs),'b')

figure(667)
    lineprops.linewidth = 1.5; 
    lineprops.col = {color_mat{6}};
l1=mseb(freq(1:num_freqs), mean_s(1:num_freqs),std_s(1:num_freqs)./sqrt(4),lineprops,1)
hold on
    lineprops.col = {color_mat{4}};

l3=mseb(freq(1:num_freqs), mean_2(1:num_freqs),std_2(1:num_freqs)./sqrt(4),lineprops,1)
    lineprops.col = {color_mat{2}};

l2=mseb(freq(1:num_freqs), mean_1(1:num_freqs),std_1(1:num_freqs)./sqrt(4),lineprops,1)
set(gca,'box','off')
h=legend([l1.mainLine,l2.mainLine,l3.mainLine],'TR','intact','no halteres')
h.Location ='northwest';
legend('boxoff')
ylabel('Median slip speed [{\circ}/s]')
xlabel('Frequency [Hz]')
ylim([0,2000])
xlim([0,15])
     set(gcf,'color','w');
     set(gcf,'Position',plotsize_square_half)
%      export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\calliphora_slipspeedsMAX'], '-openGL','-r660')
    