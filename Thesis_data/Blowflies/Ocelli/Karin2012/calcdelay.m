kmin=2;
kmed=3;
kmax=4;
samples=2;

F1delay = zeros(1,7);F2delay = zeros(1,7);
for f=1:7,
    F1delay30(f) = 1/samples*(((((F1phase(f,kmed)-F1phase(f,kmin))*(pi/180))/((freqs(kmed)-freqs(kmin))*2*pi)))...
    +(((F1phase(f,kmax)-F1phase(f,kmed))*(pi/180))/((freqs(kmax)-freqs(kmed))*2*pi)))
     
   F2delay30(f) = 1/samples*(((((F2phase(f,kmed)-F2phase(f,kmin))*(pi/180))/((freqs(kmed)-freqs(kmin))*2*pi)))...
    +(((F2phase(f,kmax)-F2phase(f,kmed))*(pi/180))/((freqs(kmax)-freqs(kmed))*2*pi)))
end

delaydiff=F2delay30-F1delay30
avg30=mean(delaydiff)
sem30=std(delaydiff)/sqrt(7)