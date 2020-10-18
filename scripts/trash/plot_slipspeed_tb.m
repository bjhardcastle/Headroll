% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
% The individual load files in the subfolders where
% these MAT-files are found should be adjusted to load all files in that
% folder into stimulus_<freq_number>_1. (I used modified versions (with 'fran' in the file names) of Daniel's load files)
clear all
rerun=0;

if rerun==1
clear all
    cd('..\Thesis_data\Horseflies\Horseflies_2015\analysis')
% ,
fly_array = [2,3,4,5,6,7,8,9];    % numbers of flies to be included in study (remove fly8, no publishable data)
cond_array = [1,3];                     % numbers of conditions to be included
freq = [1,3,6,10,15,20,25];
num_freqs = length(freq);
project_path = '..\bkup_mats\';
fly_path = 'fly_';
plotted_as_fraction_of_max_stim = 1.5;
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
                resp_vel  = abs(resp_diff(2:length(resp_diff)-1)*Fs);
                stim_vel  = abs(stim_diff(2:length(resp_diff)-1)*Fs);
                
nanstimvals = (stim_vel>plotted_as_fraction_of_max_stim*2*pi*freq(p)*30);
nanrespvals = (resp_vel>plotted_as_fraction_of_max_stim*2*pi*freq(p)*30) ;
    

                resp_vel(nanstimvals)= nan;
                stim_vel(nanstimvals)= nan;
                resp_vel(nanrespvals)= nan;
                stim_vel(nanrespvals)= nan;

                xvalues = linspace(0,plotted_as_fraction_of_max_stim*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
                
                [N,edges] = histcounts(resp_vel(~isnan(resp_vel)),xvalues,'Normalization','probability');
                result(fly,cond,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
                result(fly,cond,p).n_resp=N;
                result(fly,cond,p).mean_resp=nanmedian(resp_vel);
                idx = [];[~,idx]=nanmax(result(fly,cond,p).n_resp);
                result(fly,cond,p).mode_resp = result(fly,cond,p).x_resp(idx);
                
                [N,edges] = histcounts(stim_vel,xvalues,'Normalization','probability');
                result(fly,cond,p).x_stim=(edges(1:end-1)+edges(2:end))/2;
                result(fly,cond,p).n_stim=N;
                result(fly,cond,p).mean_stim=nanmedian(stim_vel);
                       idx = [];[~,idx]=nanmax(result(fly,cond,p).n_stim);
                    result(fly,cond,p).mode_stim = result(fly,cond,p).x_stim(idx);
          
            else
                result(fly,cond,p).x_resp= nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fly,cond,p).n_resp= NaN;
                result(fly,cond,p).mean_resp=NaN;
                result(fly,cond,p).mode_resp = NaN;
                result(fly,cond,p).x_stim=nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fly,cond,p).n_stim=NaN;
                result(fly,cond,p).mean_stim=NaN;
                result(fly,cond,p).mode_stim = NaN;
            end
        end
    end
end
    
    save('DATA_slipspeed_horse2020.mat')
    cd(rootpathHR);
    save('..\mat\DATA_tb_slipspeed.mat')
    tbload = 1;
else
    load ('..\mat\DATA_tb_slipspeed.mat')
    tbload = 1;
end

%% %%% PLOT HISTOGRAMS 
if ~exist('tbload','var')
    clear all
    load ('..\mat\DATA_tb_slipspeed.mat')
    tbload=1;
end
printpath = '..\plots\';
savename = 'slipspeed_pdf';
getHRplotParams;

plotfreqs = [1:7];
c1 = 1; % no ocelli to paint !
c2 = 2; % no ocelli, no halteres
figure('Units','centimeters','Position', [1 1 18 20]);

hist_stim_1 = nan(49,max(fly_array));
hist_stim_2 = nan(49,max(fly_array));
hist_resp_1 = nan(49,max(fly_array));
hist_resp_2 = nan(49,max(fly_array));
Nmin = 99;
Nmax = 0;

for pSELECT = 1:length(plotfreqs)
    
    p = plotfreqs(pSELECT);
    %     figure(p)
    
    for fly = 1:length(fly_array)
                
        % changed to 2,3 from 1,2 now all conditions are stored in .mat
        if ~isempty(result(fly,c1,p).n_resp)
            hist_stim_1(:,fly) = result(fly,c1,p).n_stim;
            hist_resp_1(:,fly) = result(fly,c1,p).n_resp;
        end
        if ~isempty(result(fly,c2,p).n_resp)
            hist_stim_2(:,fly) = result(fly,c2,p).n_stim;
            hist_resp_2(:,fly) = result(fly,c2,p).n_resp;
        end
        
    end
    
    N = max(sum(~isnan(hist_stim_1),2));
    if N>Nmax
        Nmax = N;
    end
    if N<Nmin
        Nmin = N;
    end 

    subplot(1,length(plotfreqs),pSELECT)
    
    
    hold on
 
    lineprops.width = thickLineWidth;
    
    if p>=5
        neIdx = size(result,1);
    else
        neIdx = 1;
    end 
    % plot stim histogram:
    %{
    lineprops.col = {horse_cols{5}};
    mseb(result(neIdx,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(N),lineprops,1);
    %}
    
    % plot intact
    lineprops.col = {darkGreyCol};
    mseb(result(neIdx,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(N),lineprops,1);
      
    % plot no halteres
    lineprops.col = {tb_col};
    mseb(result(neIdx,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(N),lineprops,1);

    hold off
    t = title (['', num2str(freq(p)), ' Hz']);
    set(t,'HorizontalAlignment','right')
    
    if pSELECT == ceil(length(plotfreqs)/2) 
        xlabel('Retinal slipspeed (\circ/s)')
    end
    if pSELECT == 1 
        ylabel('Probability')
    else
        ylabel('')
    end
    
    [maxval] = nanmax([nanmean(hist_resp_1'), nanmean(hist_resp_2')]);
    ylim([0,1.2*maxval])
     
    
    % A vertical line for the theoretical peak of the thorax
    hold on
    sl =  plot([2*pi*freq(p)*30 2*pi*freq(p)*30],[0 max(ylim)],'Color','k','LineWidth',defaultLineWidth,'LineStyle','-');
    uistack(sl(1), 'bottom')
        
    xlim([0,plotted_as_fraction_of_max_stim*2*pi*freq(p)*30])
    
    if freq(p) >= 1
        set(gca,'xtick',[round(2*pi*freq(p)*30,-2)])
    else
        set(gca,'xtick',[round(2*pi*freq(p)*30)])
    end
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
      
    set(gca,'clipping','off')
    pbaspect(gca,[1 1 1])
    setHRaxes(gca,1.5)
end

tightfig(gcf)
if Nmin == Nmax 
    suffix = ['tb_N=' num2str(Nmin)];
else
    suffix = ['tb_N=' num2str(Nmin) 'to' num2str(Nmax)];
end
printHR

%% PLOT MODE SLIPSPEEDS
if ~exist('tbload','var')
    clear all
    load ('..\mat\DATA_tb_slipspeed.mat')
    tbload=1;
end
printpath = '..\plots\';

getHRplotParams
plotfreqs = 1:num_freqs;
manualstim=1;
modeplot = 1;
if modeplot
    savename = 'slipspeed_mode';
else
    savename = 'slipspeed_median';
     manualstim = 0;
end
shadederror = 0;
c1 = 1; % no ocelli to paint !
c2 = 2; % no halteres
N_array = nan(1,num_freqs);
for p = 1:num_freqs
    
    for fly = 1:length(fly_array)
        hist_stim_1(:,fly) = result(fly,c1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fly) = result(fly,c2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_resp_1(:,fly) = result(fly,c1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fly) = result(fly,c2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
    end
    

    if modeplot
        
        mean_s(p)= nanmean([result(:,c1,p).mode_stim,result(:,c2,p).mode_stim]);
        mean_1(p)= nanmean([result(:,c1,p).mode_resp]);
        mean_2(p)= nanmean([result(:,c2,p).mode_resp]);
        
        std_s(p)= nanstd([result(:,c1,p).mode_stim,result(:,c2,p).mode_stim]);
        std_1(p)= nanstd([result(:,c1,p).mode_resp]);
        std_2(p)= nanstd([result(:,c2,p).mode_resp]);

    else
        
        mean_s(p)= nanmean([result(:,c1,p).mean_stim,result(:,c2,p).mean_stim]);
        mean_1(p)= nanmean([result(:,c1,p).mean_resp]);
        mean_2(p)= nanmean([result(:,c2,p).mean_resp]);
        
        std_s(p)= nanstd([result(:,c1,p).mean_stim,result(:,c2,p).mean_stim]);
        std_1(p)= nanstd([result(:,c1,p).mean_resp]);
        std_2(p)= nanstd([result(:,c2,p).mean_resp]);
        
    end
        if manualstim 
        mean_s(p) = 2*pi*freq(p)*30;
        std_s(p) =0;
        end
    
    N_array(p) = sum(~isnan([result(:,c1,p).mean_resp]));
end

figure('Units','centimeters','Position', [1 1 18 20]);
hold on

lineprops.linewidth = thickLineWidth;

% plot stim
lineprops.col = {[0 0 0]};
if manualstim
    ls=plot(freq(plotfreqs), mean_s(plotfreqs),'LineWidth',defaultLineWidth, 'Color',lineprops.col{:});
else
    if shadederror
        ls=mseb(freq(plotfreqs), mean_s(plotfreqs), std_s(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
    else
        ls=errorbar(freq(plotfreqs), mean_s(plotfreqs),std_s(plotfreqs)./sqrt(N_array(plotfreqs)),...
            'LineWidth',lineprops.linewidth, 'Color',lineprops.col{:},'CapSize',0);
    end
end

% plot c2
lineprops.col = {darkGreyCol};
if shadederror
l2=mseb(freq(plotfreqs), mean_2(plotfreqs),std_2(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
else
l2=errorbar(freq(plotfreqs), mean_2(plotfreqs),std_2(plotfreqs)./sqrt(N_array(plotfreqs)),...
    'LineWidth',lineprops.linewidth, 'Color',lineprops.col{:},'CapSize',0);
end

% plot c1
lineprops.col = {tb_col};
if shadederror
    l1=mseb(freq(plotfreqs), mean_1(plotfreqs),std_1(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
else
    l1=errorbar(freq(plotfreqs), mean_1(plotfreqs),std_1(plotfreqs)./sqrt(N_array(plotfreqs)),...
        'LineWidth',lineprops.linewidth, 'Color',lineprops.col{:},'CapSize',0);
end


legCell = {'max. thorax velocity';'intact';'halteres removed'};
if SHOWLEGEND 
if shadederror
    h=legend([ls.mainLine,l1.mainLine,l2.mainLine],legCell{1},legCell{2},legCell{3});
else
    h=legend([ls,l1,l2],legCell{1},legCell{2},legCell{3});
end

h.Location ='northwest';
legend('boxoff')
end

if modeplot
    ylabel('Mode slipspeed ({\circ}/s)')
else
    ylabel('Median slipspeed ({\circ}/s)')
end
xlabel('Frequency (Hz)')

ylim([0 5800])
xlim([0 26])
set(gca,'xtick',[0:5:25]);
set(gca,'ytick',[0:1000:5000]);
set(gca,'xticklabel',{'0';'';'';'';'';'25';})
set(gca,'yticklabel',{'0';'';'';'';'';'5000';})

pbaspect(gca,[1 1 1])
setHRaxes(gca,6,4)
offsetAxes(gca)
%{
upperlim = 7500;
ax = gca;
oldylim = max(ylim);
pbaspect(gca,[1 upperlim/oldylim  1])
ax.YLim(2) = upperlim;
setHRaxes(gca,4*upperlim/oldylim)
%}
if SHOWLEGEND 

h.Position(1) = h.Position(1)-0.05;
h.Position(2) = h.Position(2)+0.05;
h.FontSize = axisLabelFontSize;
end

tightfig(gcf)
% fpos = get(gcf,'position');
% fpos(4) = 1.2*fpos(4);
% set(gcf,'position',fpos)
% ppos = get(gcf,'paperposition');
% ppos(4) = 1.2*ppos(4);
% set(gcf,'paperposition',ppos)
% set(gcf,'paperpositionmode','auto')

if nanmax(N_array)==nanmin(N_array)
    suffix = ['tb_N=' num2str(nanmax(N_array))];
else
    suffix = ['tb_N=' num2str(nanmin(N_array)) 'to' num2str(nanmax(N_array))];
end
 printHR