%% WN_sub
clear all
load 'WN_DATA.mat'
load ref_stim
% C1 = '_WN_no-ocelli-'; 
% C2 = '_WN_dark-'; 
% C3 = '_WN_without-halteres_';
% C4 = '_WN_without-halteres_dark_';
% Scrap C4 because it's 2 trials for 1 fly
run startup

% organise mean responses
flies = [1:9]; % fly numbers are 0:8 in saved data, added +1 prior to save


clear condmean allmean 
% mean condition for each fly
for cidx = 1:4
    for fidx = 1:length(flies) 
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            condmean(cidx).fly(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial,2);
            condmeanstim(cidx).fly(fidx,:) = nanmean(stims.fly(fidx).cond(cidx).trial,2);
        end
    end
    
    allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);
    
end

clear condallfly condallflyrel
% aggregate all trials for all flies, by condition
for cidx = 1:4
    
    allidx = 0;
    for fidx = 1:length(flies)
        
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            for tidx = 1: tn
                allidx = allidx + 1;
                condallfly(cidx).all(allidx,:) = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                condallflystim(cidx).all(allidx,:) = stims.fly(fidx).cond(cidx).trial(:,tidx);
                condallflyrel(cidx).all(allidx,:) = ref_stim' - headroll.fly(fidx).cond(cidx).trial(:,tidx);
            end
        end
        
        
    end
    condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(flies) - 1);
    condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(flies) - 1);
    condsemrel(cidx,:) = nanstd(condallflyrel(cidx).all)/sqrt(length(flies) - 1);
end




%% plot mean traces for each condition (n=8)
t=[1/500:1/500:50];

t=[1/500:1/500:50];

errbar = 1;
figure(81)
% stimulus
for cidx = 1:4
    eval(['ax\',num2str(cidx),' = subplot(4,1,cidx)']);
    plot(t, nanmean(condmeanstim(1).fly))
    hold on
    if errbar == 1
        %error bars on:
        shadedErrorBar(t, ( nanmean(condmean(cidx).fly) ) , condsemstim(cidx,:) );
    else
        plot(t, ( nanmean(condmean(cidx).fly) ) ) %original
        
% plot(t,( nanmean(condmeanstim(cidx).fly) ) )
% plot(downsample(t,65), downsample(nanmean(condmeanstim(cidx).fly),65),'r.','MarkerSize',15)

    end    
    title(['C',num2str(cidx)])
    ylim([-20 20])
    
end
linkaxes([ax1,ax2,ax3,ax4],'xy')

%%
Tplot_WN_traces
%%
Tplot_WN_stim
%% plot mean stim traces for each condition
% To check that the change in variance observed in dark conditions isn't
% due to video analysis

t=[1/500:1/500:50];

errbar = 0;
figure(82)
% stimulus
for cidx = 1:4
    eval(['ax',num2str(cidx),' = subplot(4,1,cidx)']);
    
    hold on
    if errbar == 1
        %error bars on:
        shadedErrorBar(t, ( nanmean(condmeanstim(cidx).fly) ) , condsemstim(cidx,:) );
    else
        plot(t, ( nanmean(condmeanstim(cidx).fly) ) ) %original
        
% plot(t,( nanmean(condmeanstim(cidx).fly) ) )
% plot(downsample(t,65), downsample(nanmean(condmeanstim(cidx).fly),65),'r.','MarkerSize',15)

    end
    x(cidx,:) =  nanmean(condmeanstim(cidx).fly)  ;
    x(cidx,:) = x(cidx,:) - x(cidx,1);
    
    title(['C',num2str(cidx)])
    ylim([-20 20])
    
end
linkaxes([ax1,ax2,ax3,ax4],'xy')

%}


%{
% head position
figure(81)
for cidx = 1:4
    eval(['ax',num2str(cidx),' = subplot(4,1,cidx)']);
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly) )
    end
    
    ylim([-20 20])
    title(['C',num2str(cidx)])
    
end
linkaxes([ax1,ax2,ax3,ax4],'xy')
%}

% relative response
for cidx = 1:4
    eval(['ax',num2str(cidx),' = subplot(4,1,cidx)']);
    
    hold on
    if errbar == 1
        %error bars on:
        shadedErrorBar(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) , condsem(cidx,:) );
    else
        plot(t, ( nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly) ) )
    end
    
    
    title(['C',num2str(cidx)])
    ylim([-20 20])
    
end
linkaxes([ax1,ax2,ax3,ax4],'xy')

%}



%% plot each freq vs gain, from spectrogram, using mean resp

%input vars:
win_size = 500; %samples
overlap_size = 438;
spect_freq_range = [0.1 : 0.1 : 30];
sampling_rate = 500;
freq_loc_on_graph = 'yaxis';

for fidx = 1:length(flies)
    for cidx = 1:5
        % relative resp = stim - resp
        dat(:,1) = (condmeanstim(cidx).fly(fidx,:) -  condmean(cidx).fly(fidx,:));
        % stim = stim - mean(stim)
        dat(:,2) = condmeanstim(cidx).fly(fidx,:) - nanmean(condmeanstim(cidx).fly(fidx,:));
        
        % get spectrogram data for FIRST HALF (up) resp
        [suR,fuR,tuR,puR] = spectrogram(dat(1:4400,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [suS,fuS,tuS,puS] = spectrogram(dat(1:4400,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        % get spectrogram data for SECOND HALF (down) resp
        [sdR,fdR,tdR,pdR] = spectrogram(dat(3601: 8000,1), win_size, overlap_size, spect_freq_range, sampling_rate);
        % get spectrogram data for stim
        [sdS,fdS,tdS,pdS] = spectrogram(dat(3601:8000,2), win_size, overlap_size, spect_freq_range, sampling_rate);
        
        
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
%         subplot(8,5,(fidx-1)*5 + cidx)
%         plot(flocsu,gainsu,'Linewidth',2)
%         hold on
%         plot(flocsd,gainsd,'Linewidth',2)
%         if fidx == 1,title(['C',num2str(cidx)]),end
%         ylim([0 1])
%         hold off
        
        % store freqs and gains
        gains_down(cidx,fidx,:) = gainsd;
        freqs_down(cidx,fidx,:) = flocsd;
        gains_up(cidx,fidx,:) = gainsu;
        freqs_up(cidx,fidx,:) = flocsu;
        
        
        %%% Calculate lag by cross-correlation in the same windows
        %%% as used for FFTs
        xwin_size = 500;
        xoverlap = 438;
        underlap = (xwin_size - xoverlap);
        
        clear datALOUT datALIN cor_u lu cor_d ld lag_u lag_d corr_u corr_d
        datALOUT = dat(:,1);
        datALIN = dat(:,2);
        
        for stepidx = 1: 1 + (floor(length(datALIN)/2)+floor(0.5*xwin_size) - xwin_size)/underlap
            
            steprange = [1 + (stepidx-1)*underlap : xwin_size + (stepidx-1)*underlap];
            [cor_u, lu] = xcorr(datALIN(steprange) , datALOUT(steprange)  );
            [~,ph] = max(cor_u( 1: ceil(length(lu)/2) ) );
            lag_u(stepidx) = lu(ph);
            corr_u(stepidx,:) = cor_u;
            
            steprange_d = [3601 + (stepidx-1)*underlap : 3600 + xwin_size + (stepidx-1)*underlap];
            [cor_d, ld] = xcorr(datALIN(steprange_d) , datALOUT(steprange_d));
            [~,ph] = max(cor_d( 1: ceil(length(ld)/2) ) );
            lag_d(stepidx) = ld(ph);
            corr_d(stepidx,:) = cor_d;
            
        end
        
        % store freqs and gains
        lags_down(cidx,fidx,:) = lag_d;
        lags_up(cidx,fidx,:) = lag_u;
        
    end
    
    
end

%% SPA - in rad/s 
clear mag_up mag_down ph_up ph_down w_up w_down


%input vars:
fdr_win = [];
spa_frange = deg2rad([0.01:0.05:30]);
fdr_frange = {deg2rad(1),deg2rad(30)};
t_interval = 1;
spa_win = 100; % samples


    for cidx = 1:4
        % relative resp = stim - resp
        spadat(:,1) = (nanmean(condmeanstim(cidx).fly)) -  nanmean(condmean(cidx).fly(fidx,:));
        % stim = stim - mean(stim)
        spadat(:,2) = nanmean(condmeanstim(cidx).fly(fidx,:));
        
        % output          % input
        zwn = iddata( spadat(:,1) , spadat(:,2), t_interval);
        zd = iddata( spadat(4001:8000,1) , spadat(4001:8000,2), t_interval);
        
        % spa and spafdr functions
        zsu = spa(zwn,spa_win,spa_frange);
        zsd = spa(zd,spa_win,spa_frange);
        zfdru = spafdr(zwn,fdr_win,fdr_frange);
        zfdrd = spafdr(zd,fdr_win,fdr_frange);
        
        [magu,phu,wu,sdmagu,sdphaseu] = bode(zsu);
        [magd,phd,wd,sdmagd,sdphased] = bode(zsd);
        [magfdru,phfdru,wfdru,sdmagfdru,sdphasefdru] = bode(zfdru);
        [magfdrd,phfdrd,wfdrd,sdmagfdrd,sdphasefdrd] = bode(zfdrd);
                
        % store freqs (in Hz) and gains
        mag_down(cidx,:) = squeeze(magd);
        w_down(cidx,:) = rad2deg(wd);
        ph_down(cidx,:) = phd;
        mag_up(cidx,:) = squeeze(magu);
        w_up(cidx,:) = rad2deg(wu);
        ph_up(cidx,:) = phu;
        
end

%%
bode(zsu)
%%


% plot SPA mean gains by condition
figure(97)
subplot(1,2,1)
mean_fu = squeeze(mean(w_up));
mean_gu = squeeze(mean(mag_up));
err_gu = squeeze(std(mag_up,[])/sqrt(8));
% plot(mean_fu',mean_gu')
errorbar(mean_fu',mean_gu',err_gu')
% axis([0 20 0 0.8])
xlabel('freq, Hz')
ylabel('gain')
title('noisy')
legend({'c1','c2','c3','c4'},'Location','northeast')

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

%% Find velocities
% First, get reversal points from stim. Work with C1, but it would be the
% same for any other condition


s = nanmean(condmeanstim(1).fly);
x = diff(s);

% Lowpass filter
dt_s = 1/500; 
t = [dt_s:dt_s:50-dt_s];
tx = [dt_s:dt_s:50];
f0_hz = 1/dt_s;
fcut_hz = 95;
[b,a] = butterlow1(fcut_hz/f0_hz);
xx = filtfilt(b,a,x);
  
h=hilbert(xx);
[~,locs] = findpeaks(abs(imag(h)),'MinPeakdistance',58);
% check peaks fall within correct distance of one another 
% mean inter-peak distance should be 63 samples
% figure, plot(tx,s), hold on, plot(diff(locs)) 
% %peaks of Hilbert transfrom
% plot(tx(locs),s(locs),'r.','Markersize',15)

% Plot the gain across different velocities
% Gain = delta relative_resp_angle/delta stim_angle 
%         (during each section: identified from peaks, found with hilbert transform 
figure 
for cidx = 1:3
yyz=allmeanrel(cidx,:);
% plot(tx,yyz), hold on
%inflection points:
% plot(tx(locs),yyz(locs),'r.','Markersize',15)
%velocities:
velr = abs(diff(yyz(locs)));
vels = abs(diff(s(locs)));
velg = velr./vels;
velgains = velg(velg<1); % disregard erroneous gains 
% plot(velr),hold on,plot(velr)
freqs_at_timepts = vels ./ diff(tx(locs)) ; % in deg/s
velfreqs = freqs_at_timepts(velg<1);
sf = scatter(velfreqs,velgains,'.');
sf.MarkerFaceColor = color_mat{cidx+1};
sf.MarkerEdgeColor = color_mat{cidx+1};
hold on
scatter_color = get(sf, 'CData');
p = polyfit(velfreqs, velgains,1);
velfit = polyval(p,velfreqs);
fline(cidx) = plot(velfreqs,velfit,'Linewidth',1.5);
set(fline(cidx),'Color',color_mat{cidx+1})
xlim([0 540])
xlabel('Angular velocity [{\circ}/s]')
ylabel('Gain, HR/TR')
% [vhr,redges] = histcounts(velr,20);
% [vhs,sedges] = histcounts(vels,20);
% plot(sedges(2:end),vhs,'k'),hold on
% plot(redges(2:end),vhr)

end
legend([fline(1),fline(2),fline(3)],'C2','C3','C4')
legend('boxoff')
set(gcf,'Position', [103 141 300 240]);
        
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\wn_vel_scatter','-openGL','-r660')
%%
%% Find gain for individual sections 
% First, get reversal points from stim. Work with C1, but it would be the
% same for any other condition

s = nanmean(condmeanstim(1).fly);
x = diff(s);

% Lowpass filter
dt_s = 1/500; 
t = [dt_s:dt_s:50-dt_s];
tx = [dt_s:dt_s:50];
f0_hz = 1/dt_s;
fcut_hz = 95;
[b,a] = butterlow1(fcut_hz/f0_hz);
xx = filtfilt(b,a,x);
  
h=hilbert(xx);
[~,locs] = findpeaks(abs(imag(h)),'MinPeakdistance',58);
% check peaks fall within correct distance of one another 
% mean inter-peak distance should be 63 samples
% figure, plot(tx,s), hold on, plot(diff(locs)) 
% %peaks of Hilbert transfrom
% plot(tx(locs),s(locs),'r.','Markersize',15)

% Plot the gain across different velocities
% Gain = delta relative_resp_angle/delta stim_angle 
%         (during each section: identified from peaks, found with hilbert transform 
figure 

%Stimulus SEM
sems = condallflystim(cidx).all;

for cidx = 1:3
yyz=allmean(cidx,:);
semy = condallfly(cidx).all;

% plot(tx,yyz), hold on
%inflection points:
% plot(tx(locs),yyz(locs),'r.','Markersize',15)
%velocities:
velr = abs(diff(yyz(locs)));
vels = abs(diff(s(locs)));
velg = velr.*vels;
velgains = velg(velg<1); % disregard erroneous gains 
% % plot(velr),hold on,plot(velr)
freqs_at_timepts = vels ./ diff(tx(locs)) ; % in deg/s
velfreqs = freqs_at_timepts(velg<1);
velr = velr./diff(tx(locs));
vels = vels./diff(tx(locs));
num_bins = 0.05* floor(length(allmeanrel(cidx,:))/mean(diff(locs)));
[vhr,redges] = histcounts(velr,num_bins,'Normalization','pdf');
[vhs,sedges] = histcounts(vels,num_bins,'Normalization','pdf');

% Work out error bars
for f =  1: size(semy,1)
    velr = abs(diff(semy(f,locs)));
    velg = velr.*vels;
    velgains = velg(velg<1); % disregard erroneous gains
    if isempty(velgains);
        allvels(f,:) = NaN(1,num_bins);
        continue 
    end
    % % plot(velr),hold on,plot(velr)
    freqs_at_timepts = vels ./ diff(tx(locs)) ; % in deg/s
    velfreqs = freqs_at_timepts(velg<1);
    velr = velr./diff(tx(locs));
    allvels(f,:) = histcounts(velr,num_bins,'Normalization','pdf');
end
velsemr = nanstd(allvels,[],1)/sqrt(8);
% error bars for stim
for f =  1: size(sems,1)
    velr = abs(diff(semy(f,locs)));
    velg = velr.*vels;
    velgains = velg(velg<1); % disregard erroneous gains
    if isempty(velgains);
        allvels(f,:) = NaN(1,num_bins);
        continue 
    end
    % % plot(velr),hold on,plot(velr)
    freqs_at_timepts = vels ./ diff(tx(locs)) ; % in deg/s
    velfreqs = freqs_at_timepts(velg<1);
    velr = velr./diff(tx(locs));
    semvels(f,:) = histcounts(velr,num_bins,'Normalization','pdf');
end
velsems = nanstd(allvels,[],1)/sqrt(8);

if cidx ==1
    lineprops.col = {color_mat{6}};
    lineprops.width = 1.5;
sline = mseb(sedges(1:end-1),smooth(vhs,3),velsems,lineprops,1);
end
hold on
lineprops.col = {color_mat{cidx+1}};
lineprops.width = 1.5;
hline.cond(cidx) = mseb(redges(1:end-1),smooth(vhr,3),velsemr,lineprops,1);

% sf = scatter(velfreqs,velgains,'.');
% sf.MarkerFaceColor = color_mat{cidx+1};
% sf.MarkerEdgeColor = color_mat{cidx+1};
% hold on
% scatter_color = get(sf, 'CData');
% p = polyfit(velfreqs, velgains,1);
% velfit = polyval(p,velfreqs);
% fline(cidx) = plot(velfreqs,velfit,'LineWidth',1.5,'LineStyle','- -');
% set(fline(cidx),'Color',color_mat{cidx+1})
xlim([0 540])
ylim([0 11e-3])
xlabel('Retinal slipspeed [{\circ}/s]')
ylabel('Probability density function [s/{\circ}]')
end
set(gca,'box','off')
legend([sline.mainLine,hline.cond(1).mainLine,hline.cond(2).mainLine,hline.cond(3).mainLine],'TR','C2','C3','C4')
legend('boxoff')
set(gcf,'Position', [103 141 300 240]);
        
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\wn_slipspeed','-openGL','-r660')

%%
%plot fft of stimulus
Samp_time = 1/500;
Samp_freq = 500;
L = length(ref_stim);
time=(0:L-1)*Samp_time;
NFFT = 2^nextpow2(L);
figure(110)
set(gcf,'Position', [103 141 600 440]);
for cidx = 3:-1:0
    if cidx == 0
        subplot(3,3,[6,9])
        cidx = 3; 
        cid_extra = 1;
    else
        subplot(3,3,cidx);
cid_extra = 0;
    end
Resp_fft = fft(allmeanrel(cidx,:)',NFFT)/L;
Stim_fft = fft(allmeanstim(cidx,:),NFFT)/L;


f = Samp_freq/2*linspace(0,1,NFFT/2+1);
r = 2*abs(Resp_fft(1:NFFT/2+1));
s = 2*abs(Stim_fft(1:NFFT/2+1));

zs=plot(f,s/max(s),'color',color_mat{6});
hold on
zr=plot(f,r/max(s),'color',color_mat{cidx+1});
% title('Frequency spectrum')
xlabel('[Hz]')
ylabel('Power')
axis([0 6.5 0 1])
set(gca,'ytick',[0 1])

if cid_extra == 1,   
    axis([1.13 1.19 0 0.3 ]), 
    set(gca,'ytick',[0,0.1,0.2,0.3,0.4]),
%     offsetAxes(gca,0.1,0.6)

    set(zs,'LineWidth',1.5)
    set(zr,'LineWidth',1.5)
    
end
set(gca,'box','off')
set(gca,'Layer','top')

hold off
% legend({['C',num2str(cidx),'']})

rr = (r)./(s)';
rf = (Resp_fft(1:NFFT/2+1))./(Stim_fft(1:NFFT/2+1))';
rfa = 2*abs(rf);
% figure(111)
subplot(3,3,[4,5,7,8])
% axpos=get(gca,'Position');
% axpos(3) = 0.8*axpos(3);
% set(gca,'Position',axpos);
hold on
if cid_extra ~= 1,
    
    fline(cidx) = plot(f,rr,'Color',color_mat{cidx+1});
end
end
d1 = scatter(1,9,'MarkerFaceColor',color_mat{2},'MarkerEdgeColor',color_mat{2});
d2= scatter(1,9,'MarkerFaceColor',color_mat{3},'MarkerEdgeColor',color_mat{3});
d3= scatter(1,9,'MarkerFaceColor',color_mat{4},'MarkerEdgeColor',color_mat{4});
d4= scatter(1,9,'MarkerFaceColor',color_mat{6},'MarkerEdgeColor',color_mat{6});
set(gca,'Layer','top')
xlabel('Frequency [Hz]')
ylabel('Gain, HR/TR')
axis([0 6 0 1.2])
l = legend([d1,d2,d3,d4],{'C2','C3','C4','TR'},'Location','northeastoutside');%,'Position',[0.7 0.5 0.1 0.1],'units','normalized')
l.LineWidth = 2;
legend('boxoff')

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\wn_FFT','-openGL','-r660')

% now, go through mean resps and
% diff, then filter, then get mean velocity
% between each pair of locs


% same for stimulus..


% xcorr for lags?
%
% analyse power at different freqs
% look at gradient in each window
% plot vel. distribution,
% head pos. distribution
%


