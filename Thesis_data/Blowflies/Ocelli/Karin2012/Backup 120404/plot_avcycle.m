subplot(2,2,freq_nr)
title(strcat('f=',num2str(freqs(1,freq_nr)),'Hz'))
hold on
plot(time,resp_traces,'b')
plot(time,stim_traces,'g')
axis([   min(time), max(time), -45 , 45    ])

plot(time,mean(resp_traces),'c')
plot(time,mean(stim_traces),'r')
hold off