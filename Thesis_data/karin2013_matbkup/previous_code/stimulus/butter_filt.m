T=60; % Duration
fs = 2100; % Sample Rate
N = 20 % Order of Butterworth Filter
fc = 500; % Cutoff Frequency
time = (0:1/fs:T); % Time Vector
sig = randn(size(time));
% Filter sig
[b,a] = butter(N,fc*2./fs);
sig2 = filter(b,a,sig);
SIG = fft(sig);
SIG2 = fft(sig2);
% Plot Results
freq = fs*(0:length(time)-1)./(length(time)-1);
subplot(2,1,1)
plot(freq,abs(SIG),freq,abs(SIG2))
subplot(2,1,2)
plot(freq,unwrap(angle(SIG)),freq,unwrap(angle(SIG2)))