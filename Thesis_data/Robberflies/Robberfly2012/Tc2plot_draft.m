% close all
examplefig =  figure('Position', [   143 341 600 270]);

left = 0.08;
lower = 0.05;
height = 0.18;
small_vgap = 0.05;
big_vgap = 0.08;
width = 0.25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%LEFT TOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ANIMAL = 2;
FREQ = 2;
COND = 1;
%Single traces
% r = nanmean(all_r(1).a(1).c(1).animal(:,:));
r2 =all_r(FREQ).a(1).c(COND).animal(ANIMAL,:); %resp
s = all_s(FREQ).a(1).c(COND).animal(ANIMAL,:); %stim
t = all_t(FREQ).a(1).c(COND).animal(ANIMAL,:); %timevector


plot_position = [left (lower+3*height+2*small_vgap+big_vgap) width height]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1Hz stimulus TOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stimfig1=subplot('Position',[plot_position]);

sf1=plot(t,smooth(s-nanmean(s),1))
box('off')

set(sf1,'Color',[color_mat{1}/255])
set(sf1,'LineWidth',2)

axis([2 5 -30 30])
set(stimfig1,'XTick',[0,1,2,3,4,5])
set(stimfig1,'XTickLabel',[])
set(stimfig1,'YTick',[-30,0,30])
set(stimfig1,'YTickLabel',{'-30','0','30'})
% set(stimfig1,'fontsize',12)
set(stimfig1,'Layer','top');
xlabel('')
title([{'A                                                   '}])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1Hz example response 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_position = [left (lower+2*height+1*small_vgap+big_vgap) width height]

c2fig=subplot('Position',plot_position);
c2f=plot(t,smooth(r2-nanmean(2),1))
box('off')

set(c2f,'Color',[color_mat{2}/255])
set(c2f,'LineWidth',1)

axis([2 5 -30 30])
set(c2fig,'XTick',[2,3,4,5])
set(c2fig,'XTickLabel',{'0','1','2','3','4',})
set(c2fig,'YTick',[-30,0,30])
set(c2fig,'YTickLabel',{'-30','0','30'})

% set(c2fig,'fontsize',12)
% xlabel('time [s]')

% shift y axis label closer to ticklabels
h = ylabel(stimfig1,'\theta_{stim} [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.03;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(c2fig,'\theta_{head} [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);

set(c2fig,'Layer','top');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%LEFT BOTTOM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FREQ = 4;
COND = 1;
ANIMAL = 3;

small_vgap = 0.05;
big_vgap = 0.08;

%Single traces
% r = nanmean(all_r(1).a(1).c(1).animal(:,:));
r2 =all_r(FREQ).a(1).c(COND).animal(ANIMAL,:); %resp
s = all_s(FREQ).a(1).c(COND).animal(ANIMAL,:); %stim
t = all_t(FREQ).a(1).c(COND).animal(ANIMAL,:); %timevector


plot_position = [left (lower+1*height+1*small_vgap) width height]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 10Hz stimulus BOTTOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stimfig2=subplot('Position',[plot_position]);

sf2=plot(t,smooth(s-nanmean(s),1))
box('off')

set(sf2,'Color',[color_mat{1}/255])
set(sf2,'LineWidth',2)

axis([-0 1 -30 30])
set(stimfig2,'XTick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1])
set(stimfig2,'XTickLabel',[])
set(stimfig2,'YTick',[-30,0,30])
set(stimfig2,'YTickLabel',{'-30','0','30'})
% set(stimfig2,'fontsize',12)
set(stimfig2,'Layer','top');
xlabel('')
title([{'B                                                   '}])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 10Hz example response BOTTOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_position = [left (lower) width height]

c3fig=subplot('Position',plot_position);
c3f=plot(t,smooth(r2-nanmean(2),1))
box('off')

set(c3f,'Color',[color_mat{2}/255])
set(c3f,'LineWidth',1)

axis([-0 1 -30 30])
set(c3fig,'XTick',[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1])
set(c3fig,'XTickLabel',{'0','','','','','','','','','','1'})
set(c3fig,'YTick',[-30,0,30])
set(c3fig,'YTickLabel',{'-30','0','30'})

% set(c3fig,'fontsize',12)
xlabel('time [s]')

% shift y axis label closer to ticklabels
h = ylabel(stimfig2,'\theta_{stim} [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.03;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(c3fig,'\theta_{head} [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);

% shift x axis label closer to ticklabels
offset=0.26;
i = xlabel(c3fig,'time [s]');
set(i, 'Units', 'Normalized');
pos = get(i, 'Position');
set(i, 'Position', pos + [0, +offset, 0]);


set(c3fig,'Layer','top');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


