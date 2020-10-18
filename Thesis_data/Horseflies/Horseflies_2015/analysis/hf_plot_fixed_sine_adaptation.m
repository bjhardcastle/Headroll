clear all
load DATA_hf_fixed_sines;
load DATA_hf_gain_phase;
freqs = roundn(stimfreqs,-1);
color_mat = {[0.2 0.6 1]; [0 0.3 0.6]; [1 0.4 0.4]; [0.6 0 0] };

PLOT_FLAG = 0;

gain_gradient = nan(length(flies),length(freqs),3,4);

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
                        f = fit(step,data,'poly1','normalize','on','Robust','Bisquare');
                        gain_gradient(flyidx,freqidx,trialidx,cidx) = f.p1;
                        
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
                        gain_gradient(flyidx,freqidx,trialidx,cidx) = NaN;
                    end
                else
                    
                    trial_nexist_flag = 1;
                    gain_gradient(flyidx,freqidx,trialidx,cidx) = NaN;
                    
                end
            end
        end
    end
end

grad_mean = squeeze(nanmean(nanmean(gain_gradient,3),1));
grad_std = squeeze(nanstd(nanmean(gain_gradient,3))./sqrt(4));

% PLOT

adaptfig = figure;
h = bar(grad_mean)
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'XTicklabel',{'0.01Hz','1Hz','3Hz','6Hz','10Hz'},'TickLength', [0 0])


hold on

numgroups = size(grad_mean, 1); 
numbars = size(grad_mean, 2); 
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      e = errorbar(x, grad_mean(:,i), grad_std(:,i), 'k', 'linestyle', 'none');
      set(h(i),'facecolor',color_mat{i})    %Also change bar color
end
xlabel('Frequency (Hz)')
ylabel('Gain improvement slope')
title('Mean rate of change of headroll gain during single trials, N = 4')
axis([0.5 5.5 -0.012 0.048]);

lh = legend('light','dark','light, no halteres','dark, no halteres');
set(lh,'Location','Best', 'box','off')

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
export_fig('hf_fixed_sine_adaptation','-transparent', '-pdf')