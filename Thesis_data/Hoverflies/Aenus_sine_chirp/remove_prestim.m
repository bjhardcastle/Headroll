function [aligned_stim,aligned_resp] = remove_prestim(stim, resp, ref_stim)

% Remove the section of sequence before the stimulus starts by aligning
% with a reference stimulus trace with known delay.
% We trim all columns of stim & resp, not just rollangle(:,3)
% Trim data to 8000 signals long

[s,r,d] = alignsignals(ref_stim, stim(:,3));
aligned_stim = stim(d+1:end,:);
aligned_resp = resp(d+1:end,:);






