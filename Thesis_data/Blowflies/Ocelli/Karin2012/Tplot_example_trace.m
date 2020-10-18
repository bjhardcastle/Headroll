close all
clear all
%%% load existing data:
    load('TKarin2012data.mat')
startup;

% examplefig =  figure('Position', [   208   495   891   395]);
examplefig =  figure('Position', [   143 341 600 270]);

%Single traces
r = mean(all_r(1).a(3).c(1).animal(:,:));
r2 =all_r(1).a(3).c(2).animal(7,:); %resp
s = all_s(1).a(3).c(1).animal(8,:); %stim
t = all_t(1).a(3).c(1).animal(8,:); %timevector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1Hz stimulus 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stimfig=subplot('Position',[0.08 0.56 0.35 0.25]);

sf=plot(t,0.95*smooth(s-mean(s),10));
box('off')

set(sf,'Color',[color_mat{6}])
set(sf,'LineWidth',2)

axis([-0 5.2 -30 30])
set(stimfig,'XTick',[0,1,2,3,4,5])
set(stimfig,'XTickLabel',[])
set(stimfig,'YTick',[-30,0,30])
set(stimfig,'YTickLabel',{'-30','0','30'})
% set(stimfig,'fontsize',12)
set(stimfig,'Layer','top');
xlabel('')
title([{'A                                                                     '};{''}])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot 1Hz response (C2, without ocelli)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c1fig=subplot('Position',[0.08 0.25 0.35 0.25]);
c1f=plot(t,smooth(r2-mean(2),1));
box('off')

set(c1f,'Color',[color_mat{2}])
set(c1f,'LineWidth',1)

axis([-0 5.2 -30 30])
set(c1fig,'XTick',[0,1,2,3,4,5])
set(c1fig,'XTickLabel',{'0','1','2','3','4','5'})
set(c1fig,'YTick',[-30,0,30])
set(c1fig,'YTickLabel',{'-30','0','30'})

% set(c1fig,'fontsize',12)
xlabel('time [s]')

% shift y axis label closer to ticklabels
h = ylabel(stimfig,'TR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.03;
set(h, 'Position', pos + [+offset, 0, 0]);
h = ylabel(c1fig,'HR [\circ]');
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
set(h, 'Position', pos + [+offset, 0, 0]);

set(c1fig,'Layer','top');

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

b(fidx,cidx)= subplot('Position',pos_b(fidx).cond(cidx,:));

data = all_resp_cycles(freqs(fidx)).a(3).c(cidx).animal(:,:,:);
sizes = size(data);
cyc = reshape(data,[sizes(1)*sizes(2),sizes(3)]);% all 1Hz cycles

s = mean(stmmean(freqs(fidx)).a(3).c(cidx).animal(:,:));%mean stim
t = tmean(freqs(fidx)).a(3).c(1).animal(1,:); % time_vector

% %Shaded error bar plot,
sff = plot(t,smooth(s,length(s)/10));
set(sff,'LineWidth',2)
set(sff,'Color',[color_mat{6}])
hold on
lineprops.col = {[color_mat{cidx*2}]}; 

rf(fidx,cidx) = mseb(t,mean(cyc),(std(cyc)/sqrt(8)),lineprops,0);



box('off')
ylim([-30 30])
set(b(fidx,cidx),'YTick',[-30,0,30]);
set(b(fidx,cidx),'YTickLabel',{'-30','0','30'});
set(b(fidx,cidx),'Layer','top');        %Sets fig axes in front of data

% Create inset label C1/C2
if fidx == 2
    if cidx ==1
        text(0.07,20,{'CE + O'},'Color',[color_mat{cidx*2}],'FontWeight','bold','FontSize',10);
    elseif cidx ==2
        text(0.07,20,{'     CE'},'Color',[color_mat{cidx*2}],'FontWeight','bold','FontSize',10);
    end
end

    end
end
% 
% l(1) = legend(b(2,1),'CE + O');
% l(2) = legend(b(2,2),'CE');
% 
% for cidx = 1:2
%     set(l(cidx),'Location','northeast','box', 'off');
%     l(cidx).TextColor = [color_mat{cidx*2}];
%     l(cidx).FontSize = 10;
%     l(cidx).FontWeight = 'bold';
% end
% %     l2 = get(l(cidx),'children') ; 
% delete(l2(1)) ;

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
title(b(1,1),[{'B                                                  '};{'1 Hz'}])
title(b(2,1),'10 Hz')

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_4\Figures\example_traces','-openGL','-r660')
