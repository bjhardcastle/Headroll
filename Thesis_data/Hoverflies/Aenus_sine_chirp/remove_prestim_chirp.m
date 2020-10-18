function [aligned_stim,aligned_resp] = remove_prestim(stim, resp, ref_stim)

% Remove the section of sequence before the stimulus starts by aligning
% with a reference stimulus trace with known delay.
% We trim all columns of stim & resp, not just rollangle(:,3)
% Trim data to 8000 signals long

[s,r,d] = alignsignals(ref_stim, stim(:,3));

% % If the stimulus has errors in video analysis template matching just use
% % the reference signal..
% 
% if min(stim(:,4)) == 0
%     aligned_stim = ref_stim;    
%     ref_stim_flag = 1;
% else 
aligned_stim = stim(d+1:end,3);
%     ref_stim_flag = 0;
% end

aligned_resp = resp(d+1:end,3);

if length(aligned_resp) - length(aligned_stim) > 0
    aligned_resp = aligned_resp(1:(length(aligned_stim)),:);
elseif length(aligned_resp) - length(aligned_stim) < 0
    aligned_stim = aligned_stim(1:(length(aligned_resp)),:);
end

% try to get rid of offset resulting from starting vid analysis at non-zero angle
aligned_resp = aligned_resp - mean(resp(1:d,3));
aligned_resp = aligned_resp - mean(aligned_resp);

% same for stim..
aligned_stim = aligned_stim - mean(aligned_stim);


%% PLOTS
% h = figure('units','normalized','outerposition',[0 0 1 1]);
% 
% 
% subplot(3,2,1:2)
% plot(ref_stim),hold on,plot(stim(:,3),'r')
% title(['REFSTIM'])
% 
% subplot(3,2,3:4)
% plot(aligned_stim), hold on, plot(aligned_resp,'r')
% plot((aligned_resp - mean(aligned_resp)),'k')
% 
% subplot(3,2,5)
% plot(aligned_stim(1:200)), hold on, plot(aligned_resp(1:200),'r')
% 
% subplot(3,2,6)
% plot(aligned_stim(end-200:end)), hold on, plot(aligned_resp(end-200:end),'r')
% 
% pause
% 
% close(h)
% 
% 
% 







