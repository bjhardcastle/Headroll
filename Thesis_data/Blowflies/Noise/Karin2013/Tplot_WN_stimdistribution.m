
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

%%% PLOT


figure, set(gcf,'Position', [103 141 520 180]);
 
subplot(1,2,2)
h=histogram(Vel_dist,50,'Normalization','pdf');
h.FaceColor = [0.4,0.4,0.4];
h.EdgeColor = [0.4,0.4,0.4];
Sig = std(Vel_dist);
set(gca,'box','off')
text(0.65,0.8,(['\sigma = ',num2str(Sig),'{\circ}/s']),'units','normalized');
xlim([-800 800])
set(gca,'xtick', [-600, 0, 600] )
yl = get(gca,'ylim');
xlabel('Angular velocity [{\circ}/s]')
set(gca,'ytick', [])
ylabel('P.D.F.')
set(gca,'Layer','top','LineWidth',1)

subplot(1,2,1)
h = histogram(Stim_noise_smooth/(Steps_per_revolution / 360),50,'Normalization','pdf');
h.FaceColor = [0.4,0.4,0.4];
h.EdgeColor = [0.4,0.4,0.4];
Sig = std(Stim_noise_smooth/(Steps_per_revolution / 360));
set(gca,'box','off')
text(0.65,0.8,(['\sigma = ',num2str(Sig),'{\circ}']),'units','normalized');
xlim([-35 35])
set(gca,'xtick', [-30, 0, 30] )
set(gca,'ytick', [] )
xlabel('Roll angle [\circ]')
ylabel('P.D.F.')
% ylim([0 16e-4])
% legend([sline.mainLine,hline.cond(1).mainLine,hline.cond(2).mainLine,hline.cond(3).mainLine,hline.cond(4).mainLine,hline.cond(5).mainLine],'TR','C1','C2','C3','C4','C5')
% legend('boxoff')
set(gca,'Layer','top','LineWidth',1)

        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\WN_dist','-openGL','-r660','-nocrop')

