
bfgainfig =  figure('Position', [103 141 600 340]);

    name_array2 = name_array(1,3:end);

        for cond = 1: length(cond_array)          
            
            
            subplot(2,2,1)
            hold on
            lineprops.col = {color_mat{2*cond}};
            mseb(name_array2(1,2:end),(squeeze(mean(G_Aab_mean(:,cond,2:end))))',squeeze(mean(G_Aab_std(:,cond,2:end)/sqrt(5)))',lineprops,1);
%             hold on
%             mseb(name_array2(1,:),(squeeze(mean(G_Aab_mean(:,cond,:))+k_factor*mean(G_Aab_std(:,cond,:)))),'c');
%             mseb(name_array2(1,:),(squeeze(mean(G_Aab_mean(:,cond,:))-k_factor*mean(G_Aab_std(:,cond,:)))),'c');
%             %             plot(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
%             hold off
            ylabel('HR gain')
            xlim([0 20])
            title('CFS equivalents')
            ylim([0 1])
set(gca,'YTick',[0,0.5,1])
      
      % some phase values of -360 exist. Phase wrap these..
      G_p_mean(1,cond,2) = 0;
      G_p_mean(5,cond,2) = 0;
            subplot(2,2,3)
             hold on
             lineprops.col = {color_mat{2*cond}};
            mseb(name_array2(1,2:end),(squeeze(mean(G_p_mean(:,cond,2:end))))',squeeze(mean(G_p_std(:,cond,2:end)/sqrt(5)))',lineprops,1);          
%             mseb(name_array2(1,:),squeeze(mean(G_p_mean(:,cond,:))),'o-b');
%             mseb(name_array2(1,:),squeeze(mean(G_p_mean(:,cond,:))+k_factor*mean(G_p_std(:,cond,:))),'c');
%             mseb(name_array2(1,:),squeeze(mean(G_p_mean(:,cond,:))-k_factor*mean(G_p_std(:,cond,:))),'c');
            xlabel('Frequency / Hz')
            %             plot(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylim([-270 0])
            xlim([0 20])
set(gca,'YTick',[-270,-180,-90,0])
xlabel('Frequency [Hz]')
ylabel('Phase [\circ]')


l = legend({'C2','C4'},'Position',[0.52,0.71,0,0],'Location','southoutside')
% l = legend({'C1','C2','C3','C4','C5'},'Location','southoutside','Orientation','horizontal')
% l.Orientation = 'horizontal';
l.LineWidth = 2;
legend('boxoff')
% lpos = l.Position;
% lpos(3) = lpos(3)*0.5;
% l.Position = lpos;
set(gca,'clipping','off')

% base_line = line([0 20], [0 0]);
% set(base_line, 'color', [150 150 150]/255 ,'linewidth', 0.5,'LineStyle','--'); % horizontal line

            
%             subplot(2,1,1)
%             plot(name_array2(1,:),(squeeze(mean(F_Aab_mean(:,cond,:)))),'o-b');
%             hold on
%             plot(name_array2(1,:),(squeeze(mean(F_Aab_mean(:,cond,:))+k_factor*mean(F_Aab_std(:,cond,:)))),'c');
%             plot(name_array2(1,:),(squeeze(mean(F_Aab_mean(:,cond,:))-k_factor*mean(F_Aab_std(:,cond,:)))),'c');
%             %             plot(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
%             hold off
%             ylabel('Open-loop Gain')
%             
%             subplot(2,1,2)
%             plot(name_array2(1,:),squeeze(mean(F_p_mean(:,cond,:))),'o-b');
%             hold on
%             plot(name_array2(1,:),squeeze(mean(F_p_mean(:,cond,:))+k_factor*mean(F_p_std(:,cond,:))),'c');
%             plot(name_array2(1,:),squeeze(mean(F_p_mean(:,cond,:))-k_factor*mean(F_p_std(:,cond,:))),'c');
%             xlabel('Frequency / Hz')
%             %             plot(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
%             hold off
%             ylabel('Open-loop Phase / deg')
            
%             mtit(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
            
        end

        
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\bfsines','-openGL','-r660')

%% Big standardised bode 
 name_array2 = name_array(1,3:end);

startup;
plot_individual_gains_phases = 0;

% freqs = roundn(stimfreqs,-1);
% % color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]};


        gainplot_pos = [0.15 0.55 0.8 0.38];
              % left bottom width height
phaseplot_pos = [0.15 0.123 0.8 0.38];

      


          
         lineprops.width = 1.5;
for cond = 1:length(cond_array)        
        

         gainplot=subplot('Position',gainplot_pos)
        
        hold on       
        
        lineprops.col = {color_mat{2*cond}};
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cond}/255]);
       h1{cond} =              mseb(name_array2(1,2:end),(squeeze(mean(G_Aab_mean(:,cond,2:end))))',squeeze(mean(G_Aab_std(:,cond,2:end)/sqrt(5)))',lineprops,1);

        if plot_individual_gains_phases
            hold on
            plot(freqs,CLg,'.', 'Color', [color_mat{cond}/255])
            hold off            
        end
end
        
title(['Frequency response: blowfly'])
ylabel('Gain')
set(gainplot,'XTick',[0.1,1,3,6,10],'XTickLabel',[])
axis([0 10.5 0 1.0])
set(gca,'box','on')
                   
        
for cond = 1:length(cond_array)           
        hold on
        
         phaseplot=subplot('Position',phaseplot_pos)
       lineprops.col = {color_mat{2*cond}};
        h2{cond} =  mseb(name_array2(1,2:end),(squeeze(mean(G_p_mean(:,cond,2:end))))',squeeze(mean(G_p_std(:,cond,2:end)/sqrt(5)))',lineprops,1);          
        
%         set(h, 'LineWidth', 3, 'Color', [color_mat{cond}/255]);
        if plot_individual_gains_phases
            hold on
            plot(freqs,CLp,'.', 'Color', [color_mat{cond}/255])
            hold off
        end


end
        l = legend([h2{1}.mainLine,h2{2}.mainLine,],'intact','no halteres');
        set(l,'Location','best','box', 'off')
        set(gca,'box','on')

        ylabel('Phase [\circ]')
        xlabel('Frequency [Hz]')
        set(phaseplot,'XTick',[0.1,1,3,6,10],'XTickLabel',{'0.1','1','3','6','10'})
       set(phaseplot,'YTick',[-180,-90,0])
        axis([0 15.5 -220 20])
set(gcf,'Position',plotsize_bode);
     set(gcf,'color','w');
%   export_fig(['C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\bode_calliphora'], '-openGL','-r660')


load('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat')
mega.blowfly.sine.gain = h1;
mega.blowfly.sine.phase = h2;
save('C:\Users\Ben\Dropbox\Work\Thesis\Thesis_data\mega.mat','mega')

