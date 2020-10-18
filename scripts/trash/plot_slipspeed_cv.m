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
    cd('..\Thesis_data\Blowflies\Sines\Fran2016\Fly Gaze Data\flystab_better_filtering')
    
    fly_array = [9, 10, 12, 14, 17]     % numbers of flies to be included in study (remove fly8, no publishable data)
    f2ly_array = [1:9];
    cond_array = [2,3];                     % numbers of conditions to be included
    c2ond_array = [1,3];
    n2um_freqs = 3;
    num_freqs = 9;
    framerates = [50, 50, 60, 125, 250, 500, 500, 500, 1000];
    freq = [0.06 0.1 0.3 0.6 1 3 6 10 15];
    f2req = [15,20,25];
    color = 'kgb'
    
    plot_all_histograms = 0 % 1-> plot all histograms 2 -> Nein
    plotted_as_fraction_of_max_stim = 1.5 %Histogram with be plotted up to speeds proportional to max stim speed
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clean_up parameters
    %
    % They will be used to clean and filter the signal
    tol = 800;                     % Matching score below which interpolation is performed - 600
    ugly_fractions = [];           % fractions of points removed
    N_sigma_in_a_cycle = 25;       % how many sigmas per oscillation cycle - 12,25,50
    
    % for freqs > 15
    sig_filter = [1 2 4 2 1]/10;     % smoothing filter
    clean_runs = 3;

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
                ugly_fractions = [ugly_fractions, ugly_fraction];
                stim = clean_trace(data_stim, tol);
                
                sigma = framerates(p)/freq(p)/N_sigma_in_a_cycle;
                resp = gaussian_filtering(resp,sigma)';
                stim = gaussian_filtering(stim,sigma)';
                
                resp_diff = conv(resp,[1,-1]);
                stim_diff = conv(stim,[1,-1]);
                resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
                stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                
                nanstimvals = (stim_vel>plotted_as_fraction_of_max_stim*2*pi*freq(p)*30);
                nanrespvals = (resp_vel>plotted_as_fraction_of_max_stim*2*pi*freq(p)*30) ;

                resp_vel(nanstimvals)= nan;
                stim_vel(nanstimvals)= nan;
                resp_vel(nanrespvals)= nan;
                stim_vel(nanrespvals)= nan;
                
                xvalues = linspace(0,plotted_as_fraction_of_max_stim*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
                
                [N,edges] = histcounts(resp_vel,xvalues,'Normalization','probability');
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
                  
                
            end
        end
    end
    
    for f = 1:length(f2ly_array) % fly name in data folder
        fly = f2ly_array(f) + length(fly_array); % fly name in combined results here
        for cond = 1:length(c2ond_array)
            c2ond = cond_array(cond);
            
            project_path = '.\karin2016';
            fly_path = ['\blowfly',num2str(f),''];
            % load dataset for one fly/condition pair
            data_path = [project_path,fly_path,'\c',num2str(c2ond_array(cond)),'\'];
            
            % Go through frequency numbers (p), load stimulus and response,
            % calculate and load time, frequency, HR and TR
            
            for p = 1:n2um_freqs
                p2 = p + num_freqs-1; % to put back into combined results
                trialidx = 1; trial_list = [0,0,0];
                for trialidx = 1:3
                    
                    resp_fname = ['c',num2str(c2ond_array(cond)),'_',num2str(f2req(p)),'Hz_',num2str(trialidx),'resp.mat'];
                    stim_fname = ['c',num2str(c2ond_array(cond)),'_',num2str(f2req(p)),'Hz_',num2str(trialidx),'stim.mat'];
                    if exist([data_path resp_fname]) && exist([data_path stim_fname])
                        trial_list(trialidx) = 1;
                        
                    end
                end
                
                if sum(trial_list) % If any trials exist for this fly/freq/cond combination
                    clear trial_resp trial_stim
                    for trialidx = 1:3
                        resp_fname = ['c',num2str(c2ond_array(cond)),'_',num2str(f2req(p)),'Hz_',num2str(trialidx),'resp.mat'];
                        stim_fname = ['c',num2str(c2ond_array(cond)),'_',num2str(f2req(p)),'Hz_',num2str(trialidx),'stim.mat'];
                        
                        if exist([data_path resp_fname]) && exist([data_path stim_fname])
                            
                            load([data_path,resp_fname]);
                            resp_data = data;
                            load([data_path,stim_fname]);
                            stim_data = data;
                            
                            if length(stim_data)-length(resp_data) ~= 0
                                
                                resp_data(length(resp_data):length(stim_data),1:3)=0;
                            end
                            
                            

                                
                                data = resp_data;
                                clean_up;
                                resp_unaligned = data(:,3);
                                stim_unaligned = stim_data(:,3);
                                [refstim,aligned_resp,aligned_stim,fps] = hf_remove_prestim(stim_unaligned,resp_unaligned,f2req(p),0);
                                      
                                
%                                 [resp_unaligned,ugly_fraction] = franclean_trace(resp_data, tol);
%                                 %                 stim_unaligned = franclean_trace(stim_data, tol);
%                                 stim_unaligned = stim_data(:,3);
%                                 % Get aligned stim/resp data and fps
                            
                            
%                             [refstim,aligned_resp,aligned_stim,fps] = hf_remove_prestim(stim_unaligned,resp_unaligned,f2req(p),0);
                            
                            
                            sigma = fps/f2req(p)/N_sigma_in_a_cycle;
                            resp = frangaussian_filtering(aligned_resp,sigma)';
                            stim = frangaussian_filtering(aligned_stim,sigma)';
%                             resp = aligned_resp;stim = aligned_stim;
                            %                 figure(1), plot(stim),hold on, plot(resp), pause, hold off
                            
                            Fs = fps;
                            %                 amp(fly,cond,p) = round((max(stim) - min(stim)) /2);
                            %                 if p < 4
                            %                     resp = resp*29./amp(fly,cond,p);
                            %                     stim = stim*29./amp(fly,cond,p);
                            %                 end
                            
                            
                            %%%%%%%%%%  find average of up to three trials..
                            trial_resp(trialidx,:) = resp;
                            trial_stim(trialidx,:) = stim;
                        end
                    end
                    resp = []; stim = [];
                    resp = sum(trial_resp)/sum(trial_list);
                    stim = sum(trial_stim)/sum(trial_list);
                    
                    
%                     amp(fly,cond,p) = round((max(stim) - min(stim)) /2);
%                     if p < 4
%                         resp = resp*29./amp(fly,cond,p);
%                         stim = stim*29./amp(fly,cond,p);
%                     end
                            

                    
                    resp_diff = conv(resp,[1,-1]);
                    stim_diff = conv(stim,[1,-1]);
                    resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
                    stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                      
                    nanstimvals = (stim_vel>plotted_as_fraction_of_max_stim*2*pi*f2req(p)*30);
                    nanrespvals = (resp_vel>plotted_as_fraction_of_max_stim*2*pi*f2req(p)*30) ;

                resp_vel(nanstimvals)= nan;
                stim_vel(nanstimvals)= nan;
                resp_vel(nanrespvals)= nan;
                stim_vel(nanrespvals)= nan;
                    xvalues = linspace(0,plotted_as_fraction_of_max_stim*2*pi*f2req(p)*30,50); %2 times the maximum angular speed of stim
                    
                    
                    [N,edges] = histcounts(resp_vel,xvalues,'Normalization','probability');
                    result(fly,cond,p2).x_resp=(edges(1:end-1)+edges(2:end))/2;
                    result(fly,cond,p2).n_resp=N;
                    result(fly,cond,p2).mean_resp=nanmedian(resp_vel);
                     idx = [];[~,idx]=nanmax(result(fly,cond,p2).n_resp);
                    result(fly,cond,p2).mode_resp = result(fly,cond,p2).x_resp(idx);
                    [N,edges] = histcounts(stim_vel,xvalues,'Normalization','probability');
                    result(fly,cond,p2).x_stim=(edges(1:end-1)+edges(2:end))/2;
                    result(fly,cond,p2).n_stim=N;
                    result(fly,cond,p2).mean_stim=nanmedian(stim_vel);
                    idx = [];[~,idx]=nanmax(result(fly,cond,p2).n_stim);
                    result(fly,cond,p2).mode_stim = result(fly,cond,p2).x_stim(idx);
                  
                else
                    
                    result(fly,cond,p2).x_resp= nan(1,length((edges(1:end-1)+edges(2:end))/2));
                    result(fly,cond,p2).n_resp= NaN;
                    result(fly,cond,p2).mean_resp=NaN;
                       result(fly,cond,p2).mode_resp = NaN;
                    result(fly,cond,p2).x_stim=nan(1,length((edges(1:end-1)+edges(2:end))/2));
                    result(fly,cond,p2).n_stim=NaN;
                    result(fly,cond,p2).mean_stim=NaN;
                       result(fly,cond,p2).mode_stim = NaN;
                    
                end
            end
        end
    end
    
    save('DATA_slipspeed_blowfly2020.mat')
    cd('G:\My Drive\Headroll\scripts\');
    save('..\mat\DATA_cv_slipspeed.mat')
    cvload = 1;
else
    load('..\mat\DATA_cv_slipspeed.mat')    
    cvload = 1;
end


%% %%% PLOT HISTOGRAMS 
if ~exist('cvload','var')
    clear all
    load ('..\mat\DATA_cv_slipspeed.mat')
    cvload=1;
end
printpath = '..\plots\';
savename = 'slipspeed_pdf';

getHRplotParams;

freq = [0.06 0.1 0.3 0.6 1 3 6 10,15,20,25];
plotfreqs = [5,6,7,8,9,10,11];
c1 = 1; % no ocelli
c2 = 2; % no ocelli, no halteres
figure('Units','centimeters','Position', [1 1 18 20]);

%{
for fidx=1:2
    switch fidx
        case 1
            pRange = 1:num_freqs;
            fRange = 1:length(fly_array);
        case 2
            pRange = num_freqs:num_freqs+n2um_freqs-1;
            fRange = length(fly_array)+1 : length(fly_array) + length(f2ly_array);
    end
    
for pidx = 1:length(pRange)
   p = pRange(pidx); 
   
    for fidx = 1:length(fRange)
        fly = fRange(fidx);
      
 %}
hist_stim_1 = nan(49,max([fly_array,f2ly_array]));
hist_stim_2 = nan(49,max([fly_array,f2ly_array]));
hist_resp_1 = nan(49,max([fly_array,f2ly_array]));
hist_resp_2 = nan(49,max([fly_array,f2ly_array]));
Nmin = 99;
Nmax = 0;

for pSELECT = 1:length(plotfreqs)
    
    
    p = plotfreqs(pSELECT);
    %     figure(p)
    
    for fly = 1:length(fly_array)
        if ~isempty(result(fly,c1,p).n_resp)
            hist_stim_1(:,fly) = result(fly,c1,p).n_stim;
            hist_stim_2(:,fly) = result(fly,c2,p).n_stim;
            hist_resp_1(:,fly) = result(fly,c1,p).n_resp;
            hist_resp_2(:,fly) = result(fly,c2,p).n_resp;            
        end
    end
    
    for fly = length(fly_array)+1 : length(fly_array) + length(f2ly_array)
        if ~isempty(result(fly,c1,p).n_resp)
            hist_stim_1(:,fly) = result(fly,c1,p).n_stim;
            hist_stim_2(:,fly) = result(fly,c2,p).n_stim;
            hist_resp_1(:,fly) = result(fly,c1,p).n_resp;
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
    
    if p>=9
        neIdx = size(result,1);
    else
        neIdx = 1;
    end 
    % plot stim histogram:
    %{
    lineprops.col = {hov_cols{5}};
    mseb(result(neIdx,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1,hist_stim_2]')./sqrt(N),lineprops,1);
    %}
       % plot no halteres

    lineprops.col = {darkGreyCol};
    mseb(result(neIdx,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2')/sqrt(N),lineprops,1);
      
        % plot intact
lineprops.col = {cv_col};
    mseb(result(neIdx,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1')/sqrt(N),lineprops,1);

    hold off
    t = title (['', num2str(freq(p)), ' Hz']);
    try
        set(gca,'TitleHorizontalAlignment','left')
    catch
        set(t,'HorizontalAlignment','right')
    end
    
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
    suffix = ['cv_N=' num2str(Nmin)];
else
    suffix = ['cv_N=' num2str(Nmin) 'to' num2str(Nmax)];
end
printHR


%% PLOT MODE SLIPSPEEDS
if ~exist('cvload','var')
    clear all
    load ('..\mat\DATA_cv_slipspeed.mat')
    cvload=1;
end


printpath = '..\plots\';

freq = [0.06 0.1 0.3 0.6 1 3 6 10,15,20,25];

getHRplotParams
plotfreqs = 2:length(freq);
manualstim = 1;
modeplot = 1;
if modeplot
    savename = 'slipspeed_mode';
else
    savename = 'slipspeed_median';
    manualstim = 0;
end
shadederror = 0;
c1 = 1; % ocelli painted
c2 = 2; % ocelli painted, no halteres
N_array = nan(1,length(freq));
for fidx=1:2
    switch fidx
        case 1
            pRange = 1:num_freqs;
            fRange = 1:length(fly_array);
        case 2
            pRange = num_freqs:num_freqs+n2um_freqs-1;
            fRange = length(fly_array)+1 : length(fly_array) + length(f2ly_array);
    end
    
for pidx = 1:length(pRange)
    p = pRange(pidx); 
   
    for fidx = 1:length(fRange)
        fly = fRange(fidx);
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
end

figure('Units','centimeters','Position', [1 1 18 20]);
hold on

lineprops.width = thickLineWidth;

% plot stim
lineprops.col = {[0 0 0]};
if manualstim
    ls=plot(freq(plotfreqs), mean_s(plotfreqs),'LineWidth',defaultLineWidth, 'Color',lineprops.col{:});
else
    if shadederror
        ls=mseb(freq(plotfreqs), mean_s(plotfreqs), std_s(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
    else
        ls=errorbar(freq(plotfreqs), mean_s(plotfreqs),std_s(plotfreqs)./sqrt(N_array(plotfreqs)),...
            'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',02);
    end
end

% plot c2
lineprops.col = {darkGreyCol};
if shadederror
l2=mseb(freq(plotfreqs), mean_2(plotfreqs),std_2(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
else
l2=errorbar(freq(plotfreqs), mean_2(plotfreqs),std_2(plotfreqs)./sqrt(N_array(plotfreqs)),...
    'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
end

% plot c1
lineprops.col = {cv_col};
if shadederror
    l1=mseb(freq(plotfreqs), mean_1(plotfreqs),std_1(plotfreqs)./sqrt(N_array(plotfreqs)),lineprops,1);
else
    l1=errorbar(freq(plotfreqs), mean_1(plotfreqs),std_1(plotfreqs)./sqrt(N_array(plotfreqs)),...
        'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
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
if SHOWLEGEND 
h.Position(1) = h.Position(1)-0.05;
h.Position(2) = h.Position(2)+0.05;
h.FontSize = axisLabelFontSize;
end
offsetAxes(gca)
tightfig(gcf)


if nanmax(N_array)==nanmin(N_array)
    suffix = ['cv_N=' num2str(nanmax(N_array))];
else
    suffix = ['cv_N=' num2str(nanmin(N_array)) 'to' num2str(nanmax(N_array))];
end
printHR