% analyse results in Fourier domain

clear

close all



results_all_gain=zeros(2,4,3);
results_all_phase=zeros(2,4,3);


for k=1:2

condition = [ 1 2 ];

for i=1:4

frequency = [ 1 3 6 10];

for j=1:3

amplitude =[ 10 20 30 ];


%load 1Hz_10deg_C001H001S0001stim.mat

filename = [ int2str(frequency(i)) 'Hz_' int2str(amplitude(j)) 'deg_C001H001S0001stim.mat' ];

eval(['load ' filename]);

stimulus=abs(fft(data(1:4846,3)));
stimulus_phase=angle(fft(data(1:4846,3)));

clear data
clear filename

filename = [ 'fly2_C' int2str(condition(k)) '_' int2str(frequency(i)) 'Hz_' int2str(amplitude(j)) 'deg_C001H001S0001resp.mat' ];

eval(['load ' filename]);

%load fly5_C1_1Hz_10deg_C001H001S0001resp.mat

results=abs(fft(data(1:4846,3)));
results_phase=angle(fft(data(1:4846,3)));

clear data
clear filename


[a b] = max(stimulus);

gain=results(b)/stimulus(b);

phase=results_phase(b)-stimulus_phase(b)*180/pi;

results_all_gain(k,i,j)=gain;
results_all_phase(k,i,j)=phase;


end

end

end


figure(1)

semilogx(frequency, results_all_gain(1,1:4,1),'*b');

set(gca,'XTick', [ 1 3 6 10])
set(gca,'XTickLabel',{'1' '3' '6' '10'})
axis([0.9 11 0 1])
title('condition 1');
xlabel('frequency')
ylabel('amplitude')


hold on
plot(frequency, results_all_gain(1,1:4,2),'*r');
plot(frequency, results_all_gain(1,1:4,3),'*g');

legend('10 deg','20 deg','30 deg');
%set(h,'Interpreter','none')

figure(2)

semilogx(frequency, results_all_gain(2,1:4,1),'*b');

set(gca,'XTick', [ 1 3 6 10])
set(gca,'XTickLabel',{'1' '3' '6' '10'})
axis([0.9 11 0 1])
title('condition 2');
xlabel('frequency')
ylabel('amplitude')


hold on
plot(frequency, results_all_gain(2,1:4,2),'*r');
plot(frequency, results_all_gain(2,1:4,3),'*g');

legend('10 deg','20 deg','30 deg');
%set(h,'Interpreter','none')



