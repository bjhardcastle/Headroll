%% plot mean traces for each condition (n=4)
%%
startup;


t=[1/800:1/800:10];
figure(89)
errbar = 0;

% head position

for cidx = 1

    plot(t,nanmean(condmeanstim(cidx).fly),'Color',[0.6,0.6,0.6],'LineWidth',1 )
    hold on    
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly),'Color',horse_cols{3},'LineWidth',1 )
    end
    
    ylim([-30 30])
%     title('')
    
end




set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/800:1/800:10];

errbar = 1;
clear tvecs
tvecs(1,:) = [1:8000];
t(1,:)=0+timesection;
t(2,:)=24.5+timesection;
t(3,:)=4+timesection;
% for offset axes
xoffset(1) = 0.02;
xoffset(2) = 0.05;
xoffset(3) = 0.05;
% cmap = colormap(lines);
    ylim([-32 40])


    set(gca,'ytick',[-30,0,30])

        
        set(gca,'yticklabel',{[-30],[0],[30]})
    ylabel('Amplitude [\circ]')

    xlabel('Time [s]')
set(gca,'box','off')
     offsetAxes(gca,xoffset(1),0.3);   


set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\tabanus_chirp','-openGL','-r660' )
