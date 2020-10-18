subplot(2,2,freq_nr)
title(strcat('f=',num2str(freqs(1,freq_nr)),'Hz'))

hold on
for cycle=1:size(resp_traces,1)
plot(time,resp_traces(cycle,:),'b')
plot(time,stim_traces(cycle,:),'g')
end
axis([   min(time), max(time), -45 , 45    ])

plot(time,mean(resp_traces),'c')
plot(time,mean(stim_traces),'r')
hold off