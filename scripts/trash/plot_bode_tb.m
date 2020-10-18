clear all
rerun = 1;
if rerun
    remake_fixed_sines_tb
    cd(fileparts(mfilename('fullpath')))
else
    cd(fileparts(mfilename('fullpath')))
    load('..\mat\DATA_tb_fixed_sines');
    load('..\mat\DATA_tb_gain_phase');
end

getHRplotParams

printpath = '..\plots\';
plotname = 'bode_tb';

plot_individual_gains_phases = 0;

freqs = roundn(stimfreqs,-1);

% color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};


gainplot_pos = [0.15 0.55 0.8 0.38];
% left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

xTickFreqs = [0.1,3,6,10,15,20,25];
condSelect = [1,3];
plotdb = 0;
shadederror = 0;
subplots = 1;
printflag = 0;
color_mat = horse_cols;
color_mat{1} = color_mat{3};
color_mat{3} = darkGreyCol;

lineprops.width = thickLineWidth;
lineprops.linewidth = thickLineWidth;

figure

for cidx = condSelect
    
    CLg=squeeze(resp_gain_mean(:,:,:,cidx));
    if plotdb
        CLg = mag2db(CLg);
    end
    CLgm=nanmean(CLg,1);
    CLgs = nanstd(CLg,1)/sqrt(4);
    
    if subplots
        gainplot=subplot('Position',gainplot_pos);
    else
        gainplot = gca;
    end
    hold on
    
    lineprops.col = {color_mat{cidx}};
    
    if shadederror
        h1{cidx} = mseb(freqs,CLgm,CLgs,lineprops,1);
    else
        h1{cidx} = errorbar(freqs,CLgm,CLgs, ...
            'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
    end
    
    if plot_individual_gains_phases
        hold on
        plot(freqs,CLg,'.', 'Color', [color_mat{cidx}/255])
        hold off
    end
end
if plotdb
    ylabel('Gain (dB)')
    xlim([-0.5 25.5])
else
    axis([-0.5 25.5 0 1.5])
    gainplot.YLim(1) = gainplot.YLim(1) - 0.1*range(gainplot.YLim);
    ylabel('Gain (a.u.)')
end
% set(gca,'box','on')
set(gca,'clipping','off')

if ~subplots
    title(' ')
    xlabel('Frequency (Hz)')
    set(gainplot,'XTick',xTickFreqs)

    dr =  1.5/25;
    daspect(gainplot,[1,2*dr,1])
else
    set(gainplot,'XTick',xTickFreqs,'XTickLabel',[])
    % title(['Frequency response: horsefly'])
end

offsetAxes(gainplot)
setHRaxes(gainplot,3,6)

if ~subplots
    
    tightfig(gcf)
    savename = [plotname '_gain'];
    if printflag
        printHR
    end
    figure
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resp_phase_mean(isnan(resp_gain_mean)) = nan;
for cidx = condSelect
    
    CLp=squeeze(resp_phase_mean(:,:,:,cidx));
    CLpm = circ_mean(CLp*pi/180,[],1)*180/pi;
    CLpm(CLpm > 60) = -360+CLpm(CLpm>60);
    CLps = (circ_std(CLp*pi/180,[],[],1)*180/pi)/sqrt(4);
    
    if subplots
        phaseplot=subplot('Position',phaseplot_pos);
    else
        phaseplot = gca;
    end
    lineprops.col = {color_mat{cidx}};
        
    hold on

    if shadederror
        h2{cidx} = mseb(freqs,CLpm,CLps,lineprops,1);
    else
        h2{cidx} = errorbar(freqs,CLpm,CLps, ...
            'LineWidth',lineprops.width, 'Color',lineprops.col{:},'CapSize',0);
    end
    
    if plot_individual_gains_phases
        hold on
        plot(freqs,CLp,'.', 'Color', [color_mat{cidx}/255])
        hold off
    end
    
    
end

legCell = {'intact';'intact, dark';'no halteres';'no halteres, dark'};
legLines = [];
LL = 0;
for lIdx = condSelect
    LL = LL + 1;
    if shadederror
        legLines(LL) = h2{lIdx}.mainLine;
    else
        legLines(LL) = h2{lIdx};
    end
end

l = legend(legLines,{legCell{condSelect}});

ylabel('Phase (\circ)')
xlabel('Frequency (Hz)')
set(phaseplot,'XTick',xTickFreqs)
set(phaseplot,'YTick',[-120 :60: 60])
% axis([-0.5 25.5 min(phaseplot.YTick) max(phaseplot.YTick)+30])
xlim([-0.5 25.5])
ylim([min(phaseplot.YTick) max(phaseplot.YTick)])
phaseplot.YLim(1) = phaseplot.YLim(1) - 0.1*range(phaseplot.YLim);

if ~subplots
    dr = 180/25;
    daspect(phaseplot,[1,2*dr,1])
end
% title(' ')

offsetAxes(phaseplot)

setHRaxes(phaseplot,3,6)
if subplots
    set(l,'Location','best','box', 'off')
else
    delete(l)
end
tightfig(gcf)
savename = [plotname '_phase'];
if printflag 
    printHR
end
