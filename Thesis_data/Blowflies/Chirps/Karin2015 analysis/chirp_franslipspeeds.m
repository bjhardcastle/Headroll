% MAIN FILE FOR RETINAL SLIP from blowfly chirp data
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% 
% C1 = Intact
% C2 = No ocelli
% C3 = C2 DARK
% C4 = No ocelli, no halteres
% C5 = C4 DARK
color_mat = {[150 185 255]./255;
    [0 114 189]./255;
    [0 30 120]./255;
    [246 156 30]./255;
    [215 110 0]./255
    [0.6 0.6 0.6]};

freq(1) = 20; % approximate maximum within noisy data
num_freqs = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean_up parameters
%
% They will be used by the script clean_up.m
tol = 600;                     % Matching score below which interpolation is performed
%power_tol = 1;                % importance of tol in filtering. Higher, tol is more important. 0, tol is not considered. -> 1
sigma = 2; % sigma of the gaussian filter
N_filter = ceil(3*sigma);  % half-width of the gaussian filter, ideally >> sigma
ugly_fractions = [];           %fractions of points removed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for fidx = 1:length(flies)
    for cidx = 1:5
        for p = 1 %number of frequencies
        if ~isnan(condmean(cidx).fly(fidx,1))

                resp = condmean(cidx).fly(fidx,:);
                stim = condmeanstim(cidx).fly(fidx,:);
                Fs = 800;              
                
                               
                
                resp_diff = conv(resp,[1,-1]);
                stim_diff = conv(stim,[1,-1]);
                
                resp_vel  = abs(resp_diff(2:length(resp_diff))*Fs);
                stim_vel  = abs(stim_diff(2:length(resp_diff))*Fs);
                
                xvalues = linspace(0,2*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
                
                [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
                result(fidx,cidx,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
                result(fidx,cidx,p).n_resp=N;
                result(fidx,cidx,p).mean_resp=mean(resp_vel);
                [N,edges] = histcounts(stim_vel,xvalues,'Normalization','pdf');
                result(fidx,cidx,p).x_stim=(edges(1:end-1)+edges(2:end))/2;
                result(fidx,cidx,p).n_stim=N;
                result(fidx,cidx,p).mean_stim=mean(stim_vel);
                
            else
                result(fidx,cidx,p).x_resp= nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fidx,cidx,p).n_resp= NaN;
                result(fidx,cidx,p).mean_resp=NaN;
                result(fidx,cidx,p).x_stim=nan(1,length((edges(1:end-1)+edges(2:end))/2));
                result(fidx,cidx,p).n_stim=NaN;
                result(fidx,cidx,p).mean_stim=NaN;

            end
        end
    end
end

%%
%%% PLOT HISTOGRAMS

for p = 1
%     figure(p)
    
    for fidx = 1:length(flies)
%         subplot(length(fly_array),1,fidx)
        
        hist_stim_1(:,fidx) = result(fidx,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fidx) = result(fidx,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_stim_3(:,fidx) = result(fidx,3,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_stim_4(:,fidx) = result(fidx,4,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_stim_4(:,fidx) = result(fidx,5,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
       
        hist_resp_1(:,fidx) = result(fidx,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fidx) = result(fidx,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        hist_resp_3(:,fidx) = result(fidx,3,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        hist_resp_4(:,fidx) = result(fidx,4,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        hist_resp_5(:,fidx) = result(fidx,5,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
%         plot(result(fidx,1,p).x_stim,hist_stim_1(:,fidx))
%         hold on
%         plot(result(fidx,2,p).x_stim,hist_stim_2(:,fidx),'b--')
%         plot(result(fidx,1,p).x_resp, hist_resp_1(:,fidx),'r')
%         plot(result(fidx,2,p).x_resp,hist_resp_2(:,fidx),'r--')
%         hold off
        
    end
    
%     title (['Noise: Max frequency = ', num2str(freq(p)), ' Hz'])
    
    figure(100*p)
    
    shadedErrorBar(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1 , hist_stim_2]'),{'-k','LineWidth',2},1)
    hold on
    shadedErrorBar(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1'),{'g','LineWidth',2},1)
    shadedErrorBar(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2'),{'c','LineWidth',2},1)
    shadedErrorBar(result(1,3,p).x_resp, nanmean(hist_resp_3'),nanstd(hist_resp_3'),{'b','LineWidth',2},1)
    shadedErrorBar(result(1,4,p).x_resp, nanmean(hist_resp_4'),nanstd(hist_resp_4'),{'r','LineWidth',2},1)
    shadedErrorBar(result(1,5,p).x_resp, nanmean(hist_resp_5'),nanstd(hist_resp_5'),{'m','LineWidth',2},1)

    
    % A vertical line for the theoretical peak of the thorax
%     plot([2*pi*freq(p)*30 2*pi*freq(p)*30],get(gca,'ylim'),'k')
    
    hold off
%     title (['Frequency = ', num2str(freq(p)), ' Hz'])
    
    [maxval, index] = max(nanmean([hist_stim_1 , hist_stim_2]'));
    maxi_s(p) = result(1,1,p).x_stim(index);
    [maxval, index] = max(nanmean(hist_resp_1'));
    maxi_1(p) = result(1,1,p).x_resp(index);
    [maxval, index] = max(nanmean(hist_resp_2'));
    maxi_2(p) = result(1,2,p).x_resp(index);
    [maxval, index] = max(nanmean(hist_resp_3'));
    maxi_3(p) = result(1,3,p).x_resp(index);
    [maxval, index] = max(nanmean(hist_resp_4'));
    maxi_4(p) = result(1,4,p).x_resp(index);
    
    
    mean_s(p)= nanmean([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    mean_1(p)= nanmean([result(:,1,p).mean_resp]);
    mean_2(p)= nanmean([result(:,2,p).mean_resp]);
    mean_3(p)= nanmean([result(:,3,p).mean_resp]);
    mean_4(p)= nanmean([result(:,4,p).mean_resp]);

    std_s(p)= nanstd([result(:,1,p).mean_stim,result(:,2,p).mean_stim]);
    std_1(p)= nanstd([result(:,1,p).mean_resp]);
    std_2(p)= nanstd([result(:,2,p).mean_resp]);
    std_3(p)= nanstd([result(:,3,p).mean_resp]);
    std_4(p)= nanstd([result(:,4,p).mean_resp]);
end


% figure(666)
% plot(freq(1:num_freqs), maxi_s(1:num_freqs),'k'); hold on
% plot(freq(1:num_freqs), maxi_1(1:num_freqs),'g')
% plot(freq(1:num_freqs), maxi_2(1:num_freqs),'b')
% plot(freq(1:num_freqs), maxi_3(1:num_freqs),'g')
% plot(freq(1:num_freqs), maxi_4(1:num_freqs),'b')
% 
% 
% figure(667)
% shadedErrorBar(freq(1:num_freqs), mean_s(1:num_freqs),std_s(1:num_freqs),{'k','LineWidth',2})
% hold on
% shadedErrorBar(freq(1:num_freqs), mean_1(1:num_freqs),std_1(1:num_freqs),{'g','LineWidth',2})
% shadedErrorBar(freq(1:num_freqs), mean_2(1:num_freqs),std_2(1:num_freqs),{'b','LineWidth',2})
% 
% fprintf('a fraction %f of ugly points was removed on average (maximum was %f)',mean(ugly_fractions),max(ugly_fractions))
%%

figure
%Stimulus SEM
p=1;
for cidx = 1:6

if cidx ==6
    lineprops.col = {color_mat{6}};
    lineprops.width = 1.5;
sline = mseb(result(1,1,p).x_stim,smooth(nanmean([hist_stim_1 , hist_stim_2]'),3),nanstd([hist_stim_1 , hist_stim_2]'),lineprops,1);
continue
end
hold on
lineprops.col = {color_mat{cidx}};
lineprops.width = 1.5;
hresp = [];
eval(strcat('hresp =hist_resp_',num2str(cidx),';'))
hline.cond(cidx) = mseb(result(1,cidx,p).x_resp, smooth(nanmean(hresp'),3), nanstd(hresp'),lineprops,1);

% sf = scatter(velfreqs,velgains,'.');
% sf.MarkerFaceColor = color_mat{cidx+1};
% sf.MarkerEdgeColor = color_mat{cidx+1};
% hold on
% scatter_color = get(sf, 'CData');
% p = polyfit(velfreqs, velgains,1);
% velfit = polyval(p,velfreqs);
% fline(cidx) = plot(velfreqs,velfit,'LineWidth',1.5,'LineStyle','- -');
% set(fline(cidx),'Color',color_mat{cidx+1})

xlabel('Retinal slip speed [{\circ}/s]')
ylabel('Probability density function [s/{\circ}]')
end
set(gca,'box','off')
xlim([0 4500])
ylim([0 16e-4])
legend([sline.mainLine,hline.cond(1).mainLine,hline.cond(2).mainLine,hline.cond(3).mainLine,hline.cond(4).mainLine,hline.cond(5).mainLine],'TR','C1: Intact','C2: No ocelli','C3: Dark','C4: No halteres','C5: No halteres, dark')
legend('boxoff')
set(gcf,'Position', [103 141 300 240]);
set(gca,'Layer','top')
        set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpgains','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_2\Figures\chirp_slipspeed','-openGL','-r660')
