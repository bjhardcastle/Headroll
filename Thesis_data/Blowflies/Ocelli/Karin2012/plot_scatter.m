for t = 1:length(gain)
    subplot(2,1,1)
    hold on
    plot(stimfreq,gain(t),'.');

    subplot(2,1,2)
    hold on
    
    
    plot(stimfreq,phase(t)*180/pi,'.');
    
end