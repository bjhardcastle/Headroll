C1_gain = h1{1}.mainLine.YData;
C2_gain = h1{3}.mainLine.YData;

C1_phase = h2{1}.mainLine.YData;
C2_phase = h2{3}.mainLine.YData;

hoverfly_freqs = h1{1}.mainLine.XData;

figure
subplot(2,1,1)
plot(hoverfly_freqs, C1_gain)
hold on
plot(hoverfly_freqs, C2_gain)

subplot(2,1,2)

plot(hoverfly_freqs, C1_phase)
hold on
plot(hoverfly_freqs, C2_phase)

save('forFran.mat','C1_gain','C2_gain','C1_phase','C2_phase','hoverfly_freqs')