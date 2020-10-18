
if ( PlotdB == 1 )
    
    for fly = 1:length(fly_array)
        for cond = 1: length(cond_array)
            
            figure(100*fly_array(fly)+cond_array(cond));
            
            
            subplot(2,2,1)
            semilogx(name_array(1,:),20*log10(squeeze(G_Aab_mean(fly,cond,:))),'o-b');
            hold on
            semilogx(name_array(1,:),20*log10(squeeze(G_Aab_mean(fly,cond,:)+k_factor*G_Aab_std(fly,cond,:))),'c');
            semilogx(name_array(1,:),20*log10(squeeze(G_Aab_mean(fly,cond,:)-k_factor*G_Aab_std(fly,cond,:))),'c');
            %             semilogx(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Closed-loop Gain')
            
            subplot(2,2,3)
            
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)+k_factor*G_p_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)-k_factor*G_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             semilogx(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Closed-loop Phase / deg')
            
            subplot(2,2,2)
            semilogx(name_array(1,:),20*log10(squeeze(F_Aab_mean(fly,cond,:))),'o-b');
            hold on
            semilogx(name_array(1,:),20*log10(squeeze(F_Aab_mean(fly,cond,:)+k_factor*F_Aab_std(fly,cond,:))),'c');
            semilogx(name_array(1,:),20*log10(squeeze(F_Aab_mean(fly,cond,:)-k_factor*F_Aab_std(fly,cond,:))),'c');
            %             semilogx(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Open-loop Gain')
            
            subplot(2,2,4)
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)+k_factor*F_p_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)-k_factor*F_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             semilogx(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Open-loop Phase / deg')
            
            mtit(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
            
        end
    end
    
elseif ( PlotdB == 2 )
    
    for fly = 1:length(fly_array)
        for cond = 1: length(cond_array)
            
            figure(100*fly_array(fly)+cond_array(cond));
            
            
            subplot(2,2,1)
            semilogx(name_array(1,:),squeeze(G_AdB_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(G_AdB_mean(fly,cond,:)+k_factor*G_AdB_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(G_AdB_mean(fly,cond,:)-k_factor*G_AdB_std(fly,cond,:)),'c');
            %             semilogx(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Closed-loop Gain')
            
            subplot(2,2,3)
            
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)+k_factor*G_p_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(G_p_mean(fly,cond,:)-k_factor*G_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             semilogx(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Closed-loop Phase / deg')
            
            subplot(2,2,2)
            semilogx(name_array(1,:),squeeze(F_AdB_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(F_AdB_mean(fly,cond,:)+k_factor*F_AdB_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(F_AdB_mean(fly,cond,:)-k_factor*F_AdB_std(fly,cond,:)),'c');
            %             semilogx(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Open-loop Gain')
            
            subplot(2,2,4)
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)),'o-b');
            hold on
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)+k_factor*F_p_std(fly,cond,:)),'c');
            semilogx(name_array(1,:),squeeze(F_p_mean(fly,cond,:)-k_factor*F_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             semilogx(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Open-loop Phase / deg')
            
            mtit(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
            
        end
    end
elseif ( PlotdB == 0 )
    name_array2 = name_array(1,3:end);
    
    for fly = 1:length(fly_array)
        for cond = 1: length(cond_array)
            
            figure(100*fly_array(fly)+cond_array(cond));
            
            
            subplot(2,2,1)
            plot(name_array2(1,:),(squeeze(G_Aab_mean(fly,cond,:))),'o-b');
            hold on
            plot(name_array2(1,:),(squeeze(G_Aab_mean(fly,cond,:)+k_factor*G_Aab_std(fly,cond,:))),'c');
            plot(name_array2(1,:),(squeeze(G_Aab_mean(fly,cond,:)-k_factor*G_Aab_std(fly,cond,:))),'c');
            %             plot(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Closed-loop Gain')
            
            subplot(2,2,3)
            
            plot(name_array2(1,:),squeeze(G_p_mean(fly,cond,:)),'o-b');
            hold on
            plot(name_array2(1,:),squeeze(G_p_mean(fly,cond,:)+k_factor*G_p_std(fly,cond,:)),'c');
            plot(name_array2(1,:),squeeze(G_p_mean(fly,cond,:)-k_factor*G_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             plot(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Closed-loop Phase / deg')
            
            subplot(2,2,2)
            plot(name_array2(1,:),(squeeze(F_Aab_mean(fly,cond,:))),'o-b');
            hold on
            plot(name_array2(1,:),(squeeze(F_Aab_mean(fly,cond,:)+k_factor*F_Aab_std(fly,cond,:))),'c');
            plot(name_array2(1,:),(squeeze(F_Aab_mean(fly,cond,:)-k_factor*F_Aab_std(fly,cond,:))),'c');
            %             plot(name_array(1,:), [0 0 0 0 0 0 0 0 0 ], 'g')
            hold off
            ylabel('Open-loop Gain')
            
            subplot(2,2,4)
            plot(name_array2(1,:),squeeze(F_p_mean(fly,cond,:)),'o-b');
            hold on
            plot(name_array2(1,:),squeeze(F_p_mean(fly,cond,:)+k_factor*F_p_std(fly,cond,:)),'c');
            plot(name_array2(1,:),squeeze(F_p_mean(fly,cond,:)-k_factor*F_p_std(fly,cond,:)),'c');
            xlabel('Frequency / Hz')
            %             plot(name_array(1,:), [-180 -180 -180 -180 -180 -180 -180 -180 -180 ], 'g')
            hold off
            ylabel('Open-loop Phase / deg')
            
            mtit(strcat('Fly',int2str(fly_array(fly)),', Condition',int2str(cond_array(cond))))
            
        end
    end
    
end