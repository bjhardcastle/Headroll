% Make reference stims from theoretical signal, for alignment of camera
% recorded stimulus
% 15-25Hz stim - duration 10s - 1200 fps - sampfreq 100k

Freq = 25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Trial_duration = 10;
Samp_freq = 1200; % Framerate, FPS
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

x = Amp*Stim_sin;
save('.\bf\25_1200_250','x')
plot(x)
