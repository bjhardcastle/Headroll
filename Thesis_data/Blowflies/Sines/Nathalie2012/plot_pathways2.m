% Calculate and plot CE and O pathway frequency responses
% Caution, we here operate with the means of the estimated closed-lopp
% freqeuncy responses!

for amp_nr = 1:num_amps
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        C1gain = CLg1;
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        C1phase = CLp1;
        
        C1 = C1gain.*exp(1i*C1phase*pi/180);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        C2gain = CLg2;
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        C2phase = CLp2;
        
        C2 = C2gain.*exp(1i*C2phase*pi/180);
        
        CE = C2./(1-C2);
        CEgain = abs(CE);
        CEphase = angle(CE)*180/pi;
        
        OC = C1./(1-C1)-CE;
        OCgain = abs(OC);
        OCphase = angle(OC)*180/pi;
        
        figure(amp_nr)
        
        subplot(2,1,1)
        
        OCphase = OCphase - (OCphase>0)*360;
        CEphase = CEphase - (CEphase>0)*360;
        
        h1 = plot(freqs,CEgain,'.');
        set(h1, 'MarkerSize', 10);
        set(h1, 'Color', 'b');
        hold on
        
        h2 = plot(freqs,OCgain,'.');
        set(h2, 'MarkerSize', 10);
        set(h2, 'Color', 'r');
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain (linear units)')
        %axis([0 11 0 0.5])
        legend('CE','OC')
        hold off
        
        subplot(2,1,2)
        h3 = plot(freqs,CEphase,'.');
        set(h3, 'MarkerSize', 10);
        set(h3, 'Color', 'b');
        hold on
        
        h4 = plot(freqs,OCphase,'.');
        set(h4, 'MarkerSize', 10);
        set(h4, 'Color', 'r');        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        %axis([0 11 -100 20])
        hold off
end