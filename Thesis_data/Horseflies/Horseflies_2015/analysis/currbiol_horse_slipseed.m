% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% folder into stimulus_<freq_number>_1. (I used modified versions (with 'fran' in the file names) of Daniel's load files)
rerun=1;

if rerun==1;
clear all

% ,
fly_array = [2,3,4,5,6,7,8,9];    % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [1,3];                     % numbers of conditions to be included
freq = [1,3,6,10,15,20,25];
num_freqs = length(freq);
project_path = '..\bkup_mats\';
fly_path = 'fly_';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters
%
% They will be used by the script clean_up.m
tol = 800;                     % Matching score below which interpolation is performed
%power_tol = 1;                % importance of tol in filtering. Higher, tol is more important. 0, tol is not considered. -> 1
N_sigma_in_a_cycle = 25;       % how many sigmas per oscillation cycle - 12,25,50
ugly_fractions = [];           %fractions of points removed

% for high freqs (>10Hz)
sig_filter = [1 2 4 2 1]/10;     % smoothing filter
clean_runs = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for fly = 1:length(fly_array)
    for cond = 1:length(cond_array)
        
        if fly_array(fly) <= 5
        % load dataset for one fly/condition pair
        data_path = [project_path,fly_path,num2str(fly_array(fly)),'\c',num2str(cond_array(cond)),'\'];
        
        elseif fly_array(fly) >= 6
        fly69name = fly_array(fly) - 5;
        fly_path = 'fly_6-9\';
        data_path = [project_path,fly_path];
        end
        
        % Go through frequency numbers (p), load stimulus and response,
        % calculate and load time, frequency, HR and TR.
        
        
        for p = 1:num_freqs
            
            trialidx = 1;
            resp_fname = ['C',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hz_',num2str(trialidx),'_resp.mat'];
            stim_fname = ['C',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hz_',num2str(trialidx),'_stim.mat'];
            
            if fly_array(fly) >= 6
                resp_fname = ['horsefly',num2str(fly69name),'_c',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hzresp.mat'];
                stim_fname = ['horsefly',num2str(fly69name),'_c',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hzstim.mat'];
            end
            
            if exist([data_path resp_fname]) && exist([data_path stim_fname])
                
                load([data_path,resp_fname]);
                resp_data = data;
                load([data_path,stim_fname]);
                stim_data = data;
                
                if length(stim_data)-length(resp_data) ~= 0
                    
                    resp_data(length(resp_data):length(stim_data),1:3)=0;
                end
                
                
if fly_array(fly) >= 6 && p >4

data = resp_data;         
hf_clean_up;
resp_unaligned = data(:,3);
stim_unaligned = stim_data(:,3);
[refstim,aligned_resp,aligned_stim,fps] = hf_remove_prestim(stim_unaligned,resp_unaligned,freq(p),0);
else


                [resp_unaligned,ugly_fraction] = franclean_trace(resp_data, tol);
%                 stim_unaligned = franclean_trace(stim_data, tol); 
stim_unaligned = stim_data(:,3);
                % Get aligned stim/resp data and fps
end

                [refstim,aligned_resp,aligned_stim,fps] = hf_remove_prestim(stim_unaligned,resp_unaligned,freq(p),0);
   
              
                
                sigma = fps/freq(p)/N_sigma_in_a_cycle;
                resp = frangaussian_filtering(aligned_resp,sigma)';
                stim = frangaussian_filtering(aligned_stim,sigma)';
%                 stim = aligned_stim;
%                 figure(1), plot(stim),hold on, plot(resp), pause, hold off
                
                  Fs = fps; 
%                 fitted_sine = FitSine(aligned_stim,round(Fs/freq(p)));
                
                
                amp(fly,cond,p) = round((max(stim) - min(stim)) /2);
%                 amp(fly,cond,p) = round((max(fitted_sine) - min(fitted_sine)) /2);

                
                if p  < 4 
                    resp = resp*29./amp(fly,cond,p);
                    stim = stim*29./amp(fly,cond,p);
                end
                                               
                resp_diff = conv(resp,[1,-1]);
                stim_diff = conv(stim,[1,-1]);
                resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
                stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                
                xvalues = linspace(0,2*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
                
                [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
                result(fly,cond,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
                result(fly,cond,p).n_resp=N;
                result(fly,cond,p).mean_resp=median(resp_vel);
                [N,edges] = histcounts(stim_vel,xvalues,'Normalization','pdf');
                result(fly,cond,p).x_stim=(edges(1:end-1)+edges(2:end))/2;
                result(fly,cond,p).n_stim=N;
                result(fly,cond,p).mean_stim=median(stim_vel);
                
            else
                result(fly,cond,p).x_resp= nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fly,cond,p).n_resp= NaN;
                result(fly,cond,p).mean_resp=NaN;
                result(fly,cond,p).x_stim=nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fly,cond,p).n_stim=NaN;
                result(fly,cond,p).mean_stim=NaN;

            end
        end
    end
end
save('DATA_slipspeed_horse')
else load ('DATA_slipspeed_horse')
end
startup;
%%
% % PLOT HISTOGRAMS
% close all
% for p = 1:num_freqs
%     
%     % individual fly plots
%     
% %      figure(p)
%     
%     for fly = 1:length(fly_array)
% %         subplot(length(fly_array),1,fly)
%         
%         hist_stim_1(:,fly) = result(fly,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
%         hist_stim_2(:,fly) = result(fly,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
%         hist_resp_1(:,fly) = result(fly,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
%         hist_resp_2(:,fly) = result(fly,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
%         
% %         plot(result(fly,1,p).x_stim,hist_stim_1(:,fly))
% %         hold on
% %         plot(result(fly,2,p).x_stim,hist_stim_2(:,fly),'b--')
% %         plot(result(fly,1,p).x_resp, hist_resp_1(:,fly),'r')
% %         plot(result(fly,2,p).x_resp,hist_resp_2(:,fly),'r--')
% %         hold off
%         
%     end
% 
% 
% %%
%     
%     title (['', num2str(freq(p)), ' Hz'])
%     
%     figure(101)
%     
% %     shadedErrorBar(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1 , hist_stim_2]'),'-k',1)
% %     hold on
% %     shadedErrorBar(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1'),{'g','LineWidth',2},1)
% %     shadedErrorBar(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2'),{'b','LineWidth',2},1)
%     
%      lineprops.linewidth = 1.5; 
%     lineprops.col = {horse_cols{5}};
%     mseb(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(5),lineprops,1);
%     hold on
%     lineprops.col = {horse_cols{1}};
%     mseb(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(5),lineprops,1);
%     lineprops.col = {horse_cols{3}};
%     mseb(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(5),lineprops,1);
%     hold off
%     title (['', num2str(freq(p)), ' Hz'])
% 
%     % A vertical line for the theoretical peak of the thorax
%     
%     % enable this if condition when using correct/actual amplitude
%     amp_mean = round(mean(squeeze(mean(amp,2))));
% %     if p ~= 4 % ~45deg amplitude at 1,3,6 Hz
% %     plot([2*pi*freq(p)*amp_mean(1) 2*pi*freq(p)*amp_mean(1)],get(gca,'ylim'),'k')
% %     else % ~30deg amplitude at 10 Hz
%     plot([2*pi*freq(p)*amp_mean(4) 2*pi*freq(p)*amp_mean(4)],get(gca,'ylim'),'k')
% %     end
%     
%     hold off   
%     title (['Frequency = ', num2str(freq(p)), ' Hz'])
%     xlabel('Retinal slip speed [deg/s]')
%     ylabel('Probability density function [s/deg]')
%     
%     [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
%     maxi_s(p) = result(1,1,p).x_stim(index);
%     [maxval, index] = max(nanmean(hist_resp_1'));
%     maxi_1(p) = result(1,1,p).x_resp(index);
%     [maxval, index] = max(nanmean(hist_resp_2'));
%     maxi_2(p) = result(1,2,p).x_resp(index);
%     
%     mean_s(p)= nanmean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
%     mean_1(p)= nanmean([result(:,1,p).mean_resp]);
%     mean_2(p)= nanmean([result(:,2,p).mean_resp]);
%     
%     std_s(p)= nanstd([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
%     std_1(p)= nanstd([result(:,1,p).mean_resp]);
%     std_2(p)= nanstd([result(:,2,p).mean_resp]);
%     
% 
% % %     % save figures
%      set(gcf,'color','w');
% %      export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\tabanus_avg',num2str(freq(p)),'Hz'], '-openGL','-r660')
% % %     
% 
% 
% end
% 
% freq = [1,3,6,10];
% % maxi_s(1:3) = 2*pi*freq(1:3)*45;
% figure(666)
% plot(freq(1:num_freqs), maxi_s(1:num_freqs),'k'); hold on
% plot(freq(1:num_freqs), maxi_1(1:num_freqs),'g')
% plot(freq(1:num_freqs), maxi_2(1:num_freqs),'b')
% xlabel('Frequency of oscillation (Hz)')
% ylabel('Most frequent retinal slip speed (deg/s)')
% 
% figure(667)
% shadedErrorBar(freq(1:num_freqs), mean_1(1:num_freqs),std_1(1:num_freqs),{'g','LineWidth',2},1)
% hold on
% shadedErrorBar(freq(1:num_freqs), mean_2(1:num_freqs),std_2(1:num_freqs),{'b','LineWidth',2},1)
% shadedErrorBar(freq(1:num_freqs), mean_s(1:num_freqs),std_s(1:num_freqs),{'k','LineWidth',2},1)
% xlabel('Frequency of oscillation (Hz)')
% ylabel('Average retinal slip speed (deg/s)')
% 
% 
% % % save figures
% set(gcf,'color','w');
% % export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\tabanus_avgslipspeed'],'-openGL','-r660')
% 
% % fprintf('a fraction %f of ugly points was removed on average (maximum was %f)',mean(ugly_fractions),max(ugly_fractions),'');
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT HISTOGRAMS
startup;
close all
plotfreqs = [1:4];
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
    lineprops.col = {horse_cols{5}};
%     mseb(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(4),lineprops,1);
    hold on
    lineprops.col = {horse_cols{1}};
    mseb(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(4),lineprops,1);
    lineprops.col = {horse_cols{3}};
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
    sl =  plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 2.3*maxval],'Color',horse_cols{5},'LineWidth',1.5,'LineStyle',':')
    uistack(sl(1), 'bottom')
    ylim([0,2.3*maxval])
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
%       export_fig(['Z:\Ben\Current Biology\Figures\tabanus_slipspeedSTANDARDFREQS'], '-openGL','-r660')


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
%     mean_s(p) = 2*pi*freq(p)*30;
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
    lineprops.col = {horse_cols{5}};    
% l1=mseb(freq(1:num_freqs), mean_s(1:num_freqs),std_s(1:num_freqs)./sqrt(4),lineprops,1)
l1=errorbar(freq(1:num_freqs), mean_s(1:num_freqs),std_s(1:num_freqs)./sqrt(4),'LineWidth',lineprops.linewidth, 'Color',horse_cols{5})

hold on
lineprops.col = {horse_cols{3}};
% l3=mseb(freq(1:num_freqs), mean_2(1:num_freqs),std_2(1:num_freqs)./sqrt(4),lineprops,1)
l3=errorbar(freq(1:num_freqs), mean_2(1:num_freqs),std_2(1:num_freqs)./sqrt(4),'LineWidth',lineprops.linewidth, 'Color',horse_cols{3})

lineprops.col = {horse_cols{1}};
% l2=mseb(freq(1:num_freqs), mean_1(1:num_freqs),std_1(1:num_freqs)./sqrt(4),lineprops,1)
l2=errorbar(freq(1:num_freqs), mean_1(1:num_freqs),std_1(1:num_freqs)./sqrt(4),'LineWidth',lineprops.linewidth, 'Color',horse_cols{1})

set(gca,'box','off')
% h=legend([l1.mainLine,l2.mainLine,l3.mainLine],'TR','intact','no halteres')
h=legend([l1,l2,l3],'TR','intact','no halteres')

h.Location ='northwest';
legend('boxoff')
ylabel('Median slip speed [{\circ}/s]')
xlabel('Frequency [Hz]')
xlim([0,28])
ylim([0,4000])
     set(gcf,'color','w');
     psh = plotsize_square_half;
psh(4) = psh(4)*1.7;

     set(gcf,'Position',plotsize_square_half)
     set(gcf,'Clipping','off')
%          export_fig(['Z:\Ben\Current Biology\Figures\slipspeedsMAX_tabanus'], '-painters','-r660')
%     export_fig(['C:\Users\Ben\Desktop\CurrBiol\Figures\slipspeedsMAX_tabanus.eps'], '-painters')
    % painters = opaque !! opengl = transparent