% Find correlation coefficients
%
% resp{ fly + 1, condition, trial }
% stim{ fly + 1, condition, trial }
clc, clear all
%% Flies 0 and 1

load processed_stim_resp.mat;

clear hb*
clear mean*

for f = 1:size(resp,1)
    for c = 1:size(resp,2)
        if c == 4
            tmx = 2;
        else
            tmx = 10;
        end
            
        for t = 1:tmx  %t = 1:size(resp,3)
            
%             calc_gain_phase; % phase currently meaningless
            
            XY = [];
            
            XY(:,1) = resp{f,c,t}; 
            XY(:,2) = stim{f,c,t};
                                   
            [cxy, pxy] = corrcoef(XY);
            
            hbcorr_coeff(f,c,t) = cxy(2,1);
            hbcorr_prob(f,c,t) = pxy(2,1);
                     
            
            [hb_coher(t,:), freqs(t,:)] = mscohere(resp{f,c,t},stim{f,c,t},[],[],[],500);
            [bb_coher(t,:), bbfreqs(t,:)] = mscohere(stim{f,c,t},stim{f,c,t},[],[],[],500);
            
            [crosscorr{f,c,t}, lags{f,c,t}] = xcorr(resp{f,c,t},stim{f,c,t},25000/2,'coeff'); 
            lags{f,c,t} = lags{f,c,t}./5;
            
            fft_resp{f,c,t} = fft(resp{f,c,t})/25000;
             
       
            
        end
        mean_coher{f,c} = mean(hb_coher,1); 
        mean_bbcoher{f,c} = mean(bb_coher,1);
      
        if c ==4
            mean_xcorr{f,4} = (crosscorr{f,4,1} + crosscorr{f,4,2})/2;
        else
            mean_xcorr{f,c} = mean(crosscorr{f,c},2);
        end

        mean_fft(:,f,c) = mean(fft_resp{f,c},2);   

        mean_stim(:,f,c) = mean(stim{f,c},2);
    end
    mean_corr(f,1:c) = mean(hbcorr_coeff(f,1:c,:),3);
%     mean_corr(f,4) = mean(hbcorr_coeff(f,4,1:2));
   
end

%% Slow stim fly

load slow_responses.mat;
hold on
    
    for s = 1:length(slowresp)
            XY = [];
            
            XY(:,1) = slowresp{s}; 
            XY(:,2) = slowstim{s};
                                   
            [cxy, pxy] = corrcoef(XY);
            
            mean_corr(4,s) = cxy(2,1);
            
            [mean_coher{4,s}, slowfreqs{4,s}] = mscohere(slowresp{s},slowstim{s},[],[],[],500);
             
    end
    
    
%% plot correlation coefficients
% RELATIVE
close(figure(99))
figure(99), hold on
h_fig = subplot(1,1,1);

plot(mean_corr([1,2,4],1),'bsq','LineWidth',2)
plot(mean_corr([1,2,4],3),'ksq','LineWidth',2)
plot(mean_corr([1,2,4],2),'rsq','LineWidth',2)
plot(mean_corr([1,2,4],4),'msq','LineWidth',2)
hold off
legend('CEs + halteres','CEs','halteres','neither','Location','East')
axis([0 6 0 1])
ylabel('Correlation coefficient','FontSize',14)
set(h_fig,'xtick',1:3,'xticklabel',{'fly 1','fly2','     slow stimulus'},'FontSize',14, 'TickDir', 'out')       

%% plot mean cross correlation for each fly, for each condition
% RELATIVE

close(figure(98))
figure(98), hold on,

% %all conditions
% plot(lags{1,1},mean_xcorr{1,1},'b',lags{1,2},mean_xcorr{1,2},'r',lags{1,3},mean_xcorr{1,3},'k',lags{1,4},mean_xcorr{1,4},'c')
% plot(lags{2,1},mean_xcorr{2,1},'b--',lags{2,2},mean_xcorr{2,2},'r--',lags{2,3},mean_xcorr{2,3},'k--',lags{2,3},mean_xcorr{2,4},'c--')
% 
% %halteres and CEs only
plot(lags{1,2},mean_xcorr{1,2},'b',lags{1,3},mean_xcorr{1,3},'r',lags{1,4},mean_xcorr{1,4},'k','LineWidth',1.5)
plot(lags{2,2},mean_xcorr{2,2},'b--',lags{2,3},mean_xcorr{2,3},'r--',lags{2,3},mean_xcorr{2,4},'k--','LineWidth',1.5)

axis([-20 20 -0.13 0.7])
legend({'halteres','CEs','neither'},'FontSize',14,'Location', 'NorthWest')
xlabel(['lag (ms)'],'FontSize',14)
ylabel(['Normalised cross correlation, Head(relative) - Body'],'FontSize',14)
title('fly1 ---, fly 2 - -','FontSize',14)
 vline(0,'k:')
set(gca,'FontSize',14,'xtick',-20:5:20, 'xticklabel',{'-20','', '-10', '' ,'0', '', '10', '', '20'}, 'ytick', [0 0.2 0.4 0.6], 'TickDir', 'out')
hold off

%% plot FFT

fft_freqs = 500/2*linspace(0,1,25000/2+1);

f = 2;

figure(90+f),
hold on

plot(fft_freqs, smooth(2*abs(mean_fft(1:12501,f,1)),30) ,'b')
plot(fft_freqs, smooth(2*abs(mean_fft(1:12501,f,2)),30) ,'k')
plot(fft_freqs, smooth(2*abs(mean_fft(1:12501,f,3)),30) ,'r')
plot(fft_freqs, smooth(2*abs(mean_fft(1:12501,f,4)),30) ,'c')
fft_stim(:,f) = fft(mean_stim(:,f,1))/25000; %any stimulus will do
plot(fft_freqs, smooth(2*abs(fft_stim(1:12501,1)),30) ,'g')

axis([0 50 0 2])
hold off
%%
colour = {'b','k','r','c','g'};
close( figure(101))
figure(101)
fft_fig = subplot(1,1,1);
hold on
for f = 2,
    
    fft_stim(:,f) = fft(mean_stim(:,f,1))/25000; %any stimulus will do
    tb = 2*abs(fft_stim(1:12501,1));

    for c = 1:4
        ta = 2*abs(mean_fft(1:12501,f,c));
        fft_gain(:,f,c) = ta./tb; 
        plot(fft_freqs,smooth(fft_gain(:,f,c),100),colour{c},'LineWidth',2.5)
    end
    
    
     axis([0 50 0 40])
end
set(fft_fig,'FontSize',14, 'TickDir', 'out','LineWidth',1)       
xlabel('Frequency (Hz)')
ylabel('Ratio of magnitudes')
title(['Relative head roll / Stimulus, fly ' int2str(f)])      
legend({'CE + halteres', 'halteres', 'CE', 'neither'})

hold off

%% plot correlation coefficients
% ABSOLUTE
close(figure(99))
figure(99), hold on
h_fig = subplot(1,1,1);

plot(-(1-mean_corr([1,2,4],1)),'bsq','LineWidth',2)
plot(-(1-mean_corr([1,2,4],3)),'ksq','LineWidth',2)
plot(-(1-mean_corr([1,2,4],2)),'rsq','LineWidth',2)
plot(-(1-mean_corr([1,2,4],4)),'msq','LineWidth',2)
hold off
legend('CEs + halteres','CEs','halteres','neither','Location','East')
axis([0 6 -1 1])
ylabel('Correlation coefficient','FontSize',14)
set(h_fig,'xtick',1:3,'xticklabel',{'fly 1','fly2','     slow stimulus'},'FontSize',14, 'TickDir', 'out')       

%% plot mean cross correlation for each fly, for each condition
% ABSOLUTE
close(figure(98))
figure(98), hold on,

% %all conditions
% plot(lags{1,1},mean_xcorr{1,1},'b',lags{1,2},mean_xcorr{1,2},'r',lags{1,3},mean_xcorr{1,3},'k',lags{1,4},mean_xcorr{1,4},'c')
% plot(lags{2,1},mean_xcorr{2,1},'b--',lags{2,2},mean_xcorr{2,2},'r--',lags{2,3},mean_xcorr{2,3},'k--',lags{2,3},mean_xcorr{2,4},'c--')
% 
% %halteres and CEs only
plot(lags{1,2},-(1-mean_xcorr{1,2}),'b',lags{1,3},-(1-mean_xcorr{1,3}),'r',lags{1,4},-(1-mean_xcorr{1,4}),'k','LineWidth',1.5)
plot(lags{2,2},-(1-mean_xcorr{2,2}),'b--',lags{2,3},-(1-mean_xcorr{2,3}),'r--',lags{2,3},-(1-mean_xcorr{2,4}),'k--','LineWidth',1.5)

axis([-20 20 -1 -0.1])
legend({'halteres','CEs','neither'},'FontSize',14,'Location', 'NorthWest')
xlabel(['lag (ms)'],'FontSize',14)
ylabel(['Normalised cross correlation, Head(relative) - Body'],'FontSize',14)
title('fly1 ---, fly 2 - -','FontSize',14)
 vline(0,'k:')
set(gca,'FontSize',14,'xtick',-20:5:20, 'xticklabel',{'-20','', '-10', '' ,'0', '', '10', '', '20'}, 'ytick', [0 0.2 0.4 0.6], 'TickDir', 'out')
hold off

%%

figure(96), hold on

for f=1:2,
    for c= 1:4,
        if c == 4
            tm = 2;
        else tm = 10;
        end
            for t = 1:tm
      fly_mean_CL_gain(f,c) = mean(CL_gain(f,c,1:tm))
            end
    end
end

plot(fly_mean_CL_gain,'x')
