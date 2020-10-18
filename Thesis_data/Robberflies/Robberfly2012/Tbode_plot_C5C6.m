% Plot comparison bode plots C1 vs. C2 for each amplitude
close all
clear all
%%% load existing data:
    load('TRobbers2012data.mat')
% startup;
get_plot_colours;
% bodefig =  figure('Position', [   208   495   491   395]);
bodefig =  figure('Position', [   108 295 400 325]);

gainplot_pos = [0.12 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.12 0.123 0.8 0.38];
lineprops.width = 1;
num_amps = 1;
for amp_nr = 1:num_amps
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        CLgm1 = nanmean(CLg1,1);
        CLgs1 = nanstd(CLg1,1)/sqrt(3);
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        CLpm1 = nanmean(CLp1,1);
        CLps1 = nanstd(CLp1,1)/sqrt(3);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        CLgm2 = nanmean(CLg2,1);
        CLgs2 = nanstd(CLg2,1)/sqrt(3);
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        CLpm2 = nanmean(CLp2,1);
        CLps2 = nanstd(CLp2,1)/sqrt(3);
        
        figure(amp_nr)
        
        gainplot=subplot('Position',gainplot_pos)
        
        lineprops.col = {[color_mat{2}/255]};
        lineprops.style = '-';
        h1 = mseb(freqs,CLgm1,CLgs1,lineprops,1);
        
        hold on
        lineprops.col = {[color_mat{4}/255]}; 
        lineprops.style = '--';
        h2 =  mseb(freqs,CLgm2,CLgs2,lineprops,1);
        title(['Frequency response to horizon roll: robberfly'])
        ylabel('Gain')
        axis([0 10.5 0 0.6])
        ll = legend('CE + O','CE');
        set(ll,'box','off')
        set(gainplot,'XTick',[1,3,6,10],'XTickLabel',[])
        set(gca,'box','on')

        hold off
        
        phaseplot=subplot('Position',phaseplot_pos)
        lineprops.style = '-';
        lineprops.col = {[color_mat{2}/255]};   
        h3 =  mseb(freqs,CLpm1,CLps1,lineprops,1);      
        hold on
        
        lineprops.col = {[color_mat{4}/255]};
        lineprops.style = '--';
        h4 =  mseb(freqs,CLpm2,CLps2,lineprops,1);
        ylabel('Phase [\circ]')
        xlabel('Frequency  [Hz]')
        axis([0 10.5 -100 0])
        set(phaseplot,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'})
        set(phaseplot,'YTick',[-90,-45,0],'YTickLabel',{'-90','-45','0'})
        set(gca,'box','on')

        hold off
end

set(gcf,'color','w');
% -opengl displays dashed lines correctly
% -painters displays transparency
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\robberfly_bode','-opengl','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\robberfly_bode','-opengl','-r660')