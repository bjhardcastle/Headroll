clear all
rerun = 0 ;
if rerun == 1
hf_run_gain_phase;
save DATA_hf_fixed_sines;
else
load DATA_hf_fixed_sines;
end
startup;

plot_individual_gains_phases = 0;

% freqs = roundn(stimfreqs,-2);
color_mat = hov_cols;

resp_gain_mean(5,:,:,:) = NaN;
resp_gain_mean(7,:,:,:) = NaN;
figure


        gainplot_pos = [0.15 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

      



         lineprops.width = 1.5;
for cidx = 1:3
        
        CLg=squeeze(resp_gain_mean(:,:,:,cidx));
        CLgm=nanmean(CLg,1);
        CLgs = nanstd(CLg,1)/sqrt(6);

         gainplot=subplot('Position',gainplot_pos)
        
        hold on       
        
        lineprops.col = {hov_cols{cidx}};
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
       h1{cidx} = mseb(freqs,CLgm,CLgs,lineprops,1);     
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLg,'.', 'Color', [color_mat{cidx}/255])
            hold off            
        end
end
        
title(['CFS frequency response: hoverfly'])
ylabel('Gain')
set(gainplot,'XTick',[0,5,10,15,20,25],'XTickLabel',[])
axis([0 25.5 0 1.0])
set(gca,'box','on')
                   
        
for cidx = 1:3
        hold on
        
        CLp=squeeze(resp_phase_mean(:,:,:,cidx));
        CLpm=nanmean(CLp,1);
        CLps = nanstd(CLp,1)/sqrt(6);

         phaseplot=subplot('Position',phaseplot_pos)
        lineprops.col = {hov_cols{cidx}};
        h2{cidx} = mseb(freqs,CLpm,CLps,lineprops,1);
        
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLp,'.', 'Color', [color_mat{cidx}/255])
            hold off
        end


end
         set(gca,'box','on')
       l = legend([h2{1}.mainLine,h2{2}.mainLine,h2{3}.mainLine,],'intact','intact, dark','no halteres');
        set(l,'Location','southwest','box', 'off')
% lpos = l.Position;
% lpos(2) = lpos(2) * 0.95;
% l.Position = lpos;
        ylabel('Phase [\circ]')
        xlabel('Frequency [Hz]')
        set(phaseplot,'XTick',[0,5,10,15,20,25],'XTickLabel',{'0','5','10','15','20','25'})
       set(phaseplot,'YTick',[-120,-90,-60,-30,0])
        axis([0 25.5 -130 5])
        psb = plotsize_bode; psb(3)=600;
set(gcf,'Position',psb);
     set(gcf,'color','w');

%% Plot figs and update data saved for mega-comparison      
% export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\bode_aeneus'], '-openGL','-r660')
% 
% 
% load('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat')
% mega.hoverfly.sine.gain = h1;
% mega.hoverfly.sine.phase = h2;
% save('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat','mega')

