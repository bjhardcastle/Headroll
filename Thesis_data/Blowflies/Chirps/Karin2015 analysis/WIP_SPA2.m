%input vars:
        spa_win = 800; %samples
        fdr_win = [];
        spa_frange = [1:0.5:100];
        fdr_frange = {1,100,200};
        t_interval = 1/800;

for fidx = 1:length(flies)
    for cidx = 1:5
        % relative resp = stim - resp
        dat(:,1) = (condmeanstim(cidx).fly(fidx,:) -  condmean(cidx).fly(fidx,:));
        % stim = stim - mean(stim)
        dat(:,2) = condmeanstim(cidx).fly(fidx,:) - nanmean(condmeanstim(cidx).fly(fidx,:));                      

            % output          % input   
zu = iddata( dat(1:4000,1) , dat(1:4000,2), t_interval);
zd = iddata( dat(4001:8000,1) , dat(4001:8000,2), t_interval);

% spa and spafdr functions on data, up,down 
zsu = spa(zu,spa_win,spa_frange);
zsd = spa(zd,spa_win,spa_frange);
zfdru = spafdr(zu,fdr_win,fdr_frange);
zfdrd = spafdr(zd,fdr_win,fdr_frange);

[magu,phu,wu,sdmagu,sdphaseu] = bode(zsu);
[magd,phd,wd,sdmagd,sdphased] = bode(zsd);
[magfdru,phfdru,wfdru,sdmagfdru,sdphasefdru] = bode(zfdru);
[magfdrd,phfdrd,wfdrd,sdmagfdrd,sdphasefdrd] = bode(zfdrd);

        % plot [up,down] freq vs gain, each fly, each cond
        figure(99)
        subplot(8,5,(fidx-1)*5 + cidx)
        hold on
        plot(wu,squeeze(magu),'Linewidth',2)
        plot(wd,squeeze(magd),'Linewidth',2)
        plot(wfdru,squeeze(magfdru),':','Linewidth',2)
        plot(wfdrd,squeeze(magfdrd),':','Linewidth',2)
                
        if fidx == 1,title(['C',num2str(cidx)]),end
        axis([0 22 0 1])
        hold off
        
        % store freqs and gains
        mag_down(cidx,fidx,:) = squeeze(magd);
        w_down(cidx,fidx,:) = wd;
        mag_up(cidx,fidx,:) = squeeze(magu);
        w_up(cidx,fidx,:) = wu;

    end
end


%% plot mean gains by condition 

figure(98)
subplot(1,2,1)
mean_fu = squeeze(mean(w_up,2));
mean_gu = squeeze(mean(mag_up,2));
err_gu = squeeze(std(mag_up,[],2)/sqrt(8));
% plot(mean_fu',mean_gu')
errorbar(mean_fu',mean_gu',err_gu')
axis([0 20 0 0.8])
xlabel('freq, Hz')
ylabel('gain')
title('chirp up')
legend({'c1','c2','c3','c4','c5'},'Location','northeast')

subplot(1,2,2)
mean_fd = squeeze(mean(w_down,2));
mean_gd = squeeze(mean(mag_down,2));
err_gd = squeeze(std(mag_down,[],2)/sqrt(8));
% plot(mean_fd',mean_gd')
errorbar(mean_fd',mean_gd',err_gd')
axis([0 20 0 0.8])
xlabel('freq, Hz')
ylabel('gain')
title('chirp down')









