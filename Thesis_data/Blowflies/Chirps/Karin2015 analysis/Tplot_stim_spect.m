% Make reference stims from theoretical signal, for alignment of camera
% recorded stimulus
% 15-25Hz stim - duration 10s - 1200 fps - sampfreq 100k

Freq = 51;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Trial_duration = 10;
Samp_freq = 1000; % Framerate, FPS
Phase = 0;
Amp = 30;
Steps_per_revolution = 3200;

Nsamples = Trial_duration * Samp_freq;
Stim_sin = sin(Phase + 2*pi*(1:Nsamples)* Freq/Samp_freq);
if Freq == 21 || Freq == 31 || Freq == 41 || Freq == 51
    % chirp signal: linear increase of frequency, 0 - 21Hz
        chirp_flag = 1;
    if Freq == 21,
        chirp_freq = 25;
    elseif Freq == 31,
        chirp_freq = 15;
    elseif Freq == 41,
        chirp_freq = 10;
    elseif Freq == 51,
        chirp_freq = 40;
    end
    halftime = Nsamples/2;
    k = 0.5*(chirp_freq - 0)/Samp_freq/halftime;
    Stim_sin = zeros(halftime,1);
    Stim_sin = sin( Phase + 2*pi* (0*(1:halftime) + 0.5*k*(1:halftime).^2 ) );
    Stim_sin = [Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')) -fliplr(Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')))];
    Stim_sin(end:Nsamples) = 0;
        
elseif Freq >= 15 % ramping the sine wave in the first 2 seconds for 15 Hz stimulation
    ramp = 1./(1 + exp(-linspace(-5,5,Samp_freq*2))); 
    rampSine = Stim_sin(1:2*Samp_freq); 
    rampSine = rampSine.*ramp;
    Stim_sin(1:2*Samp_freq) = rampSine;% - mean(rampSine);
    Stim_sin(8*Samp_freq+1:end) = -rampSine(end:-1:1);% + mean(rampSine);
end

close all

load ref_stim.mat
xr = ref_stim(1:8000); 
x = Amp*Stim_sin;
sampling_rate = 800;

spectfig =  figure('Position', [103 141 600 470]);
sf1 = subplot('Position',[0.1 0.7 0.7 0.2]);
t=[1/sampling_rate:10/length(xr):10];
linecols = colormap;
chirpline =  plot(t,xr,'LineWidth',1.5)

box off
% xlabel('Time [s]','Fontsize',12)
set(gca,'xtick',[0,5,10])
set(gca,'TickDir','out')
ylabel('Amplitude [\circ]', 'Fontsize',10)
set(sf1,'ytick',[-30,0,30])
offsetAxes(gca,0.02,0.07);% yaxis offset, xaxis offset

%input vars:
win_size = 800; %samples
overlap_size = 700;
spect_freq_range = [0 : 0.4 : 22];
freq_loc_on_graph = 'yaxis';

hold on

sf2 = subplot('Position', [0.115, 0.35, 0.796,0.29]);
spectrogram(x, win_size, overlap_size, spect_freq_range, sampling_rate, 'MinThreshold',-22,freq_loc_on_graph)
a = spectrogram(x, win_size, overlap_size, spect_freq_range, sampling_rate, 'MinThreshold',-22,freq_loc_on_graph)

colormap bone %hot %gray %pink %bone %copper %gray hot
box on


cmap = colormap;
colormap(cmap(30:end,:));
cb = colorbar;
ax = gca;
axpos = ax.Position;
cpos = cb.Position;
cpos(3) = 0.5*cpos(3);
cb.Position = cpos;

% ax.FontSize = 10;
cb.Label.String = ('Power/Frequency [dB/Hz]');
cb.Box ='off';
cb.TickDirection = 'out';
cb.Ticks = [-20,-10,0,10,20];
cb.LineWidth = 1;
cb.FontSize = 10;
xlabel('Time [s]','FontSize',10)
set(gca,'xtick',[0.525,4.94,9.375])
set(gca,'xticklabel',{'0','5','10'});
set(gca,'TickDir','out')
h = ylabel('Frequency [Hz]','FontSize',10)
set(h, 'Units', 'Normalized');
pos = get(h, 'Position');
offset=0.031;
set(h, 'Position', pos + [-offset, 0, 0]);

set(sf2,'ytick',[0,5,10,15,20,25])
ax.Position = axpos;
set(gca,'linewidth',1)
set(sf2,'Layer','top');
grid off 

chirpline.Color = cmap(30,:);

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chripstim','-painters','-r660')