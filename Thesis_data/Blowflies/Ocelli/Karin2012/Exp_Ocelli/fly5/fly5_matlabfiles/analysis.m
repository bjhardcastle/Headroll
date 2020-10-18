% analyse results in Fourier domain

clear

close all

period=[250 167 84 50];
Fs=[250 500 500 500];

L=4846;

results_all_gain=zeros(2,4,3);
results_all_phase=zeros(2,4,3);
stimulus_phi=zeros(2,4,3);


for k=1:2

condition = [ 1 2 ];

for i=1:4

frequency = [ 1 3 6 10];

for j=1:3

amplitude =[ 10 20 30 ];


%load 1Hz_10deg_C001H001S0001stim.mat

filename = [ int2str(frequency(i)) 'Hz_' int2str(amplitude(j)) 'deg_C001H001S0001stim.mat' ];

eval(['load ' filename]);


Y = fft(data(:,3))/L;
f = Fs(i)/2*linspace(0,1,L/2);



stimulus=abs(Y);
stimulus_phase=angle(Y);

clear data
clear filename

filename = [ 'fly5_C' int2str(condition(k)) '_' int2str(frequency(i)) 'Hz_' int2str(amplitude(j)) 'deg_C001H001S0001resp.mat' ];

eval(['load ' filename]);

%load fly5_C1_1Hz_10deg_C001H001S0001resp.mat


Y = fft(data(:,3))/L;
f = Fs(i)/2*linspace(0,1,L/2);

results=abs(Y);
results_phase=angle(Y);

clear data
clear filename


[a b] = max(stimulus);

gain=results(b)/stimulus(b);

phase=(abs(results_phase(b))-abs(stimulus_phase(b)))*180/pi;

stimulus_phi(k,i,j)=stimulus_phase(b)*180/pi;

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





