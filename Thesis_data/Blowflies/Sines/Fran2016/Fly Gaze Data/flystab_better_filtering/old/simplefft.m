function [ Y,freqs ] = simplefft( signal,Fs )
%SIMPLEFFT Calculates DFT of signal with sampling rate Fs
%   PRE: signal is a real vector and Fs is a real positive sampling rate
%   POST: Y is the FFT of signal at frequencies freqs
L=length(signal);
NFFT = 2^nextpow2(L);
Y = fft(signal,NFFT)/L;
freqs = Fs/2*linspace(0,1,NFFT/2+1);
%plot(freqs,2*abs(Y(1:NFFT/2+1)));

end