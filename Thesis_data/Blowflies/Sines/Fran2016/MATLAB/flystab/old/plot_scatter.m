
for t = 1:length(gain1)
    subplot(2,1,1)
    hold on
    plot(log10(stimfreq),20*log10(abs(gain1(t))),'.');

    subplot(2,1,2)
    hold on
    if (gain1(t) < 0)
        phase(t)=phase(t)+180;
    end
    
    if (( phase(t) < -250 ) && ( p < 9))
        plot(log10(stimfreq),phase(t)+360,'.');
    elseif (( phase(t) < -349 ) && ( p == 9))
        plot(log10(stimfreq),phase(t)+360,'.');
    else
        plot(log10(stimfreq),phase(t),'.');
    end
end