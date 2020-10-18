
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
        
        F1 = C1./(1-C1);
        F1gain = abs(F1);
        F1phase = angle(F1)*180/pi;
        
        F2 = C2./(1-C2);
        F2gain = abs(F2);
        F2phase = angle(F2)*180/pi;
        
        figure(amp_nr)
        
        subplot(2,1,1)
        
        F2phase = F2phase - (F2phase>100)*360;
        F1phase = F1phase - (F1phase>100)*360;
        
        h1b = errorbar(freqs,mean(F1gain,1),std(F1gain,1)/sqrt(num_flies));
        hold on
        h2b = errorbar(freqs,mean(F2gain,1),std(F2gain,1)/sqrt(num_flies));
        legend('Compound eyes + ocelli','Compound eyes');
        %h1a = plot(freqs,F1gain,'.');
        %h2a = plot(freqs,F2gain,'.');
        
        %set(h1a, 'MarkerSize', 10);
        %set(h1a, 'Color', 'b');
        set(h1b, 'Color', 'b');
        %set(h1a, 'Color', 'b');
        set(h1b, 'Color', 'b');        
        set(h1b, 'LineWidth', 2);
       % set(h2a, 'MarkerSize', 10);
       % set(h2a, 'Color', 'r');
        set(h2b, 'Color', 'r');
        set(h2b, 'LineWidth', 2);
        title(['Controller gain, Amplitude ',int2str(amps(amp_nr)),'°, Average across N = ',int2str(num_flies),' flies ±SEM'])
        ylabel('Gain (linear units)')
        axis([0 12 0 1])
        
        hold off
        
        subplot(2,1,2)
        
        h3b = errorbar(freqs,mean(F1phase,1),std(F1phase,1)/sqrt(num_flies));
        hold on
        %h3a = plot(freqs,F1phase,'.');
       % set(h3a, 'MarkerSize', 10);
       % set(h3a, 'Color', 'b');
        set(h3b, 'Color', 'b');
        set(h3b, 'LineWidth', 2);
        
        
      %  h4a = plot(freqs,F2phase,'.');
        h4b = errorbar(freqs,mean(F2phase,1),std(F2phase,1)/sqrt(num_flies));
     %   set(h4a, 'MarkerSize', 10);
     %   set(h4a, 'Color', 'r');
        set(h4b, 'Color', 'r');
        set(h4b, 'LineWidth', 2);       
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 12 -120 20])
        hold off
end
