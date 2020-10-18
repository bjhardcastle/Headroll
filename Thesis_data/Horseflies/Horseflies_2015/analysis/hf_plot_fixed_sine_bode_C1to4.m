clear all
close all
load DATA_hf_fixed_sines;
load DATA_hf_gain_phase;
startup;
plot_individual_gains_phases = 0;

freqs = roundn(stimfreqs,-1);
% color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};


        gainplot_pos = [0.15 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

      



         lineprops.width = 1.5;
for cidx = 1:4
        
        CLg=squeeze(resp_gain_mean(:,:,:,cidx));
        CLgm=nanmean(CLg,1);
        CLgs = nanstd(CLg,1)/sqrt(4);

         gainplot=subplot('Position',gainplot_pos)
        
        hold on       
        
        lineprops.col = {horse_cols{cidx}};
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
       h1{cidx} = mseb(freqs,CLgm,CLgs,lineprops,1);     
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLg,'.', 'Color', [color_mat{cidx}/255])
            hold off            
        end
end
        
title(['Frequency response: horsefly'])
ylabel('Gain')
set(gainplot,'XTick',[0.1,1,3,6,10],'XTickLabel',[])
axis([0 10.5 0 1.0])
set(gca,'box','on')
                   
        
for cidx = 1:4    
        hold on
        
        CLp=squeeze(resp_phase_mean(:,:,:,cidx));
        CLpm=nanmean(CLp,1);
        CLps = nanstd(CLp,1)/sqrt(4);

         phaseplot=subplot('Position',phaseplot_pos)
        lineprops.col = {horse_cols{cidx}};
        lineprops.width = 1;
        h2{cidx} = mseb(freqs,CLpm,CLps,lineprops,1);
        
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLp,'.', 'Color', [color_mat{cidx}/255])
            hold off
        end


end
        l = legend([h2{1}.mainLine,h2{2}.mainLine,h2{3}.mainLine,h2{4}.mainLine,],'intact','intact, dark','no halteres','no halteres, dark');
        set(l,'Location','best','box', 'off')
        set(gca,'box','on')
%         set(l,'Linewidth',2)

        ylabel('Phase [\circ]')
        xlabel('Frequency [Hz]')
        set(phaseplot,'XTick',[0.1,1,3,6,10],'XTickLabel',{'0.1','1','3','6','10'})
       set(phaseplot,'YTick',[-180,-90,0])
        axis([0 10.5 -220 20])
set(gcf,'Position',plotsize_bode);
     set(gcf,'color','w');
%   export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\bode_tabanus'], '-opengl','-r660')

% 
% load('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat')
% mega.horsefly.sine.gain = h1;
% mega.horsefly.sine.phase = h2;
% save('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat','mega')
