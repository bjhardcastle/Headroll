startup;

chirpsinecompfig =  figure('Position', [103 141 600 340]);
% color_mat = hov_cols;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT CHIRP MEAN DATA

subplot(2,2,1)
mean_fu = squeeze(mean(freqs_up,2));
mean_gu = squeeze(mean(gains_up,2));
err_gu = squeeze(std(gains_up,[],2)/sqrt(8));
mean_fd = squeeze(mean(freqs_down,2));
mean_fd = flip(mean_fd,2);
mean_gd = squeeze(mean(gains_down,2));
mean_gd = flip(mean_gd,2);
err_gd = squeeze(std(gains_down,[],2)/sqrt(8));
err_gd = flip(err_gd,1);

mean_f = mean(cat(1,mean_fu(cidx,:),mean_fd(cidx,:)),1);
mean_g = mean(cat(1,mean_gu,mean_gd),1);
mean_e = mean(cat(1,err_gu,err_gd),1);


for cidx = [2,4]
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
mseb(mean(cat(1,mean_fu(cidx,:),mean_fd(cidx,:)),1),mean(cat(1,mean_gu(cidx,:),mean_gd(cidx,:)),1),mean(cat(1,err_gu(cidx,:),err_gd(cidx,:)),1),lineprops,1);
end

ylim([0,1])
ylabel('HR gain')
a1 = gca;
title('Chirp')



subplot(2,2,2)


% mean_fu from previous
mean_lu = squeeze(mean(lags_up,2));
mean_ld = squeeze(mean(lags_down,2));
mean_ld = flip(mean_ld,2);
err_lu = squeeze(std(lags_up,[],2)/sqrt(8));
err_ld = squeeze(std(lags_down,[],2)/sqrt(8));
err_ld = flip(err_ld,2);
mean_l = mean(cat(1,mean_lu,mean_ld),1);
mean_el = mean(cat(1,err_lu,err_ld),1);

subplot(2,2,3)
% errorbar(mean_fu',mean_lu',err_lu')
for cidx = [2,4]
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
mseb(mean(cat(1,mean_fu(cidx,:),mean_fd(cidx,:)),1),mean(cat(1,mean_lu(cidx,:),mean_ld(cidx,:)),1),mean(cat(1,err_lu(cidx,:),err_ld(cidx,:)),1),lineprops,1);
end
ylim([-270 0])
set(gca,'YTick',[-270,-180,-90,0])
xlabel('Frequency [Hz]')
ylabel('Phase [\circ]')


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    name_array2 = name_array(1,3:end);

        for cond = 1: length(cond_array)          
            
            
            subplot(2,2,2)
            hold on
            lineprops.col = {color_mat{2*cond}};
            mseb(name_array2(1,2:end),(squeeze(mean(G_Aab_mean(:,cond,2:end))))',squeeze(mean(G_Aab_std(:,cond,2:end)/sqrt(5)))',lineprops,1);
%             hold on
%             mseb(name_array2(1,:),(squeeze(mean(G_Aab_mean(:,cond,:))+k_factor*mean(G_Aab_std(:,cond,:)))),'c');
%             mseb(name_array2(1,:),(squeeze(mean(G_Aab_mean(:,cond,:))-k_factor*mean(G_Aab_std(:,cond,:)))),'c');
%             %             plot(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
%             hold off
%             ylabel('HR gain')
            xlim([0 20])
            title('CFS')
            ylim([0 1])
set(gca,'YTick',[0,0.5,1])

      % some phase values of -360 exist. Phase wrap these..
      G_p_mean(1,cond,2) = 0;
      G_p_mean(5,cond,2) = 0;
            subplot(2,2,4)
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
% ylabel('Phase [\circ]')


% l = legend({'C2','C4'},'Position',[0.52,0.71,0,0],'Location','southoutside')
% % l = legend({'C1','C2','C3','C4','C5'},'Location','southoutside','Orientation','horizontal')
% % l.Orientation = 'horizontal';
% l.LineWidth = 2;
% legend('boxoff')
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

     l = legend({'C2: no ocelli','C4: no halteres'},'Position',[0.85,0.2,0,0],'Location','southoutside')
% l = legend({'C1','C2','C3','C4','C5'},'Location','southoutside','Orientation','horizontal')
% l.Orientation = 'horizontal';
l.LineWidth = 2;
legend('boxoff')
   
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chirpsinecompare','-openGL','-r660')