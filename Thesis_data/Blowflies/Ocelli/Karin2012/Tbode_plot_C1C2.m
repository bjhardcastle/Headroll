% Plot comparison bode plots C1 vs. C2 for each amplitude
close all
clear all
%%% load existing data:
    load('TKarin2012data.mat')
startup;

% bodefig =  figure('Position', [   208   495   491   395]);
bodefig =  figure('Position', [   208 295 400 325]);

gainplot_pos = [0.12 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.12 0.123 0.8 0.38];
lineprops.width = 1;
num_amps = 1;
for amp_nr = 3
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        CLgm1 = mean(CLg1,1);
        CLgs1 = std(CLg1,1)/sqrt(8);
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        CLpm1 = mean(CLp1,1);
        CLps1 = std(CLp1,1)/sqrt(8);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        CLgm2 = mean(CLg2,1);
        CLgs2 = std(CLg2,1)/sqrt(8);
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        CLpm2 = mean(CLp2,1);
        CLps2 = std(CLp2,1)/sqrt(8);
        
%         figure(amp_nr)
        
        gainplot=subplot('Position',gainplot_pos)
        
        h1 = plot(freqs,CLg1,'o');
        set(h1, 'MarkerSize', 4);
        set(h1, 'Color', color_mat{2});
        set(h1, 'MarkerFaceColor', color_mat{2});
        hold on

        h2 = plot(freqs,CLg2,'o');
        set(h2, 'MarkerSize', 4);
        set(h2, 'Color', color_mat{4});
        set(h2, 'MarkerFaceColor', color_mat{4});
        hold on
        
        lineprops.col = {[color_mat{2}]};
        lineprops.style = '-';
        % with errorbars
        h1a = mseb(freqs,CLgm1,CLgs1,lineprops,1);
%         h1 = plot(freqs,CLgm1,'LineWidth',1.5);
        hold on
        lineprops.col = {[color_mat{4}]}; 
        lineprops.style = '--';
        h2a =  mseb(freqs,CLgm2,CLgs2,lineprops,1);
%         h2 =  plot(freqs,CLgm2,'LineWidth',1.5,'LineStyle','--');


        
        title(['Frequency response to horizon roll: blowfly'])
        ylabel('Gain')
        axis([0 10.5 0 0.6])
        legend([h1a.mainLine,h2a.mainLine],'CE + O','CE')
        legend('boxoff')
        set(gainplot,'XTick',[1,3,6,10],'XTickLabel',[])
        set(gca,'box','on')
        
        hold off
        
        phaseplot=subplot('Position',phaseplot_pos);
        
        h3 = plot(freqs,CLp1,'o');
        set(h3, 'MarkerSize', 4);
        set(h3, 'Color', color_mat{2});
        set(h3, 'MarkerFaceColor', color_mat{2});
        hold on

        h4 = plot(freqs,CLp2,'o');
        set(h4, 'MarkerSize', 4);
        set(h4, 'Color', color_mat{4});
        set(h4, 'MarkerFaceColor', color_mat{4});
        hold on

        lineprops.style = '-';
        lineprops.col = {[color_mat{2}]};   
        h1b =  mseb(freqs,CLpm1,CLps1,lineprops,1);      
%         h3 =  plot(freqs,CLpm1,'LineWidth',1.5);      

        hold on
        
  
        lineprops.col = {[color_mat{4}]};
        lineprops.style = '--';
        h2b =  mseb(freqs,CLpm2,CLps2,lineprops,1);
%         h4 =  plot(freqs,CLpm2,'LineWidth',1.5,'LineStyle','--');
        ylabel('Phase [\circ]')
        xlabel('Frequency  [Hz]')
        axis([0 10.5 -100 0])
        set(phaseplot,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'})
        set(phaseplot,'YTick',[-90,-45,0],'YTickLabel',{'-90','-45','0'})
        set(gca,'box','on')
    set(gca,'layer','top')
        hold off
end

set(gcf,'color','w');
% -opengl displays dashed lines correctly
% -painters displays transparency
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\blowfly_bode','-opengl','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\blowfly_bode','-opengl','-r660')