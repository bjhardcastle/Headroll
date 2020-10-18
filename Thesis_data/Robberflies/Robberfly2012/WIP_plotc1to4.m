for group = 1:2;   
for cond_nr = 2*group-1:2*group
    clear CLg CLgm individ individ_means 

    for freq_nr = 1:num_freqs
        
        CLg =squeeze(resp_gain_mean(group,:,freq_nr,1,cond_nr));
        CLg([3,5]) = [];
        CLgm(freq_nr) = sum(CLg)/sum(CLg~=0);
        individ = CLg(CLg~=0);
        individ_means(freq_nr,1:length(individ)) = individ;
%         CLgs = nanstd(CLg,1);
%         CLgm_save{cond_nr} = nanmean(CLg,1);
%         CLgs_save{cond_nr} = nanstd(CLg,1);
%         
%         CLp=squeeze(resp_phase_mean(:,:,amp_nr,cond_nr));
%         CLpm = nanmean(CLp,1);
%         CLps = nanstd(CLp,1);
%         CLpm_save{cond_nr} = nanmean(CLp,1);
%         CLps_save{cond_nr} = nanstd(CLp,1);
    end
        
             


figure(1)
subplot(2,1,group)  
    h = plot(freqs,CLgm,'b');
  
        set(h, 'LineWidth', 2);
        if cond_nr == 2 || cond_nr == 4,
            set(h,'Color','r')
        end
        
        
          hold on
  i = plot(freqs,individ_means,'b.')
             if cond_nr == 2 || cond_nr == 4,
             set(i,'Color','r')
             end
           
       axis([0 11 0 1.2])
end
end
      
        
        
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain (linear units)')
        axis([0 11 0 0.5])
        
        subplot(2,1,2)
        h = errorbar(freqs,CLpm,CLps);
        set(h, 'LineWidth',2);
         if cond_nr == 2,
            set('Color','r')
        end
        if plot_ind
            hold on
            for n=1:length(freqs),
                comp = CLp(:,n)
                plots(freqs(:,n),comp(comp~=0),'.')
                 if cond_nr == 2,
            set('Color','r')
        end
            end
            hold off
        end
        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -100 20])
    end
end
