close all
clear all

% Watch out! Periods of missing data (where animals weren't flying) are
% replaced with NaNs. Make use of nanmean / nanstd etc.

%%% load existing data:
    load('TRobbers2012data.mat')
get_plot_colours;
examplefig =  figure('Position', [143 341 600 270]);

left = 0.08;
lower = 0.08;
height = 0.16;
small_vgap = 0.05;
big_vgap = 0.11;
width = 0.35;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%LEFT TOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ANIMAL = 2;
FREQ = 1;
COND = 1;
%Single traces
% r = nanmean(all_r(1).a(1).c(1).animal(:,:));
r2 =all_r(FREQ).a(1).c(COND).animal(ANIMAL,:); %resp
s = all_s(FREQ).a(1).c(COND).animal(ANIMAL,:); %stim
t = all_t(FREQ).a(1).c(COND).animal(ANIMAL,:); %timevector


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1Hz stimulus TOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_position = [left (lower+3*height+2*small_vgap+big_vgap) width height]
stimfig1=subplot('Position',[plot_position]);

sf1=plot(t,smooth(s-nanmean(s),1))
box('off')

set(sf1,'Color',[color_mat{1}/255])
set(sf1,'LineWidth',2)

axis([2 5 -31 30])
set(stimfig1,'XTick',[0,1,2,3,4,5])
set(stimfig1,'XTickLabel',[])
set(stimfig1,'YTick',[-31,0,30])
set(stimfig1,'YTickLabel',{'-30','0','30'})
% set(stimfig1,'fontsize',12)
set(stimfig1,'Layer','top');

xlabel('')
title([{'A                                                                      '}])


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
h = ylabel(stimfig1,'TR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.03;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(c2fig,'HR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);

% xlabel
%{
xlabel('time [s]')


% shift x axis label closer to ticklabels
offset=0.4;
i = xlabel(c2fig,'time [s]');
set(i, 'Units', 'Normalized');
pos = get(i, 'Position');
set(i, 'Position', pos + [0, +offset, 0]);
%}

set(c2fig,'Layer','top');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%LEFT BOTTOM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FREQ = 4;
COND = 1;
ANIMAL = 3;

small_vgap = 0.05;


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
title([{'B                                                                      '}])


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


% shift y axis label closer to ticklabels
h = ylabel(stimfig2,'TR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.03;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(c3fig,'HR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);


xlabel('time [s]')

% shift x axis label closer to ticklabels
offset=0.4;
i = xlabel(c3fig,'time [s]');
set(i, 'Units', 'Normalized');
pos = get(i, 'Position');
set(i, 'Position', pos + [0, +offset, 0]);


set(c3fig,'Layer','top');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average cycle traces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vgap = 0.05; hgap = 0.025;
width = 0.2;
height = 0.32;
lower = 0.15;
mid = lower + height + vgap;
left = 0.55;
right = left + width + hgap;

pos_b(1).cond(1,:) = [left mid width height];
pos_b(2).cond(1,:) = [right mid width height];
pos_b(1).cond(2,:) = [left lower width height];
pos_b(2).cond(2,:) = [right lower width height];

freqs=[1,4];    %1Hz, 10Hz

%%% plot average cycles %%%
lineprops.width = 1;
lineprops.style = '-';

for fidx = 1:2
    for cidx = 1:2

b(fidx,cidx)= subplot('Position',pos_b(fidx).cond(cidx,:))

data = all_resp_cycles(freqs(fidx)).a(1).c(cidx).animal(:,:,:);
sizes = size(data);
cyc = reshape(data,[sizes(1)*sizes(2),sizes(3)]);% all 1Hz cycles

s = nanmean(stmmean(freqs(fidx)).a(1).c(cidx).animal(:,:));%mean stim
t = tmean(freqs(fidx)).a(1).c(1).animal(1,:); % time_vector

% %Shaded error bar plot,
sff = plot(t,smooth(s,length(s)/10))
set(sff,'LineWidth',2)
set(sff,'Color',[color_mat{1}/255])
hold on
lineprops.col = {[color_mat{cidx*2}/255]}; 

rf(fidx,cidx) = mseb(t,nanmean(cyc),(nanstd(cyc)/sqrt(3)),lineprops,0)



box('off')
ylim([-30 30])
set(b(fidx,cidx),'YTick',[-30,0,30]);
set(b(fidx,cidx),'YTickLabel',{'-30','0','30'});
set(b(fidx,cidx),'Layer','top');        %Sets fig axes in front of data

% Create inset label C1/C2
if fidx == 2
    if cidx ==1
        text(0.07,20,{'CE + O'},'Color',[color_mat{cidx*2}/255],'FontWeight','bold','FontSize',10)
    elseif cidx ==2
        text(0.07,20,{'      CE'},'Color',[color_mat{cidx*2}/255],'FontWeight','bold','FontSize',10)
    end
end
    end
end

set(b(1,1),'XTick',[0,0.5,1])
set(b(1,1),'XTickLabel',[])
set(b(2,1),'XTick',[0,0.05,0.1])
set(b(2,1),'XTickLabel',[])

set(b(1,2),'XTick',[0,0.5,1])
set(b(1,2),'XTickLabel',{'0','\pi','2\pi'})
set(b(2,2),'XTick',[0,0.05,0.1])
set(b(2,2),'XTickLabel',{'0','\pi','2\pi'})

% shift y axis label closer to ticklabels
h = ylabel(b(1,1),['roll angle [\circ]']);
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.05;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(b(1,2),['roll angle [\circ]']);
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);

xlabel(b(1,2),'cycle phase [rad]')
xlabel(b(2,2),'cycle phase [rad]')

set(b(2,1),'yTickLabel',[])
set(b(2,2),'yTickLabel',[])
title(b(1,1),[{'C                                                  '};{'1 Hz'}])
title(b(2,1),'10 Hz')

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\robber_example_traces','-openGL','-r660')
