%plot average trace of all flies for C1 vs C2
close(figure(999))


for freq=1:4
    a=[];b=[];,s=[];

for n=1:7
a(n,:)=resp_traces_mean{n,freq,1,1}; %{fly_nr,freq_nr,amp_nr,cd_nr}
b(n,:)=resp_traces_mean{n,freq,1,2};
s(n,:)=stim_traces_mean{n,freq,1,1}
end

figure(999)
subplot(2,2,freq)
title(strcat('f=',num2str(round(freqs(1,freq))),'Hz'))
hold on
plot(time_save{1,1,freq},mean(a)-mean(mean(a)))
plot(time_save{1,1,freq},mean(b)-mean(mean(b)),'r')
plot(time_save{1,1,freq},mean(s),'g')
axis([   min(time_save{1,1,freq}), max(time_save{1,1,freq}), -40 , 40    ])

hold off
end