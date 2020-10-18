clear all
load DATA_horsefly_fixed_sines;

flies = [2,3,4,5];
stimfreqs = [0.1,1,3.003,6.006,10.01];
freqs = [0.1,1,3,6,10];

resp_gain_mean = nan(4,4,5,2);

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    
    for cidx = 1:4
        cidx;

        for freqidx = 1:5,
            freq = freqs(freqidx);
            
            [fly,cidx,freq]
            
            trial_nexist_flag = 0; 
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
                if (~isnan(headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)));
                    
                stimfreq = freq;
                Fs = framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx);                         
                resp = headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx); 
                stimmat = dir(['reference_stim\',num2str(roundn(stimfreqs(freqidx),-1)),'_',num2str(Fs),'_*.mat']);
                load (['reference_stim\' stimmat.name])
                resp = resp';
                stim = x';
                horsefly_calc_gain_phase;
                
                subplot(2,1,1)
                scatter([1:num_steps],gain)
                subplot(2,1,2)
                scatter([1:num_steps],phase)
                pause(1)
                
                resp_gain_mean(flyidx,freqidx,trialidx,cidx) = CL_gain;
                resp_phase_mean(flyidx,freqidx,trialidx,cidx) = CL_phase;
                resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;

                
                else
                    trial_nexist_flag = 1;
                    
                resp_gain_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_phase_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;

                end
                
            end
        end
    end
end


% Plot Bode plot for each condition/amplitude combo
% Get trial mean
resp_gain_mean = nanmean(resp_gain_mean,3);
resp_phase_mean = nanmean(resp_phase_mean,3);
resp_gain_std = nanmean(resp_gain_std,3);
resp_phase_std = nanmean(resp_phase_std,3);

save('gain_phase.mat','resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std');

plot_ind =1;
color_mat = {[51 155 255];[0 76 153];[255 102 102];[153 0 0]}

for cidx = 1:4
    for amp_nr = 1:1
        
        hold on
        
        CLg=squeeze(resp_gain_mean(:,:,amp_nr,cidx));
        CLgm=nanmean(CLg,1);
        CLgs = std(CLg,1);
        
        CLp=squeeze(resp_phase_mean(:,:,amp_nr,cidx));
        CLpm=nanmean(CLp,1);
        CLps = std(CLp,1);
        
        subplot(2,1,1)        
        h = errorbar(freqs,CLgm,CLgs);
        set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
 
        if plot_ind
            hold on
            plot(freqs,CLg,'.', 'Color', [color_mat{cidx}/255])
            hold off            
        end
        
    end
end
        
        title(['Average all flies, Condition ',int2str(cidx),''])
        ylabel('Gain (linear units)')
        axis([0 11 0 1.0])
        
        
for cidx = 1:4    
    hold on

        subplot(2,1,2)
        h = errorbar(freqs,CLpm,CLps);
        set(h, 'LineWidth', 3, 'Color', [color_mat{cidx}/255]);
        if plot_ind
            hold on
            plot(freqs,CLp,'.', 'Color', [color_mat{cidx}/255])
            hold off
        end
        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -180 20])
end


                