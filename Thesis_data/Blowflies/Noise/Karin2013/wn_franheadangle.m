% MAIN FILE FOR RETINAL SLIP
% author: fjh31@cam.ac.uk (reusing, when possible, Daniel's code)
%
% Loads responses (Output of Matthew's LabVIEW vi) of flies and conditions
% as defined by the user.
clear all
load 'WN_DATA.mat'
load 'ref_stim.mat'

%C1 = '_WN_no-ocelli-'; C2 = '_WN_dark-'; C3 = '_WN_without-halteres_'; C4 = '_WN_without-halteres_dark_';

%% organise mean responses
fly_array = [1:9]; % fly numbers are 0:8 in saved data, added +1 prior to save

freq(1) = 3; % approximate maximum within noisy data
num_freqs = 1;

clear condmean allmean 
% mean condition for each fly
for cidx = 1:4
    for fidx = 1:length(fly_array) %fly 8 is missing wind cond
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            condmean(cidx).fly(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial,2);
            condmeanstim(cidx).fly(fidx,:) = nanmean(stims.fly(fidx).cond(cidx).trial,2);
        end
    end
    
    allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);
    
end

clear condallfly condallflyrel
% aggregate all trials for all flies, by condition
for cidx = 1:4
    
    allidx = 0;
    for fidx = 1:length(fly_array)
        
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            for tidx = 1: tn
                allidx = allidx + 1;
                condallfly(cidx).all(allidx,:) = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                condallflystim(cidx).all(allidx,:) = stims.fly(fidx).cond(cidx).trial(:,tidx);
                condallflyrel(cidx).all(allidx,:) = ref_stim' - headroll.fly(fidx).cond(cidx).trial(:,tidx);
            end
        end
        
        
    end
    condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(fly_array) - 1);
    condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(fly_array) - 1);
    condsemrel(cidx,:) = nanstd(condallflyrel(cidx).all)/sqrt(length(fly_array) - 1);
end


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


for fidx = 1:length(fly_array)
    for cidx = 1:4
        for p = 1
        if ~isnan(condmean(cidx).fly(fidx,1))

                resp = condmean(cidx).fly(fidx,:);
                stim = condmeanstim(cidx).fly(fidx,:);
                Fs = 500;              
                
                resp_diff = resp;
                stim_diff = stim;
                
                resp_vel  = resp_diff(2:length(resp_diff));
                stim_vel  = stim_diff(2:length(resp_diff));
                
                xvalues = linspace(0,2*2*pi*freq(p)*30,50); %2 times the maximum angular speed of stim
                xvalues = [];
                xvalues = [-40:1:40];
                
                [N,edges] = histcounts(resp_vel,xvalues);
                result(fidx,cidx,p).x_resp=(edges(1:end-1)+edges(2:end))/2;
                result(fidx,cidx,p).n_resp=N;
                result(fidx,cidx,p).mean_resp=mean(resp_vel);
                [N,edges] = histcounts(stim_vel,xvalues);
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


%%% PLOT HISTOGRAMS

for p = 1
%     figure(p)
    
    for fidx = 1:length(fly_array)
%         subplot(length(fly_array),1,fidx)
        
        hist_stim_1(:,fidx) = result(fidx,1,p).n_stim; %/ diff(result(fly,1,p).x_stim([1,2]));
        hist_stim_2(:,fidx) = result(fidx,2,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_stim_3(:,fidx) = result(fidx,3,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));
        hist_stim_4(:,fidx) = result(fidx,4,p).n_stim; %/ diff(result(fly,2,p).x_stim([1,2]));

        hist_resp_1(:,fidx) = result(fidx,1,p).n_resp; %/ diff(result(fly,1,p).x_resp([1,2]));
        hist_resp_2(:,fidx) = result(fidx,2,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        hist_resp_3(:,fidx) = result(fidx,3,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));
        hist_resp_4(:,fidx) = result(fidx,4,p).n_resp; %/ diff(result(fly,2,p).x_resp([1,2]));

%         plot(result(fidx,1,p).x_stim,hist_stim_1(:,fidx))
%         hold on
%         plot(result(fidx,2,p).x_stim,hist_stim_2(:,fidx),'b--')
%         plot(result(fidx,1,p).x_resp, hist_resp_1(:,fidx),'r')
%         plot(result(fidx,2,p).x_resp,hist_resp_2(:,fidx),'r--')
%         hold off
        
    end
    
    title (['Noise: Max frequency = ', num2str(freq(p)), ' Hz'])
    
    figure(100*p)
    
    shadedErrorBar(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1 , hist_stim_2]'),{'-k','LineWidth',2},1)
    hold on
    shadedErrorBar(result(1,1,p).x_resp, nanmean(hist_resp_1'),nanstd(hist_resp_1'),{'g','LineWidth',2},1)
    shadedErrorBar(result(1,2,p).x_resp, nanmean(hist_resp_2'),nanstd(hist_resp_2'),{'c','LineWidth',2},1)
    shadedErrorBar(result(1,3,p).x_resp, nanmean(hist_resp_3'),nanstd(hist_resp_3'),{'b','LineWidth',2},1)
    % C4 has no std as there's only 1 fly 
    plot(result(1,4,p).x_resp, nanmean(hist_resp_4'),'m','LineWidth',2)

%     % A vertical line for the theoretical peak of the thorax
%     plot([2*pi*freq(p)*30 2*pi*freq(p)*30],get(gca,'ylim'),'k')
%     hold off
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

figure(100*p+1)

% shadedErrorBar(result(1,1,p).x_stim, nanmean([hist_stim_1 , hist_stim_2]'),nanstd([hist_stim_1 , hist_stim_2]'),{'-k','LineWidth',2},1)
hold on
shadedErrorBar(result(1,1,p).x_resp, nanmean(hist_resp_1')./nanmean(hist_stim_1'),nanstd(hist_resp_1'./hist_stim_1'),{'g','LineWidth',2},1)
shadedErrorBar(result(1,2,p).x_resp, nanmean(hist_resp_2')./nanmean(hist_stim_1'),nanstd(hist_resp_2'./hist_stim_1'),{'c','LineWidth',2},1)
shadedErrorBar(result(1,3,p).x_resp, nanmean(hist_resp_3')./nanmean(hist_stim_1'),nanstd(hist_resp_3'./hist_stim_1'),{'b','LineWidth',2},1)
% C4 has no std as there's only 1 fly
plot(result(1,4,p).x_resp, nanmean(hist_resp_4')./nanmean(hist_stim_1'),'m','LineWidth',2)
   hold off
   title (['Noise: head angle distribution'])


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