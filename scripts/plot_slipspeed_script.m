% don't call this script directly: run from 'plot_2b_splipspeed'
plotname = 'slipspeedPDF';
savename = [plotnames.(plotname) '_' flyname ];

plotfreqs = [1,3,6,10,15,20,25];
freqs = find(ismember(round(stimfreqs,1),plotfreqs));

numBins = 49;
Nmin = 99;
Nmax = 0;
for flyIdx = 1:size(headroll,2)
    for cIdx = 1:size(headroll(flyIdx).cond,2)
        for fIdx = 1:length(plotfreqs)
            freq = plotfreqs(fIdx);
            freqIdx = freqs(fIdx);
                
                if size(headroll(flyIdx).cond(cIdx).freq,2) >= freqIdx
                
               
                respTrialCts = nan(size(headroll(flyIdx).cond(cIdx).freq(freqIdx).trial,2),numBins);
                stimTrialCts = nan(size(headroll(flyIdx).cond(cIdx).freq(freqIdx).trial,2),numBins);
                respTrialCenters = respTrialCts;
                stimTrialCenters = stimTrialCts;
                
                respPoolVel=[];
                stimPoolVel = [];
                for tIdx = 1:size(headroll(flyIdx).cond(cIdx).freq(freqIdx).trial,2)
                    resp = headroll(flyIdx).cond(cIdx).freq(freqIdx).trial(:,tIdx);
                    stim = stims(flyIdx).cond(cIdx).freq(freqIdx).trial(:,tIdx);
                    Fs = framerates(flyIdx).cond(cIdx).freq(freqIdx).trial(tIdx);
                    
                    if all(isnan(resp))
                        continue
                    else
                        
                        sigma = Fs/freq/25; %25=N_sigma_in_a_cycle;
                        resp = gaussian_filtering(resp,sigma);
                        stim = gaussian_filtering(stim,sigma);
                        
                        resp_diff = conv(resp,[1,-1]);
                        stim_diff = conv(stim,[1,-1]);
                        resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
                        stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                        
                        nanstimvals = (stim_vel>plotted_as_fraction_of_max_stim*2*pi*freq*30);
                        nanrespvals = (resp_vel>plotted_as_fraction_of_max_stim*2*pi*freq*30) ;
                        
                        resp_vel(nanstimvals)= nan;
                        stim_vel(nanstimvals)= nan;
                        resp_vel(nanrespvals)= nan;
                        stim_vel(nanrespvals)= nan;
                        
                        respPoolVel = [respPoolVel; resp_vel];
                        stimPoolVel = [stimPoolVel; stim_vel];
                        
                        xvalues = linspace(0,plotted_as_fraction_of_max_stim*2*pi*freq*30,numBins+1); % up to 2 times the maximum angular speed of stim
                        
                        [cts,edges] = histcounts(resp_vel(~isnan(resp_vel)),xvalues,'Normalization','probability');
                        respTrialCts(tIdx,:) = cts;
                        respTrialCenters(tIdx,:)= (edges(1:end-1)+edges(2:end))/2;
                        [cts,edges] = histcounts(stim_vel(~isnan(stim_vel)),xvalues,'Normalization','probability');
                        stimTrialCts(tIdx,:) = cts;
                        stimTrialCenters(tIdx,:)= (edges(1:end-1)+edges(2:end))/2;

                        % counter for N, store for error bars:
                        % run histcounts for each trial, then average across trials and find median/mode
                        
                        
                    end
                end
                    
                % average trials for resp
                result(flyIdx,cIdx,fIdx).x_resp = nanmean(respTrialCenters,1); % this is constant
                result(flyIdx,cIdx,fIdx).n_resp = nanmean(respTrialCts,1);
                result(flyIdx,cIdx,fIdx).median_resp = nanmedian(respPoolVel);
                idx = []; [~,idx] = nanmax(result(flyIdx,cIdx,fIdx).n_resp);
                result(flyIdx,cIdx,fIdx).mode_resp = result(flyIdx,cIdx,fIdx).x_resp(idx);
                %result(flyIdx,cIdx,freqIdx).N = sum(~isnan(respTrialCts(:,1)));
                
                % average across trials for stim
                result(flyIdx,cIdx,fIdx).x_stim = nanmean(stimTrialCenters,1);
                result(flyIdx,cIdx,fIdx).n_stim = nanmean(stimTrialCts,1);
                result(flyIdx,cIdx,fIdx).median_stim = nanmedian(stimPoolVel);
                idx = []; [~,idx] = nanmax(result(flyIdx,cIdx,fIdx).n_stim);
                result(flyIdx,cIdx,fIdx).mode_stim = result(flyIdx,cIdx,fIdx).x_stim(idx);
            else
                % freq doesn't exist at this fly/condition
                % average trials for resp
                result(flyIdx,cIdx,fIdx).x_resp =  (edges(1:end-1)+edges(2:end))/2;
                result(flyIdx,cIdx,fIdx).n_resp = nan(1,numBins);
                result(flyIdx,cIdx,fIdx).median_resp = nan;
                result(flyIdx,cIdx,fIdx).mode_resp = nan;
                % average across trials for stim
                result(flyIdx,cIdx,fIdx).x_stim = (edges(1:end-1)+edges(2:end))/2;
                result(flyIdx,cIdx,fIdx).n_stim = nan(1,numBins);
                result(flyIdx,cIdx,fIdx).median_stim =  nan;
                result(flyIdx,cIdx,fIdx).mode_stim = nan;
            end
        end
    end
end

%% PLOT P.D.F of slipspeed at different freqs
Nmin = 99;
Nmax = 0;
c1 = condSelect(1);
c2 = condSelect(2);
figure('Units','centimeters','Position', [1 1 18 20]);

for fIdx = 1:length(plotfreqs)
    
    
    freq = plotfreqs(fIdx);
    
    hist_stim_1 = nan(size(headroll,2),numBins);
    hist_stim_2 = nan(size(headroll,2),numBins);
    hist_resp_1 = nan(size(headroll,2),numBins);
    hist_resp_2 = nan(size(headroll,2),numBins);
    
    for fly = 1:size(result,1)
        
        if ~isempty(result(fly,c1,fIdx).n_resp)
            hist_stim_1(fly,:) = result(fly,c1,fIdx).n_stim;
            hist_resp_1(fly,:) = result(fly,c1,fIdx).n_resp;
        end
        if ~isempty(result(fly,c2,fIdx).n_resp)
            hist_stim_2(fly,:) = result(fly,c2,fIdx).n_stim;
            hist_resp_2(fly,:) = result(fly,c2,fIdx).n_resp;
        end
    end
    
    N =  max([max(sum(~isnan(hist_stim_1),1)) max(sum(~isnan(hist_stim_2),1))]);
    if N>Nmax
        Nmax = N;
    end
    if N<Nmin
        Nmin = N;
    end
    
    
    subplot(1,length(plotfreqs),fIdx)
    
    
    hold on
    
    lineprops.width = thickLineWidth;
    edges = linspace(0,plotted_as_fraction_of_max_stim*2*pi*freq*30,numBins+1); % up to 2 times the maximum angular speed of stim
    xvalues = (edges(1:end-1)+edges(2:end))/2;
    % plot stim histogram:
    %{
    lineprops.col = {[0 0 0]};
    mseb(xvalues, nanmean([hist_stim_1 ; hist_stim_2],1), nanstd([hist_stim_1;hist_stim_2],[],1)./sqrt(N),lineprops,1);
    %}
    
        % plot no halteres
lineprops.col = {color_mat{c2}};
    mseb(xvalues, nanmean(hist_resp_2,1),nanstd(hist_resp_2,[],1)./sqrt(N),lineprops,1);
        
    % plot intact
    lineprops.col = {color_mat{c1}};
    mseb(xvalues, nanmean(hist_resp_1,1),nanstd(hist_resp_1,[],1)./sqrt(N),lineprops,1);
    
    hold off
    t = title (['', num2str(freq), ' Hz']);
    set(t,'HorizontalAlignment','right')
    
    if fIdx == ceil(length(plotfreqs)/2)
        xlabel('Retinal slipspeed (\circ/s)')
    end
    if fIdx == 1
        ylabel('Probability')
    else
        ylabel('')
    end
    
    [maxval] = nanmax([nanmean(hist_resp_1,1), nanmean(hist_resp_2,1)]);
    ylim([0,1.2*maxval])
    
    % A vertical line for the theoretical peak of the thorax
    hold on
    sl =  plot([2*pi*freq*30 2*pi*freq*30],[0 max(ylim)],'Color','k','LineWidth',defaultLineWidth,'LineStyle','-');
     sl.LineStyle = ':';
     sl.Color='k';
    uistack(sl(1), 'bottom')
    
    xlim([0,plotted_as_fraction_of_max_stim*2*pi*freq*30])
    
    if freq >= 1
        set(gca,'xtick',[round(2*pi*freq*30,-2)])
    else
        set(gca,'xtick',[round(2*pi*freq*30)])
    end
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    set(gca,'clipping','off')
    pbaspect(gca,[1 1 1])
    setHRaxes(gca,1.5)
end

tightfig(gcf)
if Nmin == Nmax
    suffix = ['N=' num2str(Nmin)];
else
    suffix = ['N=' num2str(Nmin) 'to' num2str(Nmax)];
end
if HRprintflag
    printHR
end

%% PLOT MODE SLIPSPEEDS

if modeplot
    plotname =  'slipspeedMode';
    manualstim = 1;
else
    plotname =  'slipspeedMedian';
    manualstim = 1;
end
savename = [plotnames.(plotname) '_' flyname ];

N_array = nan(1,length(plotfreqs));
for fIdx = 1:length(plotfreqs)
    
    freq = plotfreqs(fIdx);
   
    
    if modeplot
        
        mean_s(fIdx)= nanmean([result(:,c1,fIdx).mode_stim,result(:,c2,fIdx).mode_stim]);
        mean_1(fIdx)= nanmean([result(:,c1,fIdx).mode_resp]);
        mean_2(fIdx)= nanmean([result(:,c2,fIdx).mode_resp]);
        
        std_s(fIdx)= nanstd([result(:,c1,fIdx).mode_stim,result(:,c2,fIdx).mode_stim]);
        std_1(fIdx)= nanstd([result(:,c1,fIdx).mode_resp]);
        std_2(fIdx)= nanstd([result(:,c2,fIdx).mode_resp]);
        
    else
        
        mean_s(fIdx)= nanmean([result(:,c1,fIdx).median_stim,result(:,c2,fIdx).median_stim]);
        mean_1(fIdx)= nanmean([result(:,c1,fIdx).median_resp]);
        mean_2(fIdx)= nanmean([result(:,c2,fIdx).median_resp]);
        
        std_s(fIdx)= nanstd([result(:,c1,fIdx).median_stim,result(:,c2,fIdx).median_stim]);
        std_1(fIdx)= nanstd([result(:,c1,fIdx).median_resp]);
        std_2(fIdx)= nanstd([result(:,c2,fIdx).median_resp]);
        
    end
    if manualstim
        mean_s(fIdx) = 2*pi*freq*30;
        std_s(fIdx) = 0;
    end
    
    N_array(fIdx) = sum(~isnan([result(:,c1,fIdx).median_resp]));
    
end

figure('Units','centimeters','Position', [1 1 18 20]);
hold on

lineprops.width = thickLineWidth;

% plot stim
lineprops.col = {[0 0 0]};
% if manualstim
    ls=plot([0 plotfreqs], [0 mean_s],'LineWidth',defaultLineWidth, 'Color',lineprops.col{:});
    ls.LineStyle = ':';
    ls.Color = 'k';
% else
%     if shadederror
%         ls=mseb([0 plotfreqs], [0 mean_s], [0 std_s]./sqrt(N_array),lineprops,1);
%     else
%         ls=errorbar([0 plotfreqs], [0 mean_s], [0 std_s]./sqrt(N_array),...
%             'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
%     end
% end

% plot c2
lineprops.col = {color_mat{c2}};
if shadederror
    l2=mseb(plotfreqs, mean_2,std_2./sqrt(N_array),lineprops,1);
        if errorbardots
        scatter(plotfreqs,mean_2,defaultMarkerSize,'MarkerFaceColor',lineprops.col{:},'MarkerEdgeColor','none')
    end
else
    l2=errorbar(plotfreqs, mean_2,std_2./sqrt(N_array),...
        'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
end

% plot c1
lineprops.col = {color_mat{c1}};
if shadederror
    l1=mseb(plotfreqs, mean_1,std_1./sqrt(N_array),lineprops,1);
    if errorbardots
        scatter(plotfreqs,mean_1,defaultMarkerSize,'MarkerFaceColor',lineprops.col{:},'MarkerEdgeColor','none')
    end

else
    l1=errorbar(plotfreqs, mean_1,std_1./sqrt(N_array),...
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
    ylabel('Mode slipspeed (\circ/s)')
else
    ylabel('Median slipspeed (\circ/s)')
end
xlabel('Frequency (Hz)')

ylim([0 5500])
xlim([0 26])
set(gca,'xtick',[0:5:25]);
set(gca,'ytick',[0:1000:5000]);
set(gca,'xticklabel',{'0';'';'';'';'';'25';})
set(gca,'yticklabel',{'0';'';'';'';'';'5000';})

daspect(gca,[25 5000 1])
offsetAxes(gca)
setHRaxes(gca,6,4)
if SHOWLEGEND
    h.Position(1) = h.Position(1)-0.05;
    h.Position(2) = h.Position(2)+0.05;
    h.FontSize = axisLabelFontSize;
end
tightfig(gcf)

if nanmax(N_array)==nanmin(N_array)
    suffix = ['_N=' num2str(nanmax(N_array))];
else
    suffix = ['_N=' num2str(nanmin(N_array)) 'to' num2str(nanmax(N_array))];
end
if shadederror
    suffix = [suffix '_mseb'];
end
if HRprintflag
    printHR
end


function [ filtered_signal ] = gaussian_filtering( signal, sigma)
%GAUSSIAN_FILTERING Gaussian filtering of signal
%   sigma is the SD of the Gaussian
%   author: fjhheras@gmail.com

    N_filter = ceil(3*sigma); %width of filter -> truncated at 3*SD

    filterx = -N_filter:N_filter;
    gaussian_filter = @(x) exp(-(x.*x)/2/sigma/sigma); % not normalised, careful!
    filter = gaussian_filter(filterx);
    filtered_signal = conv(signal,filter,'valid')/sum(filter);

end