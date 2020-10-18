% Robber bode all conds..
    
    
clear all
close all
load DATA_RF_gain_phase.mat
startup;
plot_individual_gains_phases = 0;


% color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};


gainplot_pos = [0.15 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

     

%%%%%% Plot C1 vs C2 (without halteres)
 % becomes C3
%GAIN
cidx = 3;
%%plot c1 flies
for n = 1:4,
    for f = 1:9,
        
        ta1(n,f) = resp_gain_mean(1,f,n,1,1);
        
    end
    st1(n) = nanstd(ta1(n,:))/sqrt(9);
end

gainplot=subplot('Position',gainplot_pos)
lineprops.col = {robber_cols{cidx}};
h1{cidx} = mseb(round(freqs),nanmean(ta1,2),st1,lineprops,1);

title(['Frequency response: robberfly'])
ylabel('Gain')
set(gainplot,'XTick',[0.1,1,3,6,10],'XTickLabel',[])
axis([0 10.5 0 1.0])
set(gca,'box','on')

hold on

cidx = 4;
%%plot c2 flies
for n = 1:4,
    for f = 1:9,
        
        ta2(n,f) = resp_gain_mean(1,f,n,1,2);
        
    end
    st2(n) = nanstd(ta2(n,:))/sqrt(9);
end
lineprops.col = {robber_cols{cidx}};
h1{cidx} = mseb(round(freqs),nanmean(ta2,2),st2,lineprops,1);

hold on

%PHASE
cidx = 3;
%%plot c1 flies
for n = 1:4,
    for f = 1:9,
        tb1(n,f) = resp_phase_mean(1,f,n,1,1);
    end
    pt1(n) = nanstd(tb1(n,:))/sqrt(9);
end
phaseplot=subplot('Position',phaseplot_pos);
lineprops.col = {robber_cols{cidx}};
h2{cidx} = mseb(round(freqs),nanmean(tb1,2),pt1,lineprops,1);

hold on

cidx = 4;
%%plot c2 flies
for n = 1:4,
    for f = 1:9,
        tb2(n,f) = resp_phase_mean(1,f,n,1,2);
    end
    pt2(n) = std(tb2(n,:))/sqrt(9);
end
hold on
lineprops.col = {robber_cols{cidx}};
h2{cidx} = mseb(round(freqs),nanmean(tb2,2),pt2,lineprops,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot C3 vs C4 (conditions with halteres)
% become c1 c2

%GAIN

cidx = 1;
%plot c3 flies
for n = 1:4,
    for f = 1:9,
        
        ta3(n,f) = resp_gain_mean(2,f,n,1,3);
    end
    st3(n) = nanstd(ta3(n,:))/sqrt(9);
end
gainplot=subplot('Position',gainplot_pos);

lineprops.col = {robber_cols{cidx}};
h1{cidx} = mseb(round(freqs),nanmean(ta3,2),st3,lineprops,1);
hold on

cidx = 2;
%%plot c4 flies
for n = 1:4,
    for f = 1:10,
        
        ta4(n,f) =  resp_gain_mean(2,f,n,1,4);
        
    end
    st4(n) = nanstd(ta4(n,:))/sqrt(10);
end
lineprops.col = {robber_cols{cidx}};
h1{cidx} = mseb(round(freqs),nanmean(ta4,2),st4,lineprops,1);
hold on




%PHASE

cidx = 1;
%plot c3 flies
for n = 1:4,
    for f = 1:9,
        tb3(n,f) = resp_phase_mean(2,f,n,1,3);
    end
    pt3(n) = nanstd(tb3(n,:))/sqrt(9);
end
phaseplot=subplot('Position',phaseplot_pos)
lineprops.col = {robber_cols{cidx}};
h2{cidx} = mseb(round(freqs),nanmean(tb3,2),pt3,lineprops,1);
hold on

cidx = 2;
%%plot c4 flies
for n = 1:4,
    for f = 1:9,
        tb4(n,f) = resp_phase_mean(2,f,n,1,4);
    end
    pt4(n) = nanstd(tb4(n,:))/sqrt(10);
end
lineprops.col = {robber_cols{cidx}};
h2{cidx} = mseb(round(freqs),nanmean(tb4,2),pt4,lineprops,1);
hold on

l = legend([h2{1}.mainLine,h2{2}.mainLine,h2{3}.mainLine,h2{4}.mainLine,],'Halteres + compound eyes + ocelli', 'Halteres + compound eyes','Compound eyes + ocelli','Compound eyes');
set(l,'Location','best','box', 'off','LineWidth',1.5)
set(gca,'box','on')
ylabel('Phase [\circ]')
xlabel('Frequency [Hz]')
set(phaseplot,'XTick',[0.1,1,3,6,10],'XTickLabel',{'0.1','1','3','6','10'})
set(phaseplot,'YTick',[-180,-90,0])
axis([0 10.5 -190 15])
set(gcf,'Position',plotsize_bode);
set(gcf,'color','w');
% axis([0 11 -50 10])
set(gca,'Layer','top')

% export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\bode_robber'], '-openGL','-r660')
% 
% 
% load('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat')
% mega.robberfly.sine.gain = h1;
% mega.robberfly.sine.phase = h2;
% save('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat','mega')

