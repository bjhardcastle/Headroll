
Trial_duration = 50;
Samp_freq =  60000;
Steps_per_revolution = 5000;

Nsamples = Trial_duration * Samp_freq;
Time = (0:1/Samp_freq:(Nsamples-1)/Samp_freq);

Noise_amp = 10;             %amplitude multiplier for noisy signal  (10 is ok with 15)
Tscale = 15;                %temporal stretching factor for noisy signal (up to 15 is ok)
Noise = zeros(Trial_duration * Tscale, 1);   
Noise = randn(1, length(Noise)+1); 
Noise(1) = 0;               %motor must start and stop at 0 position
Noise(length(Noise)) = 0;

Stim_noise = zeros(Nsamples,1);
Stim_noise = interp1(Noise, 1 : (Tscale/Samp_freq) : length(Noise) - (1/Samp_freq));

Stim_noise = Stim_noise * Noise_amp * Steps_per_revolution / 360;
Stim_noise_smooth = smooth(Stim_noise, 150);          %smooth 

Vel_dist = gradient(Stim_noise_smooth/5000*360,1/Samp_freq);
figure, 
subplot(1,2,2)
hist(Vel_dist,100)
Sig = std(Vel_dist);
set(gca,'box','off')
text(0.8,0.7,(['\sigma = ',num2str(Sig),'{\circ}/s']),'units','normalized');

subplot(1,2,1)
hist(Stim_noise_smooth,100)
Sig = std(Vel_dist);
set(gca,'box','off')
text(0.8,0.7,(['\sigma = ',num2str(Sig),'{\circ}']),'units','normalized');

% xlim([0 4500])
% ylim([0 16e-4])
% legend([sline.mainLine,hline.cond(1).mainLine,hline.cond(2).mainLine,hline.cond(3).mainLine,hline.cond(4).mainLine,hline.cond(5).mainLine],'TR','C1','C2','C3','C4','C5')
% legend('boxoff')
set(gcf,'Position', [103 141 300 440]);
set(gca,'Layer','top')
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chirp_slipspeed','-openGL','-r660')

