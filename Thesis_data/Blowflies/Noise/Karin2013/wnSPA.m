%%
clear all
load stim.mat

%% SPA - in rad/s 
flies = [1:9];
clear mag_up mag_down ph_up ph_down w_up w_down
%input vars:
fdr_win = [];
spa_frange = deg2rad([1:0.5:20]);
fdr_frange = {deg2rad(1),deg2rad(20)};
t_interval = 1;
spa_win = 400; % samples

for fidx = 1:length(flies)
    for cidx = 1
        % relative resp = stim - resp
        spadat(:,1) = stim - fly_mean(fidx,:);
        % stim = stim - mean(stim)
        spadat(:,2) = stim;
        
        % output          % input
        zu = iddata( spadat(:,1) , spadat(:,2), t_interval);
        zd = iddata( spadat(:,1) , spadat(:,2), t_interval);
        
        % spa and spafdr functions on data, up,down
        zsu = spa(zu,spa_win,spa_frange);
        zsd = spa(zd,spa_win,spa_frange);
        zfdru = spafdr(zu,fdr_win,fdr_frange);
        zfdrd = spafdr(zd,fdr_win,fdr_frange);
        
        [magu,phu,wu,sdmagu,sdphaseu] = bode(zsu);
        [magd,phd,wd,sdmagd,sdphased] = bode(zsd);
        [magfdru,phfdru,wfdru,sdmagfdru,sdphasefdru] = bode(zfdru);
        [magfdrd,phfdrd,wfdrd,sdmagfdrd,sdphasefdrd] = bode(zfdrd);
                
        % store freqs (in Hz) and gains
        mag_down(cidx,fidx,:) = squeeze(magd);
        w_down(cidx,fidx,:) = rad2deg(wd);
        ph_down(cidx,fidx,:) = phd;
        mag_up(cidx,fidx,:) = squeeze(magu);
        w_up(cidx,fidx,:) = rad2deg(wu);
        ph_up(cidx,fidx,:) = phu;
        
    end
end

%%
bode(zsu)
%%


% plot SPA mean gains by condition
figure(97)
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

%%
% Plot phase, calculated from SPA

figure(98)
subplot(1,2,1)
mean_fu = squeeze(mean(w_up,2));
mean_phu = squeeze(mean(ph_up,2));
err_phu = squeeze(std(ph_up,[],2)/sqrt(8));
plot(mean_fu',mean_phu')
% errorbar(mean_phu',mean_gu',err_gu')
% axis([0 20 -50 0])
xlabel('freq, Hz')
ylabel('phase')
title('chirp up')
legend({'c1','c2','c3','c4','c5'},'Location','northeast')

subplot(1,2,2)
mean_fd = squeeze(mean(w_down,2));
mean_phd = squeeze(mean(ph_down,2));
err_phd = squeeze(std(ph_down,[],2)/sqrt(8));
plot(mean_fd',mean_phd')
% errorbar(mean_phd',mean_gd',err_gd')
% axis([0 20 -50 0])
xlabel('freq, rad/s')
ylabel('phase')
title('chirp down')



































