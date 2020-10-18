clear all
load DATA_hf_fixed_sines;
load DATA_hf_gain_phase;
freqs = roundn(stimfreqs,-1);
color_mat = {[0.7 0.9 1]; [0 0.2 0.4]; [1 0.7 0.7]; [0.6 0 0] };

PLOT_FLAG = 0;

gain_increase = nan(length(flies),length(freqs),3,4);

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    
    for cidx = 1:4
        
        for freqidx = 1:length(freqs),
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
                if ~isempty(step_G(flyidx).cond(cidx).freq(freqidx).trial)
                    try
                        data = real(step_G(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx));
                        step = (1:length(data))';
                        fifth_length = floor(length(data)/5);
                        gain_increase(flyidx,freqidx,trialidx,cidx) = ...
                            mean(data(end-fifth_length:end)) - mean(data(1:fifth_length));
                        
                        if PLOT_FLAG == 1
                            figure
                            scatter(step,data)
                            title(num2str(f.p1))
                            hold on
                            plot(f)
                            pause(1)
                            hold off
                        end
                        
                    catch
                        trial_nexist_flag = 1;
                        gain_increase(flyidx,freqidx,trialidx,cidx) = NaN;
                    end
                else
                    
                    trial_nexist_flag = 1;
                    gain_increase(flyidx,freqidx,trialidx,cidx) = NaN;
                    
                end
            end
        end
    end
end

grad_mean = squeeze(nanmean(nanmean(gain_increase,3),1));
grad_std = squeeze(nanstd(nanmean(gain_increase,3))./sqrt(4));

% PLOT

adaptfig = figure('Position', [430 480 415 380]);
h = bar(grad_mean)
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'XTicklabel',{'0.01 Hz','1 Hz','3 Hz','6 Hz','10 Hz'},'TickDir','out','fontsize',12)


hold on

numgroups = size(grad_mean, 1); 
numbars = size(grad_mean, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      e = errorbar(x, grad_mean(:,i), grad_std(:,i)/sqrt(4), 'k', 'linestyle', 'none');
      set(h(i),'facecolor',color_mat{i})    %Also change bar color
end
set(gca,'fontsize',12, 'fontname','Arial')
xlabel('Frequency')
ylabel('\Delta Gain')
title(sprintf('Mean change in headroll gain within single trial, N = 4'),'fontsize',9)
axis([1.5 5.5 -0.042 0.142]); % Cut out 0.1Hz
lh = legend('light','dark','light, no halteres','dark, no halteres');
set(lh,'Location','Best', 'box','off','fontsize',8)

% h = errorbar(freqs,grad_mean,grad_std);
% set(h, 'LineWidth', 3, 'Color', [0.9 0.5 0.1]);
% set(adaptfig,'XTick',[0.1,1,3,6,10],'XTickLabel',{'0.1','1','3','6','10'},'fontsize',12)
% axis([0 10.5 0 1.0])

% adaptfig = figure;
% adaptaxes = axes('parent', adaptfig)
% colors = hsv(size(grad_mean,2));
% for i = 1:size(grad_mean,2)
%     bar(i, grad_mean(i,:), 'parent', adaptaxes, 'facecolor', colors(i,:));
% end

set(gcf, 'Renderer', 'painters');
% export_fig('hf_fixed_sine_adaptation','-transparent', '-pdf')
export_fig('hf_fixed_sine_adaptation','-transparent', '-m10')