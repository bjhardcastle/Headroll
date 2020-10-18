
figure(89)
hold off
clear t
timesection = [1/800:1/800:0.5];
t(1,:)=0+timesection;
t(2,:)=2+timesection;
t(3,:)=4+timesection;
errbar = 1;
clear tvecs
tvecs(1,:) = [1:400];
tvecs(2,:) = [1401:1800];
tvecs(3,:) = [3601:4000];
% for offset axes
xoffset(1) = 0.02;
xoffset(2) = 0.05;
xoffset(3) = 0.05;
% cmap = colormap(lines);

% head position


for cidx = 1:5
    for tidx = 1:3;
    eval(['ax',num2str((cidx-1)*4+tidx),' = subplot(5,3,((cidx-1)*3+tidx));']);
    
    tsection = tvecs(tidx,:);
    
   
    plot( t(tidx,:),  nanmean(condmeanstim(cidx).fly(:,tsection),1),'Color',[0.6 0.6 0.6],'LineWidth',1.5)
    hold on

    if errbar == 1
        %error bars on:
        lineprops.col = {color_mat{cidx}}; 
        lineprops.width = 1;
        l= mseb(t(tidx,:),  nanmean(condmeanstim(cidx).fly(:,tsection),1) -nanmean(condmean(cidx).fly(:,tsection),1), condsem(cidx,tsection) ,lineprops);
    else
        plot(t(tidx,:), nanmean(condmean(cidx).fly(:,tsection),1),'Color',color_mat{cidx},'LineWidth',2)
    end
    
%     title(['C',num2str(cidx)])    
    if cidx ~= 5 
        set(gca,'xticklabel',[''])
    end

    set(gca,'ytick',[-30,0,30])
    if tidx ~=1
        set(gca,'yticklabel',[])
    else
        
        set(gca,'yticklabel',{[-30],[],[30]})
    end

     offsetAxes(gca,xoffset(tidx),0.18);   
     
%  if tidx == 3
%      legend(l.mainLine,{'c5'},'Position',[0.83 (0.93-cidx*0.165)  0.1 0])
%  end

if tidx == 1
    switch cidx
        case 1 
            titletext = 'C1: Intact';
        case 2
            titletext = 'C2: No ocelli';
        case 3
            titletext = 'C3: Dark';
        case 4
            titletext = 'C4: No halteres';
        case 5
            titletext = 'C5: No halteres, dark';
    end
    text(0.1,0.95,titletext,'Color',color_mat{cidx},'Units','normalized')
end
if cidx == 3 && tidx == 1
    ylabel('Amplitude [\circ]')
end
if cidx == 5 && tidx == 2
    xlabel('Time [s]')
end
% l = legend({'C5: No halteres, dark','C5: No halteres, dark','C5: No halteres, dark','C5: No halteres, dark','C5: No halteres, dark'})
% l.Position=[0.85 0.5 0 0];
% l.FontSize= 8;
% l.Box='off';

box off     
% set(gca,'Layer','top');


hold off

end
% linkaxes([ax1,ax2,ax3,ax4,ax5],'xy')
end
%}
%{
% relative response
figure

for cidx = 1:5
    eval(['ax',num2str(cidx),' = subplot(5,1,cidx);']);

   
    plot(t,   nanmean(condmeanstim(cidx).fly) )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) , condsem(cidx,:) );
    else
        plot(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) )
    end
%     if errbar == 1
%         error bars on:
%         mseb(t, ( nanmean(condmean(cidx).fly) ) , condsem(cidx,:) );
%     else
%         plot(t, ( nanmean(condmean(cidx).fly) ) )
%     end
    
    
    title(['C',num2str(cidx)])
    ylim([-30 30])
    
end
linkaxes([ax1,ax2,ax3,ax4,ax5],'xy')
%}
% set(gca,'clipping','off')
set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chriptraces_REL','-openGL','-r660' )