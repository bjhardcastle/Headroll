% Robber bode all conds..
    
    
clear all
close all
load('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat')
startup;
plot_individual_gains_phases = 0;
horse_cols{3} = [190, 37, 5]./255;
robber_cols{1} = [5,117, 79]./255;
% freqs = roundn(stimfreqs,-1);
% color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};
% Could do with 20,25 Hz for blowfly


figure,  
% left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];
gainplot_pos = [0.15 0.55 0.8 0.38];
         % left bottom width height

%%%%%%%%% gains       
 
gainplot=subplot('Position',gainplot_pos);

temp = mega.hoverfly.sine.gain;
lineprops.col = {hov_cols{3}};
h1{3} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {hov_cols{3}};
% mseb(temp{3}.mainLine.XData,temp{3}.mainLine.YData,temp{3}.mainLine.YData-temp{3}.edge(2).YData,lineprops);

hold on 

temp = mega.robberfly.sine.gain;
lineprops.col = {robber_cols{1}};
h1{4} = mseb(temp{1}.mainLine.XData,temp{2}.mainLine.YData,temp{2}.mainLine.YData-temp{2}.edge(2).YData,lineprops,1);
% lineprops.col = {robber_cols{3}};
% mseb(temp{4}.mainLine.XData,temp{4}.mainLine.YData,temp{4}.mainLine.YData-temp{4}.edge(2).YData,lineprops);

hold on 

temp = mega.blowfly.sine.gain
lineprops.col = {color_mat{2}};
h1{1} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {color_mat{2}};
% mseb(temp{2}.mainLine.XData,temp{2}.mainLine.YData,temp{2}.mainLine.YData-temp{2}.edge(2).YData,lineprops);

hold on 

temp = mega.horsefly.sine.gain;
lineprops.col = {horse_cols{3}};
h1{2} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {horse_cols{3}};
% mseb(temp{3}.mainLine.XData,temp{3}.mainLine.YData,temp{3}.mainLine.YData-temp{3}.edge(2).YData,lineprops);

%%%%%%%%%%%%%%%%%%

        
title(['Frequency response: all flies'])
ylabel('Gain')
set(gainplot,'XTick',[0.1,1,3,6,10],'XTickLabel',[])
set(gainplot,'YTick',[0,0.25,0.5,0.75,1],'YTickLabel',[{'0','','0.5','','1'}])
axis([1 10 0 1.0])
set(gca,'box','on')
set(gca,'Layer','top')

         
%%%%%%%%% phase      
 
         phaseplot=subplot('Position',phaseplot_pos)

temp = mega.hoverfly.sine.phase;
lineprops.col = {hov_cols{3}};
h2{3} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {hov_cols{3}};
% mseb(temp{3}.mainLine.XData,temp{3}.mainLine.YData,temp{3}.mainLine.YData-temp{3}.edge(2).YData,lineprops);

hold on 

temp = mega.robberfly.sine.phase;
lineprops.col = {robber_cols{1}};
h2{4} = mseb(temp{1}.mainLine.XData,temp{2}.mainLine.YData,temp{2}.mainLine.YData-temp{2}.edge(2).YData,lineprops,1);
% lineprops.col = {robber_cols{3}};
% mseb(temp{4}.mainLine.XData,temp{4}.mainLine.YData,temp{4}.mainLine.YData-temp{4}.edge(2).YData,lineprops);

hold on 

temp = mega.blowfly.sine.phase;
lineprops.col = {color_mat{2}};
h2{1} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {color_mat{2}};
% mseb(temp{2}.mainLine.XData,temp{2}.mainLine.YData,temp{2}.mainLine.YData-temp{2}.edge(2).YData,lineprops);

hold on 

temp = mega.horsefly.sine.phase;
lineprops.col = {horse_cols{3}};
h2{2} = mseb(temp{1}.mainLine.XData,temp{1}.mainLine.YData,temp{1}.mainLine.YData-temp{1}.edge(2).YData,lineprops,1);
% lineprops.col = {horse_cols{3}};
% mseb(temp{3}.mainLine.XData,temp{3}.mainLine.YData,temp{3}.mainLine.YData-temp{3}.edge(2).YData,lineprops);

%%%%%%%%%%%%%%%%%%

l = legend([h2{1}.mainLine,h2{2}.mainLine,h2{4}.mainLine,h2{3}.mainLine,],'blowfly','horsefly','robberfly','hoverfly');
        set(l,'Location','best','box', 'off')
        set(gca,'box','on')
set(gca,'Layer','top')
        ylabel('Phase [\circ]')
        xlabel('Frequency [Hz]')
        set(phaseplot,'XTick',[0.1,1,3,6,10],'XTickLabel',{'0.1','1','3','6','10'})
       set(phaseplot,'YTick',[-90,-45,0])
        axis([1 10 -100 10])
set(gcf,'Position',plotsize_bode);
     set(gcf,'color','w');
export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\bode_mega'], '-openGL','-r660')
