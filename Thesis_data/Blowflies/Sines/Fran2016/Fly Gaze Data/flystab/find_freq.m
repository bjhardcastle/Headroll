[stim_fft, fscale] = simplefft(stim,Fs);
stim_fft(1) = 0;
[max_f sf] = max(abs(stim_fft));
stimfreq_f = fscale(sf);

[resp_fft, fscale] = simplefft(resp,Fs);
resp_fft(1) = 0;
[max_f sf] = max(abs(resp_fft));
respfreq_f = fscale(sf);

