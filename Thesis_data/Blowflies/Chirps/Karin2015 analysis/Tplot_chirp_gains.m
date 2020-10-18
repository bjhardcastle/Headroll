startup;
cgainfig =  figure('Position', [103 141 600 340]);

subplot(2,2,1)
mean_fu = squeeze(mean(freqs_up,2));
mean_gu = squeeze(mean(gains_up,2));
err_gu = squeeze(std(gains_up,[],2)/sqrt(8));
% plot(mean_fu',mean_gu')
colormap = color_mat;

for cidx = 1:5
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
mseb(mean_fu(cidx,:),mean_gu(cidx,:),err_gu(cidx,:),lineprops,1);
end

ylim([0,1])
ylabel('HR gain')
title('Increasing chirp rate')
a1 = gca;

l = legend({'C1','C2','C3','C4','C5'},'Position',[0.94,0.71,0,0],'Location','southoutside')
% l = legend({'C1','C2','C3','C4','C5'},'Location','southoutside','Orientation','horizontal')
% l.Orientation = 'horizontal';
l.LineWidth = 2;
legend('boxoff')
% lpos = l.Position;
% lpos(3) = lpos(3)*0.5;
% l.Position = lpos;
set(gca,'clipping','off')
set(a1,'clipping','off')
% base_line = line([0 20], [0 0]);
% set(base_line, 'color', [150 150 150]/255 ,'linewidth', 0.5,'LineStyle','--'); % horizontal line

% a1.YScale = 'log';

subplot(2,2,2)
mean_fd = squeeze(mean(freqs_down,2));
mean_gd = squeeze(mean(gains_down,2));
err_gd = squeeze(std(gains_down,[],2)/sqrt(8));
% plot(mean_fd',mean_gd')
for cidx = 1:5
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
mseb(mean_fd(cidx,:),mean_gd(cidx,:),err_gd(cidx,:),lineprops,1);
end
ylim([0,1])
title('Decreasing chirp rate')
a2 = gca;
% base_line = line([0 20], [0 0]);
% set(base_line, 'color', [150 150 150]/255 ,'linewidth', 0.5,'LineStyle','--'); % horizontal line
% a2.YScale = 'log';


% mean_fu from previous
mean_lu = squeeze(mean(lags_up,2));
mean_ld = squeeze(mean(lags_down,2));
err_lu = squeeze(std(lags_up,[],2)/sqrt(8));
err_ld = squeeze(std(lags_down,[],2)/sqrt(8));
subplot(2,2,3)
% errorbar(mean_fu',mean_lu',err_lu')
for cidx = 1:5
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
mseb(mean_fu(cidx,:),mean_lu(cidx,:),err_lu(cidx,:),lineprops,1);
end
ylim([-270 0])
set(gca,'YTick',[-270,-180,-90,0])
xlabel('Frequency [Hz]')
ylabel('Phase [\circ]')


subplot(2,2,4)
% errorbar(mean_fd',mean_ld',err_ld')
for cidx = 1:5
    lineprops.col = {color_mat{cidx}};
lineprops.width = 1;
% pf = polyfit(mean_fd(cidx,:), mean_ld(cidx,:), 1);
% p = polyval(pf,mean_fd(cidx,:));
mseb(mean_fd(cidx,:),mean_ld(cidx,:),err_ld(cidx,:),lineprops,1);

end
ylim([-270 0])
set(gca,'YTick',[-270,-180,-90,0])
xlabel('Frequency [Hz]')

% l = legend({'C1','C2','C3','C4','C5'},'Position',[0.94,0.88,0,0],'Location','southoutside')
% % l = legend({'C1','C2','C3','C4','C5'},'Location','southoutside','Orientation','horizontal')
% % l.Orientation = 'horizontal';
% l.LineWidth = 2;
% legend('boxoff')
% % lpos = l.Position;
% % lpos(3) = lpos(3)*0.5;
% % l.Position = lpos;


 set(gca,'layer','bottom')
% set(gca,'Layer','top');

set(gca,'clipping','off')

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chripgains','-openGL','-r660')