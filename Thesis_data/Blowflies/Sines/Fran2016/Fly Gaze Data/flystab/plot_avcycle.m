subplot(3,3,p)
title(strcat('f=',num2str(name_array(1,p)),'Hz'))
hold on
plot(time,resp_traces,'b')
plot(time,stim_traces,'g')

plot(time,mean(resp_traces),'c')
plot(time,mean(stim_traces),'r')
hold off