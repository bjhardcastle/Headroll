% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% c1 - intact
% c2 - ocelli painted, lights on
% c3 - ocelli painted, without halteres, lights on
rerun = 0;

if rerun==1;
    clear all
    
    fly_array = [2,3,4,5,6,7];    % numbers of flies to be included in study (remove fly8, no publishable data)
    cond_array = [2,3];                     % numbers of conditions to be included
    freq = [0.03,0.06,0.1,0.3,0.6,1,3,6.00,10.0,15,20,25];
    num_freqs = length(freq);
    project_path = 'data\';
    fly_path = 'hoverfly';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clean_up parameters
    %
    % They will be used by the script clean_up.m
    tol = 600;                     % Matching score below which interpolation is performed
    %power_tol = 1;                % importance of tol in filtering. Higher, tol is more important. 0, tol is not considered. -> 1
    sigma = 2; % sigma of the gaussian filter
    N_filter = ceil(3*sigma);  % half-width of the gaussian filter, ideally >> sigma
    ugly_fractions = [];           %fractions of points removed
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for fly =1:length(fly_array)
        for cond = 1:length(cond_array)
            
            
            % load dataset for one fly/condition pair
            data_path = [project_path,fly_path,num2str(fly_array(fly)),'\c',num2str(cond_array(cond)),'\'];
            
            
            %         strcat('FLY',int2str(fly_array(fly)))
            %         cd(strcat('FLY',int2str(fly_array(fly))))
            %         run(strcat('loadfran',int2str(fly_array(fly)),'C',int2str(cond_array(cond)),'.m'));
            %         cd('../')
            
            % Go through frequency numbers (p), load stimulus and response,
            % calculate and load time, frequency, HR and TR.
            
            for p = 1:num_freqs
                
                
                % Modifications to load hoverfly data where it exists.
                resp_fname = ['c',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hzresp.mat'];
                stim_fname = ['c',num2str(cond_array(cond)),'_',num2str(freq(p)),'Hzstim.mat'];
                
                if exist([data_path resp_fname]) && exist([data_path stim_fname])
                    
                    
                    load([data_path,resp_fname]);
                    resp_data = data;
                    load([data_path,stim_fname]);
                    stim_data = data;
                    
                    if length(stim_data)-length(resp_data) ~= 0
                        
                        resp_data(length(resp_data):length(stim_data),1:3)=0;
                    end
                    
                    % Get aligned stim/resp data and fps
                    [refstim,aligned_resp,aligned_stim,fps] = hfss_remove_prestim(stim_data,resp_data,freq(p),0);
                    
                    data = aligned_resp;
                    franclean_up;
                    resp = data(:,3)';
                    data = aligned_stim;
                    franclean_up;
                    stim = data(:,3)';
                   
                    
                    Fs = fps;
                    
                    
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
                    edges = nan(1,50);
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
    save('DATA_slipspeed_hover')
else
    load ('DATA_slipspeed_hover')
end

%%
%%% PLOT HISTOGRAMS STANDARD 1,3,6,10 freq range: [5,7,10,12];
startup;
close all
plotfreqs = [8,9,10,11];
figure(100)
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
    lineprops.col = {hov_cols{5}};
    %     mseb(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(5),lineprops,1);
    hold on
    lineprops.col = {hov_cols{1}};
    mseb(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(5),lineprops,1);
    lineprops.col = {hov_cols{3}};
    mseb(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(5),lineprops,1);
    hold off
    title (['', num2str(freq(p)), ' Hz'])
    
    if pSELECT == 2 || pSELECT == 2
        xlabel('                                   Retinal slip speed [deg/s]')
    end
    if pSELECT == 1 || pSELECT == 1
        ylabel('P.D.F.')
    end
    
    
    [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    
    
    
    [maxval, index] = max(nanmean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);
    hold on
    
    % A vertical line for the theoretical peak of the thorax
    %     plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 2*maxval],'k')
    
    [maxval, index] = max(nanmean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    xlim([0,3*pi*freq(p)*30])
    set(gca,'xtick',[0,round(2*pi*freq(p)*30,-2)])
    sl =  plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 1.6*maxval],'Color',hov_cols{5},'LineWidth',1.5,'LineStyle',':')
    uistack(sl(1), 'bottom')
    ylim([0,1.6*maxval])
    
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
%      export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\aeneus_slipspeed_hiHz'], '-openGL','-r660')

%%
%%% PLOT HISTOGRAMS
startup;
close all
plotfreqs = [6:9];
figure(100)
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
    lineprops.col = {hov_cols{5}};
    %     mseb(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(5),lineprops,1);
    hold on
    lineprops.col = {hov_cols{1}};
    mseb(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(5),lineprops,1);
    lineprops.col = {hov_cols{3}};
    mseb(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(5),lineprops,1);
    hold off
    title (['', num2str(freq(p)), ' Hz'])
    
    if pSELECT == 2 || pSELECT == 2
        xlabel('                                   Retinal slip speed [deg/s]')
    end
    if pSELECT == 1 || pSELECT == 1
        ylabel('P.D.F.')
    end
    
    
    [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    
    
    
    [maxval, index] = max(nanmean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);
    hold on
    
    % A vertical line for the theoretical peak of the thorax
    %     plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 2*maxval],'k')
    
    [maxval, index] = max(nanmean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    ylim([0,1.6*maxval])
    xlim([0,3*pi*freq(p)*30])
    set(gca,'xtick',[0,round(2*pi*freq(p)*30,-2)])
    sl =  plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 1.6*maxval],'Color',hov_cols{5},'LineWidth',1.5,'LineStyle',':')
    uistack(sl(1), 'bottom')
    ylim([0,1.6*maxval])
    
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
%       export_fig(['Z:\Ben\Current Biology\Figures\aeneus_slipspeedSTANDARDFREQS'], '-openGL','-r660')


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
%    mean_s(p) = 2*pi*freq(p)*30;
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
lineprops.col = {hov_cols{5}};
% l1=mseb(freq(4:num_freqs), mean_s(4:num_freqs), std_s(4:num_freqs)./sqrt(5),lineprops,1)
l1=errorbar(freq(4:num_freqs), mean_s(4:num_freqs),std_s(4:num_freqs)./sqrt(5),'LineWidth',lineprops.linewidth, 'Color',hov_cols{5})

hold on
lineprops.col = {hov_cols{3}};
% l3=mseb(freq(4:num_freqs), mean_2(4:num_freqs),std_2(4:num_freqs)./sqrt(5),lineprops,1)
l3=errorbar(freq(4:num_freqs), mean_2(4:num_freqs),std_2(4:num_freqs)./sqrt(5),'LineWidth',lineprops.linewidth, 'Color',hov_cols{3})

lineprops.col = {hov_cols{1}};
% l2=mseb(freq(4:num_freqs), mean_1(4:num_freqs),std_1(4:num_freqs)./sqrt(5),lineprops,1)
l2=errorbar(freq(4:num_freqs), mean_1(4:num_freqs),std_1(4:num_freqs)./sqrt(5),'LineWidth',lineprops.linewidth, 'Color',hov_cols{1})

set(gca,'box','off')
% h=legend([l1.mainLine,l2.mainLine,l3.mainLine],'TR','intact','no halteres')
h=legend([l1,l2,l3],'TR','intact','no halteres')

h.Location ='northwest';
legend('boxoff')
ylabel('Median slip speed [{\circ}/s]')
xlabel('Frequency [Hz]')
set(gcf,'color','w');
ylim([0 5800])
xlim([0 28])
psh=plotsize_square_half;
psh(4) = psh(4)*1.7;
set(gcf,'Position',psh)
% export_fig(['Z:\Ben\Current Biology\Figures\slipspeedsMAX_aeneus'], '-painters','-r660')
% export_fig(['C:\Users\Ben\Desktop\CurrBiol\Figures\slipspeedsMAX_aeneus'], '-painters','-r660')