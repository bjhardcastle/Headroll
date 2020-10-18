function [aligned_stim,aligned_resp] = remove_prestim(stim, resp, ref_stim)

% Remove the section of sequence before the stimulus starts by aligning
% with a reference stimulus trace with known delay.
% We trim all columns of stim & resp, not just rollangle(:,3)
% Trim data to 8000 signals long

[s,r,d] = alignsignals(ref_stim, stim(:,3));

% If the stimulus has errors in video analysis template matching just use
% the reference signal..
if min(stim(:,4)) == 0
    aligned_stim = ref_stim;
else aligned_stim = stim(d+1:end,:);
end

aligned_resp = resp(d+1:end,:);

if aligned_resp - aligned_stim ~=0
    aligned_resp = aligned_resp(1:length(aligned_stim));
end

