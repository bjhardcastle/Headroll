% Subfile for plotting Eristalinus aeneus CHIRP DATA
% c1 - intact
% c2 - ocelli painted, lights on 
% c3 - ocelli painted, without halteres, lights on

clear all
load 'DATA_chirp.mat'

% organise mean responses
flies = [1,2,3,4,5,7];
lencond = 3;
fps = 1200;

clear condmean
% mean condition for each fly

% Unlike the blowfly data, we have 1 trial per fly here EXCEPT fly 1, where
% there are 8 trials. So take mean trial for fly 1, then continue process
    for cidx = 1:lencond
        for fidx = 1:length(flies) %fly 8 is missing wind cond
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                condmean(cidx).fly(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial,2);
                condmeanstim(cidx).fly(fidx,:) = nanmean(stims.fly(fidx).cond(cidx).trial,2);
            else
                condmean(cidx).fly(fidx,:) = NaN(1,12000);
                condmeanstim(cidx).fly(fidx,:) = NaN(1,12000);

            end
        end
        allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);

    end


clear condallfly
% aggregate all trials for all flies, by condition

    for cidx = 1:lencond
        
        allidx = 0;
        for fidx = 1:length(flies)
            
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                for tidx = 1: tn
                    allidx = allidx + 1;
                    condallfly(cidx).all(allidx,:) = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                    condallflystim(cidx).all(allidx,:) = stims.fly(fidx).cond(cidx).trial(:,tidx);
                end
                
            else
                condmean(cidx).fly(fidx,:) = NaN(1,12000);
                condmeanstim(cidx).fly(fidx,:) = NaN(1,12000);

            end
            
            
        end
        condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(flies) - 1);
        condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(flies) - 1);
        
    end







%% plot mean traces for each condition (n=6)
t=[1/fps:1/fps:10];
figure(89)
errbar = 1;

% head position

figure
for cidx = 1:lencond
    eval(['ax',num2str(cidx),' = subplot(lencond,1,cidx);']);
  
    plot(t,   nanmean(condmeanstim(cidx).fly) )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly) )
    end
    
    ylim([-30 30])
    title(['C',num2str(cidx)])
    
end
%}

% relative response
figure
for cidx = 1:lencond
    
     eval(['ax',num2str(cidx),' = subplot(lencond,1,cidx);']);
   
    plot(t,   nanmean(condmeanstim(cidx).fly) )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) , condsem(cidx,:) );
    else
        plot(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) )
    end
    
    
    title(['C',num2str(cidx)])
    ylim([-30 30])
    
end
%}

linkaxes([ax1,ax2,ax3],'xy');

%% plot each freq vs gain, from spectrogram, using mean resp

%input vars:
win_size = 1200; %samples
overlap_size = 1050;
spect_freq_range = [0.5 : 0.1 : 30];
sampling_rate = 1200;
freq_loc_on_graph = 'yaxis';

fidx = 1;
    for cidx = 1:lencond
        % abs resp = stim - resp
        dat(:,1) =  allmean(cidx,:);
        % stim = stim - mean(stim)
        dat(:,2) = allmeanstim(cidx,:) - nanmean(allmeanstim(cidx,:));
        
        % get spectrogram data for FIRST HALF (up) resp
        [suR,fuR,tuR,puR] = spectrogram(dat(1:6600,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [suS,fuS,tuS,puS] = spectrogram(dat(1:6600,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        % get spectrogram data for SECOND HALF (down) resp
        [sdR,fdR,tdR,pdR] = spectrogram(dat(5401: 12000,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [sdS,fdS,tdS,pdS] = spectrogram(dat(5401:12000,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        
        % Gain = output spectrum / input spectrum
        gu = suR./suS;          gd = sdR./sdS;
        % find peak frequency in stim signal timewindow
        for stepidx = 1:size(suS,2) % for each window
            [~, flu] = findpeaks(abs(suS(:,stepidx)),'SortStr','descend');
            
            gainsu(stepidx) = abs(gu(flu(1),stepidx));
            flocsu(stepidx) = fuS(flu(1));
        end
        
        for stepidx = 1:size(sdS,2) % for each window
            [~, fld] = findpeaks(abs(sdS(:,stepidx)),'SortStr','descend');
            
            gainsd(stepidx) = abs(gd(fld(1),stepidx));
            flocsd(stepidx) = fdS(fld(1));
        end
        
        % plot [up,down] freq vs gain, each fly, each cond
%         figure(91)
%         subplot(8,lencond,(fidx-1)*lencond + cidx)
%         plot(flocsu,gainsu,'Linewidth',2)
%         hold on
%         plot(flocsd,gainsd,'Linewidth',2)
%         if fidx == 1,title(['C',num2str(cidx)]),end
%         ylim([0 1])
%         hold off
        
        % store freqs and gains
        gains_down(cidx,:) = 1-gainsd;
        freqs_down(cidx,:) = flocsd;
        gains_up(cidx,:) = 1-gainsu;
        freqs_up(cidx,:) = flocsu;
        
        
        %%% Calculate lag by cross-correlation in the same windows
        %%% as used for FFTs. 
        %%%
        %%% Also find velocity of stim & absolute resp
        xwin_size = 1200;
        xoverlap = 1050;
        underlap = (xwin_size - xoverlap);
        
        clear datALOUT datALIN cor_u lu cor_d ld lag_u lag_d corr_u corr_d
        datALOUT = dat(:,1);
        datALIN = dat(:,2);
        datABS = allmean(cidx,:);
        
        for stepidx = 1: 1 + (floor(length(datALIN)/2)+floor(0.5*xwin_size) - xwin_size)/underlap
            
            steprange = [1 + (stepidx-1)*underlap : xwin_size + (stepidx-1)*underlap];
            % Up section
            [cor_u, lu] = xcorr(datALIN(steprange) , datALOUT(steprange)  );
            [~,ph] = max(cor_u( 1: ceil(length(lu)/2) ) );
            lag_u(stepidx) = lu(ph);
            corr_u(stepidx,:) = cor_u;
            
            % Down section
            steprange_d = [5401 + (stepidx-1)*underlap : 5400 + xwin_size + (stepidx-1)*underlap];
            [cor_d, ld] = xcorr(datALIN(steprange_d) , datALOUT(steprange_d));
            [~,ph] = max(cor_d( 1: ceil(length(ld)/2) ) );
            lag_d(stepidx) = ld(ph);
            corr_d(stepidx,:) = cor_d;
        end
        
        % store freqs and gains
        lags_down(cidx,:) = lag_d;
        lags_up(cidx,:) = lag_u;
        
    end
    
    


%{
%% plot gains by condition (the mean across all flies was used to create data)
% figure
% subplot(1,2,1)
% % mean_fu = squeeze(mean(freqs_up,1));
% mean_gu = squeeze(mean(gains_up,2));
err_gu(1,:) = squeeze(std(gains_up,[],1)/sqrt(6))';
err_gu(2,:) = squeeze(std(gains_up,[],1)/sqrt(3))';
err_gu(3,:) = squeeze(std(gains_up,[],1)/sqrt(5))';

% plot(freqs_up',gains_up')
errorbar(freqs_up',gains_up',err_gu')
ylim([0,1])
xlabel('freq, Hz')
ylabel('gain')
title('chirp up ABS')
legend({'c1','c2','c3'},'Location','northeast')

subplot(1,2,2)
% mean_fd = squeeze(mean(freqs_down,1));
% % mean_gd = squeeze(mean(gains_down,1));
err_gd(1,:) = squeeze(std(gains_down,[],1)/sqrt(6))';
err_gd(2,:) = squeeze(std(gains_down,[],1)/sqrt(3))';
err_gd(3,:) = squeeze(std(gains_down,[],1)/sqrt(5))';


% plot(freqs_down',gains_down')
errorbar(freqs_down',gains_down',err_gd')
ylim([0,1])
xlabel('freq, Hz')
ylabel('gain')
title('chirp down ABS')
%}
%{
%% Plot lags from spect xcorr
figure(93)
% mean_fu from previous
% mean_lu = squeeze(mean(lags_up,2));
% mean_ld = squeeze(mean(lags_down,2));
err_lu(1,:) = squeeze(std(lags_up,[],1)/sqrt(6))';
err_lu(2,:) = squeeze(std(lags_up,[],1)/sqrt(3))';
err_lu(3,:) = squeeze(std(lags_up,[],1)/sqrt(5))';
err_ld(1,:) = squeeze(std(lags_down,[],1)/sqrt(6))';
err_ld(2,:) = squeeze(std(lags_down,[],1)/sqrt(3))';
err_ld(3,:) = squeeze(std(lags_down,[],1)/sqrt(5))';
subplot(1,2,1)
errorbar(freqs_up',lags_up',err_lu')
ylim([-180 50])
subplot(1,2,2)
errorbar(freqs_down',lags_down',err_ld')
ylim([-180 50])
%}
% Get mean lags (degrees,phase) for each condition, up&down. Convert to samples
avg_lag(:,1) = mean(lags_up,2);
avg_lag(:,2) = mean(lags_down,2);


% Shift resp by mean lag, then calc relative spectrogram
% Response to low frequencies are distorted here, because head lag is
% likely to be less.. however these are underrepresented and less reliable
% anyway.
%input vars:
win_size = 1200; %samples
overlap_size = 1050;
spect_freq_range = [0.5 : 0.1 : 30];
sampling_rate = 1200;
freq_loc_on_graph = 'yaxis';

lagshift = abs(round(mean(avg_lag,2)));

fidx = 1;
    for cidx = 1:lencond
        
        % shifted resp 
        shiftedallmean = allmean(cidx,lagshift(cidx):end);
         shiftedallmean(end:end+lagshift(cidx)-1) = 0;
        
        % abs resp = stim - resp
        dat(:,1) =  allmeanstim(cidx,:) - shiftedallmean;
        % stim = stim - mean(stim)
        dat(:,2) = allmeanstim(cidx,:) - nanmean(allmeanstim(cidx,:));
        
        % get spectrogram data for FIRST HALF (up) resp
        [suR,fuR,tuR,puR] = spectrogram(dat(1:6600,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [suS,fuS,tuS,puS] = spectrogram(dat(1:6600,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        % get spectrogram data for SECOND HALF (down) resp
        [sdR,fdR,tdR,pdR] = spectrogram(dat(5401: 12000,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [sdS,fdS,tdS,pdS] = spectrogram(dat(5401:12000,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        
        % Gain = output spectrum / input spectrum
        gu = suR./suS;          gd = sdR./sdS;
        % find peak frequency in stim signal timewindow
        for stepidx = 1:size(suS,2) % for each window
            [~, flu] = findpeaks(abs(suS(:,stepidx)),'SortStr','descend');
            
            gainsu(stepidx) = abs(gu(flu(1),stepidx));
            flocsu(stepidx) = fuS(flu(1));
        end
        
        for stepidx = 1:size(sdS,2) % for each window
            [~, fld] = findpeaks(abs(sdS(:,stepidx)),'SortStr','descend');
            
            gainsd(stepidx) = abs(gd(fld(1),stepidx));
            flocsd(stepidx) = fdS(fld(1));
        end
        
        % plot [up,down] freq vs gain, each fly, each cond
%         figure(91)
%         subplot(8,lencond,(fidx-1)*lencond + cidx)
%         plot(flocsu,gainsu,'Linewidth',2)
%         hold on
%         plot(flocsd,gainsd,'Linewidth',2)
%         if fidx == 1,title(['C',num2str(cidx)]),end
%         ylim([0 1])
%         hold off
        
        % store freqs and gains
        gains_down(cidx,:) = gainsd;
        freqs_down(cidx,:) = flocsd;
        gains_up(cidx,:) = gainsu;
        freqs_up(cidx,:) = flocsu;
        
        
%         %%% Calculate lag by cross-correlation in the same windows
%         %%% as used for FFTs. 
%         %%%
%         %%% Also find velocity of stim & absolute resp
%         xwin_size = 1200;
%         xoverlap = 1050;
%         underlap = (xwin_size - xoverlap);
%         
%         clear datALOUT datALIN cor_u lu cor_d ld lag_u lag_d corr_u corr_d
%         datALOUT = dat(:,1);
%         datALIN = dat(:,2);
%         datABS = allmean(cidx,:);
%         
%         for stepidx = 1: 1 + (floor(length(datALIN)/2)+floor(0.5*xwin_size) - xwin_size)/underlap
%             
%             steprange = [1 + (stepidx-1)*underlap : xwin_size + (stepidx-1)*underlap];
%             % Up section
%             [cor_u, lu] = xcorr(datALIN(steprange) , datALOUT(steprange)  );
%             [~,ph] = max(cor_u( 1: ceil(length(lu)/2) ) );
%             lag_u(stepidx) = lu(ph);
%             corr_u(stepidx,:) = cor_u;
%             
%             % Down section
%             steprange_d = [5401 + (stepidx-1)*underlap : 5400 + xwin_size + (stepidx-1)*underlap];
%             [cor_d, ld] = xcorr(datALIN(steprange_d) , datALOUT(steprange_d));
%             [~,ph] = max(cor_d( 1: ceil(length(ld)/2) ) );
%             lag_d(stepidx) = ld(ph);
%             corr_d(stepidx,:) = cor_d;
%         end
%         
% %         % store freqs and gains
% %         lags_down(cidx,:) = lag_d;
% %         lags_up(cidx,:) = lag_u;
% %         
    end
    
    
Tchirp_sine_compare;
%% plot gains by condition (the mean across all flies was used to create data)

figure(92)
subplot(1,2,1)
% mean_fu = squeeze(mean(freqs_up,1));
% mean_gu = squeeze(mean(gains_up,2));
err_gu(1,:) = squeeze(std(gains_up,[],1)/sqrt(6))';
err_gu(2,:) = squeeze(std(gains_up,[],1)/sqrt(3))';
err_gu(3,:) = squeeze(std(gains_up,[],1)/sqrt(5))';

% plot(mean_fu',mean_gu')
errorbar(freqs_up',gains_up',err_gu')
ylim([0,1])
xlabel('freq, Hz')
ylabel('gain')
title('chirp up REL')
legend({'c1','c2','c3'},'Location','northeast')

subplot(1,2,2)
% mean_fd = squeeze(mean(freqs_down,1));
% mean_gd = squeeze(mean(gains_down,1));
err_gd(1,:) = squeeze(std(gains_down,[],1)/sqrt(6))';
err_gd(2,:) = squeeze(std(gains_down,[],1)/sqrt(3))';
err_gd(3,:) = squeeze(std(gains_down,[],1)/sqrt(5))';


% plot(mean_fd',mean_gd')
errorbar(freqs_down',gains_down',err_gd')
ylim([0,1])
xlabel('freq, Hz')
ylabel('gain')
title('chirp down REL')


%% SPA - in rad/s 
clear mag_up mag_down ph_up ph_down w_up w_down
%input vars:
fdr_win = [];
spa_frange = deg2rad([1:0.5:20]);
fdr_frange = {deg2rad(1),deg2rad(20)};
t_interval = 1;
spa_win = 400; % samples

for fidx = 1:length(flies)
    for cidx = 1:lencond
        % relative resp = stim - resp
        spadat(:,1) = (condmeanstim(cidx).fly(fidx,:) -  condmean(cidx).fly(fidx,:));
        % stim = stim - mean(stim)
        spadat(:,2) = condmeanstim(cidx).fly(fidx,:) - nanmean(condmeanstim(cidx).fly(fidx,:));
        
        % output          % input
        zu = iddata( spadat(1:4000,1) , spadat(1:4000,2), t_interval);
        zd = iddata( spadat(4001:8000,1) , spadat(4001:8000,2), t_interval);
        
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
figure
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
legend({'c1','c2','c3'},'Location','northeast')

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
legend({'c1','c2','c3'},'Location','northeast')

subplot(1,2,2)
mean_fd = squeeze(mean(w_down,2));
mean_phd = squeeze(mean(ph_down,2));
err_phd = squeeze(std(ph_down,[],2)/sqrt(6));
plot(mean_fd',mean_phd')
% errorbar(mean_phd',mean_gd',err_gd')
% axis([0 20 -50 0])
xlabel('freq, rad/s')
ylabel('phase')
title('chirp down')

%% Find slipspeeds from abs head angle trace

% chirp_franslipspeeds;

% s = nanmean(condmeanstim(1).fly);
% x = diff(s).*fps;
% 
% figure 
% for cidx = 1:4
% yyz=allmeanrel(cidx,:);
% % plot(tx,yyz), hold on
% %inflection points:
% % plot(tx(locs),yyz(locs),'r.','Markersize',15)
% %velocities:
% velr = abs(diff(yyz(locs)));
% vels = abs(diff(s(locs)));
% velg = velr./vels;
% velgains = velg(velg<1); % disregard erroneous gains 
% % plot(velr),hold on,plot(velr)
% freqs_at_timepts = vels ./ diff(tx(locs)) ; % in deg/s
% velfreqs = freqs_at_timepts(velg<1);
% sf = scatter(velfreqs,velgains);
% hold on
% scatter_color = get(sf, 'CData');
% p = polyfit(velfreqs, velgains, 1);
% velfit = polyval(p,velfreqs);
% fitfig = plot(velfreqs,velfit);
% set(fitfig,'Color',scatter_color)
% 
% % [vhr,redges] = histcounts(velr,20);
% % [vhs,sedges] = histcounts(vels,20);
% % plot(sedges(2:end),vhs,'k'),hold on
% % plot(redges(2:end),vhr)
% 
% end
% 

%             
%             % store head & body sections, up & down chirp
%             abs_head_section(cidx).fly(fidx).step(stepidx).uangle(:) = datABS(steprange);
%             stim_section(cidx).fly(fidx).step(stepidx).uangle(:) = datALIN(steprange);
%             abs_head_section(cidx).fly(fidx).step(stepidx).uvel(:) = diff(datABS(steprange))*fps;
%             stim_section(cidx).fly(fidx).step(stepidx).uvel(:) = diff(datALIN(steprange))*fps;
% 
%             % store head & body sections, up & down chirp
%             abs_head_section(cidx).fly(fidx).step(stepidx).dangle(:) = datABS(steprange);
%             stim_section(cidx).fly(fidx).step(stepidx).dangle(:) = datALIN(steprange);
%             abs_head_section(cidx).fly(fidx).step(stepidx).dvel(:) = diff(datABS(steprange))*fps;
%             stim_section(cidx).fly(fidx).step(stepidx).dvel(:) = diff(datALIN(steprange))*fps;
        







































