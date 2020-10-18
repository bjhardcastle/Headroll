freq =[0.06 0.1 0.3 0.6 1 3 6 10 15]
num_freqs = 9;
amplitude_experimental = 30;

for fi = 4:num_freqs
    f = freq(fi)
    gain_halteres=1
    sim('noise.slx')
    mean_s(fi) = mean(abs(simout.signal2.Data))*amplitude_experimental
    mean_1(fi) = mean(abs(simout.signal1.Data))*amplitude_experimental

    gain_halteres=0
    sim('noise.slx')
    mean_2(fi) = mean(abs(simout.signal1.Data))*amplitude_experimental
end


plot(freq(4:num_freqs), mean_s(4:num_freqs), 'k')
hold on;
plot(freq(4:num_freqs), mean_1(4:num_freqs), 'g')
plot(freq(4:num_freqs), mean_2(4:num_freqs), 'b')