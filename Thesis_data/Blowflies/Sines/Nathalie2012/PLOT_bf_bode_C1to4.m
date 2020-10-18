clear all
load DATA_bf_fixed_sines;
load DATA_bf_gain_phase;

plot_individual_gains_phases = 0;

freqs = roundn(stimfreqs,-1);
color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};

for cidx = 1:4
    Tg=squeeze(resp_gain_mean(:,:,:,cidx));
    Tp=squeeze(resp_phase_mean(:,:,:,cidx));
    Tg_zeroes = find(Tg == 0);
    for t = 1:length(Tg_zeroes)
        if Tp(t) == 0,
            resp_gain_mean(t) = NaN;
            resp_phase_mean(t) = NaN;
        end
    end
end


figure
for cidx = 1:4
        
        CLg=squeeze(resp_gain_mean(:,:,:,cidx));
        CLgm=nanmean(CLg,1);
        CLgs = nanstd(CLg,1)/sqrt(12);

        gainfig = subplot(2,1,1); 
        
        hold on       
        h = errorbar(freqs,CLgm,CLgs);     
        set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
       
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLg,'.', 'Color', [color_mat{cidx}/255])
            hold off            
        end
end
        
title(['Blowfly headroll response to 40^{\circ} thorax roll, N = 12'])
ylabel('Gain (linear units)')
set(gainfig,'XTick',[0,1,3,6,10,15],'XTickLabel',{'0','1','3','6','10','15'},'fontsize',12)
axis([0 15.5 0 1.0])
set(gca,'box','on')
                   
for cidx = 1:4    
        hold on
        
        CLp=squeeze(resp_phase_mean(:,:,:,cidx));
        CLpm=nanmean(CLp,1);
        CLps = nanstd(CLp,1)/sqrt(12);

        phasefig = subplot(2,1,2);
        h = errorbar(freqs,CLpm,CLps);
        set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLp,'.', 'Color', [color_mat{cidx}/255])
            hold off
        end

%         l = legend('light','dark','light, no halteres','dark, no halteres');
%         set(l,'Location','southwest','box', 'off')

end

        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        set(phasefig,'XTick',[0,1,3,6,10,15],'XTickLabel',{'0','1','3','6','10','15'},'fontsize',12)
        axis([-0 15.5 -90 10])
            
set(gcf, 'Renderer', 'painters');
% export_fig('bf_fixed_sine_bode_C1to4','-transparent', '-pdf')
% export_fig('bf_fixed_sine_bode_C1to4','-transparent', '-m10')