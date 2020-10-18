for fly = 1:length(fly_array)
    for cond = 1: length(cond_array)
        
        figure(100*fly_array(fly)+cond_array(cond));
        title(strcat('Fly',fly_array(fly),', Condition',cond_array(cond)))
        
            
            subplot(2,2,1)
            errorbar(log10(name_array(1,:)),squeeze(G_A_mean(fly,cond,:)),squeeze(G_A_std(fly,cond,:)));
            ylabel('Closed-loop Gain / dB')
            
            subplot(2,2,3)
            errorbar(log10(name_array(1,:)),squeeze(G_p_mean(fly,cond,:)),squeeze(G_p_std(fly,cond,:)));
            xlabel('log10(Frequency) / Hz')
            ylabel('Closed-loop Phase / deg')
            
            subplot(2,2,2)
            errorbar(log10(name_array(1,:)),squeeze(F_A_mean(fly,cond,:)),squeeze(F_A_std(fly,cond,:)));
            ylabel('Open-loop Gain / dB')
            
            subplot(2,2,4)
            errorbar(log10(name_array(1,:)),squeeze(F_p_mean(fly,cond,:)),squeeze(F_p_std(fly,cond,:)));
            xlabel('log10(Frequency) / Hz')
            ylabel('Open-loop Phase / deg')
     
    end
end