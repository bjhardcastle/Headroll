% don't call this script directly: run from 'plot_3_all_bode'
plotname = 'bode';

if exist('..\mat\bodestats.mat','file')
    load('..\mat\bodestats.mat','bodestats');
else
    bodestats =  struct;
end

freqs = roundn(stimfreqs,-2);
gainplot_pos = [0.15 0.55 0.8 0.38];
% left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

plot_individual_gains_phases = 0; % 'Step_G' data not checked


if bodelogXplot
    freqs = log10(freqs);
    logXlims = [-1.38,1.5];
    xTickFreqs = unique(log10([0.01:0.01:0.1,0.1:0.1:1,1:1:10,10:10:100]));
    xTickFreqs = xTickFreqs(xTickFreqs>logXlims(1) & xTickFreqs<logXlims(2));
    xTickLabels = strrep(cellstr(num2str(xTickFreqs')),' ','');
    for xtlIdx = 1:length(xTickFreqs)
        if mod(xTickFreqs(xtlIdx),1)
            xTickLabels{xtlIdx} = '';
        else
            xTickLabels{xtlIdx} = ['10^{' num2str(xTickFreqs(xtlIdx)) '}'];
            xTickLabels{xtlIdx} = num2str(10^xTickFreqs(xtlIdx));
        end
    end
else
    xTickFreqs = [0.1,3,6,10,15,20,25];
end

lineprops.width = thickLineWidth;
figure

% N_array = sum(~isnan(resp_gain_mean(:,:,1,1)));
gainVec = [];
for c = 1:length(condSelect)
    cidx = condSelect(end-c+1); % plot in reverse so 'intact' fly data are on top
    
    CLg=squeeze(resp_gain_mean(:,:,:,cidx));
    N_array = sum(~isnan(CLg));
    if bodeplotdb
        CLg = mag2db(CLg);
    end
    CLgm=nanmean(CLg,1);
        gainVec(length(condSelect)-c+1,:) = CLgm;
    CLgs = nanstd(CLg,1)./sqrt(N_array);
    
    % store stats
    c_switch = length(condSelect)-c+1; % conditions are plot in reverse order: store them in the correct order (c1 in row 1, etc)
    bodestats.(flyname).gainvals{c_switch} = CLg;
    bodestats.(flyname).gainmean(c_switch,:) = CLgm;
    bodestats.(flyname).gainN(c_switch,:) = N_array;
    bodestats.(flyname).freqs(c_switch,:) = freqs;

    if bodesubplots
        gainplot=subplot('Position',gainplot_pos);
    else
        gainplot = gca;
    end
    hold on
    
    lineprops.col = {bodecolor_mat{cidx}};
    
    
    if bodeshadederror
        h1{cidx} = mseb(freqs,CLgm,CLgs,lineprops,1);
        if errorbardots
            scatter(freqs,CLgm,defaultMarkerSize,'MarkerFaceColor',lineprops.col{:},'MarkerEdgeColor','none')
        end
    else
        h1{cidx} = errorbar(freqs,CLgm,CLgs, ...
            'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
    end
    
    if plot_individual_gains_phases
        hold on
        plot(freqs,CLg,'.', 'Color', [bodecolor_mat{cidx}/255])
        hold off
    end
end

ytickinterval = 0.5;
ylim1 = 0;
ylim2 = 1.0;

if bodelogXplot
    xlim(logXlims)
else
    xlim([-0.5 25.5])
end


if bodeplotdb
    ylabel('Gain (dB)')
    xlim([-0.5 25.5])
else
    ylim([ylim1, ylim2])
    gainplot.YLim(1) = gainplot.YLim(1) - 0.1*range(gainplot.YLim);
    set(gainplot,'YTick',sort(unique([0:ytickinterval:ylim2,0:-ytickinterval:ylim1])))
    ylabel('Gain (a.u.)')
end
% set(gca,'box','on')
% set(gca,'clipping','off')

if ~bodesubplots
    title(' ')
    xlabel('Frequency (Hz)')
    set(gainplot,'XTick',xTickFreqs)
    if bodelogXplot
        set(gainplot,'XTickLabel',xTickLabels)
    end
    
else
    set(gainplot,'XTick',xTickFreqs,'XTickLabel',[])
    % title(['Frequency response: e.aeneus'])
end

if bodelogXplot 
    if ~bodesubplots
    dr =   range([gainplot.YTick(1),gainplot.YTick(end)])/range(logXlims);
    daspect(gainplot,[1,2*dr,1])
    end
    offsetAxesLogX(gainplot)
else
   if ~bodesubplots
    dr =  range([gainplot.YTick(1),gainplot.YTick(end)])/25;
    daspect(gainplot,[1,2*dr,1])
    end
    offsetAxes(gainplot)
end

if nanmax(N_array)==nanmin(N_array)
    suffix = ['_N=' num2str(nanmax(N_array))];
else
    suffix = ['_N=' num2str(nanmin(N_array)) 'to' num2str(nanmax(N_array))];
end
if bodeshadederror
        suffix = [suffix '_mseb'];
            end

if ~bodesubplots
    
    gainplotaxpos = gainplot.Position;
    gainplot.XLabel.String = '';
    gainplot.XTickLabel = {};
    setHRaxes(gainplot,4.5,5)
    set(gcf,'Units','centimeters')
    set(gcf,'PaperUnits','centimeters')
    set(gcf,'Position',[0 0 7 5])
    set(gcf,'PaperPosition',[0 0 7 5])
    set(gcf,'PaperSize',[7 5])
         curraxpos = get(gca,'Position');

    set(gca,'Position',[curraxpos(1)-0.5 curraxpos(2)-0.25 curraxpos(3) curraxpos(4)])
        set(gca,'color',[1 1 1 0]);

    if HRprintflag
        savename = [plotnames.(plotname) '_' flyname '_gain'];
            
            if bode_rel_first
            savename = [savename '_rel_first'];
        end
        printHR
    end
    figure
else
    setHRaxes(gainplot,3,6)
    %tightfig(gcf)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resp_phase_mean(isnan(resp_gain_mean))=nan;
phaseVec = [];
for c = 1:length(condSelect)
    cidx = condSelect(end-c+1);% plot in reverse so 'intact' fly data are on top
    
    CLp=squeeze(resp_phase_mean(:,:,:,cidx));
CLpm = circ_mean(CLp*pi/180,[],1)*180/pi;
N_array = sum(~isnan(CLp));
    if ~bode_rel_first
%     CLpm(CLpm > 70) = -360+CLpm(CLpm>70);
    else
%     CLpm(CLpm > -110) = -360+CLpm(CLpm> -110);
    end
    phaseVec(length(condSelect)-c+1,:) = CLpm;
    CLps = (circ_std(CLp*pi/180,[],[],1)*180/pi)./sqrt(N_array);
    
    % store stats
    c_switch = length(condSelect)-c+1; % conditions are plot in reverse order: store them in the correct order (c1 in row 1, etc)
    bodestats.(flyname).phasevals{c_switch} = CLp;
    bodestats.(flyname).phasemean(c_switch,:) = CLpm;
    bodestats.(flyname).phaseN(c_switch,:) = N_array;

    if bodesubplots
        phaseplot=subplot('Position',phaseplot_pos);
    else
        phaseplot = gca;
    end
    lineprops.col = {bodecolor_mat{cidx}};
    
    hold on
    
    if bodeshadederror
        h2{cidx} = mseb(freqs,CLpm,CLps,lineprops,1);
         if errorbardots
            scatter(freqs,CLpm,defaultMarkerSize,'MarkerFaceColor',lineprops.col{:},'MarkerEdgeColor','none')
        end
    else
        h2{cidx} = errorbar(freqs,CLpm,CLps, ...
            'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
    end
    
    if plot_individual_gains_phases
        hold on
        plot(freqs,CLp,'.', 'Color', [bodecolor_mat{cidx}/255])
        hold off
    end
    
    
end

legLines = [];
LL = 0;
for lIdx = condSelect
    LL = LL + 1;
    if bodeshadederror
        legLines(LL) = h2{lIdx}.mainLine;
    else
        legLines(LL) = h2{lIdx};
    end
end

l = legend(legLines,{legCell{condSelect}});

ylabel('Phase (\circ)')
xlabel('Frequency (Hz)')

ytickinterval = 60;

if ~bode_rel_first
    ylim1 = -180;
    ylim2 = 60;
    set(phaseplot,'YTick',sort(unique([0:ytickinterval:ylim2,0:-ytickinterval:ylim1])))
else
    ylim1 = -360;
    ylim2 = -120;
    set(phaseplot,'YTick',sort(unique([ylim1:ytickinterval:ylim2])))
end
% axis([-0.5 25.5 min(phaseplot.YTick) max(phaseplot.YTick)+30])
ylim([ylim1 ylim2])
phaseplot.YLim(1) = phaseplot.YLim(1) - 0.1*range(phaseplot.YLim);

if bodelogXplot
    xlim(logXlims)
    set(phaseplot,'XTick',xTickFreqs,'XTickLabel',xTickLabels)
else
    xlim([-0.5 25.5])
    set(phaseplot,'XTick',xTickFreqs)
end

if ~bodesubplots
    title(' ')
    xlabel('Frequency (Hz)')
    set(phaseplot,'XTick',xTickFreqs)
    if bodelogXplot
        set(phaseplot,'XTickLabel',xTickLabels)
    end
    
else
    set(phaseplot,'XTick',xTickFreqs,'XTickLabel',[])
    % title(['Frequency response: e.aeneus'])
end

if bodelogXplot
    if ~bodesubplots
    dr =  range([phaseplot.YTick(1),phaseplot.YTick(end)])/range(logXlims);
    daspect(phaseplot,[1,2*dr,1])
    end
    offsetAxesLogX(phaseplot)
else
    if ~bodesubplots
    dr =  range([phaseplot.YTick(1),phaseplot.YTick(end)])/25;
    daspect(phaseplot,[1,2*dr,1])
    end
    offsetAxes(phaseplot)
    
end

if bodesubplots
    set(l,'Location','best','box', 'off')
    setHRaxes(phaseplot,3,6)
    tightfig(gcf)
    
else
    delete(l)
    setHRaxes(phaseplot,4.5,5)
    set(gcf,'Units','centimeters')
    set(gcf,'PaperUnits','centimeters')
    set(gcf,'Position',[0 0 7 5])
    set(gcf,'PaperPosition',[0 0 7 5])
    set(gcf,'PaperSize',[7 5 ])

         curraxpos = get(gca,'Position');

    set(gca,'Position',[curraxpos(1)-0.5 curraxpos(2)-0.25 curraxpos(3) curraxpos(4)])
        set(gca,'color',[1 1 1 0]);


end

save('..\mat\bodestats.mat','bodestats');

if HRprintflag
    savename = [plotnames.(plotname) '_' flyname '_phase'];
    if bode_rel_first
        savename = [savename '_rel_first'];
    end
    printHR
end
if bodeReconstructSlipspeeds
    make_toy_sine_data
end
