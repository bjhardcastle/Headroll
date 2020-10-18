function [ref_stim,aligned_resp,aligned_stim,fps] = remove_prestim(stimulus, response, stim_freq, plot_flag)
%   Remove the section of sequence before the stimulus starts by aligning with a reference stimulus trace with known delay.
%   We trim all columns of stim & resp, not just rollangle(:,3)
%   Original data are left intact.
folder_path = '';

%   Check resp and stim are the same length, if not there was a problem
%   with the video 
% if length(stimulus)-length(response) ~= 0
%     error('Error: resp and stim data are different lengths. Check video . ');
% end



%   Find correct reference stimulus, based on freq and auto-detected FPS
switch stim_freq
    case 0.01
        num_cycles = 1;
        load([folder_path 'reference_stim\0.01_100_1.mat']);
        fps = 100;
        
    case 0.03
        num_cycles = 3;
        load([folder_path 'reference_stim\0.03_100_3.mat']);
        fps = 100;
        
    case 0.1
        num_cycles = 4;
        load([folder_path 'reference_stim\0.1_100_4.mat']);
        fps = 100;
        
    case 0.3
        num_cycles = 12;
        load([folder_path 'reference_stim\0.3_100_12.mat']);
        fps = 100;
        
    case 0.06
        num_cycles = 3;
        load([folder_path 'reference_stim\0.06_100_3.mat']);
        fps = 100;
        
    case 0.6
        num_cycles = 30;
        load([folder_path 'reference_stim\0.6_100_30.mat']);
        fps = 100;

    case 1
        num_cycles = 20;
        if length(stimulus)<9000 && length(stimulus)>7000
            load([folder_path 'reference_stim\1_400_20.mat']);
            fps = 400;
        elseif length(stimulus)>15000 && length(stimulus)<17000
            load([folder_path 'reference_stim\1_800_20.mat']);
            fps = 800;
        else
            sprintf('Error: 1Hz stim length out of bounds.')
            return
        end
        
    case 3
        num_cycles = 30;
        if  length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'reference_stim\3_400_30.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'reference_stim\3_800_30.mat']);
            fps = 800;
        else
            sprintf('Error: 3Hz stim length out of bounds.')
        end
        
    case 6
        num_cycles = 60;
        if length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'reference_stim\6_400_60.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'reference_stim\6_800_60.mat']);
            fps = 800;
        else
            sprintf('Error: 6Hz stim length out of bounds.')
        end
        
    case 10
        num_cycles = 100;
        if length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'reference_stim\10_400_100.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'reference_stim\10_800_100.mat']);
            fps = 800;
        elseif length(stimulus)>10000 && length(stimulus)<13500
            load([folder_path 'reference_stim\10_1200_100.mat']);
            fps = 1200;
        else
            sprintf('Error: 10Hz stim length out of bounds.')
        end
        
    case 15
        num_cycles = 150;
        load([folder_path 'reference_stim\15_1200_150.mat']);
        fps = 1200;

    case 20
        num_cycles = 200;
        load([folder_path 'reference_stim\20_1200_200.mat']);
        fps = 1200;

    case 25
        num_cycles = 250;
        load([folder_path 'reference_stim\25_1200_250.mat']);
        fps = 1200;
        
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'reference_stim\chirp_800.mat']);
        
end

ref_stim = x;

[s,r,d] = alignsignals(ref_stim, stimulus(:,3));

% Shift stim() and resp()
if d+length(ref_stim) < length(stimulus) % not enough data to shift for full alignment
    aligned_stim = stimulus(d+1:d+length(ref_stim),:);
    aligned_resp = response(d+1:d+length(ref_stim),:);
else
     aligned_stim = stimulus(length(stimulus)-length(ref_stim)+1:end,:);
    aligned_resp = response(length(stimulus)-length(ref_stim)+1:end,:);
end

% Trim ramped sinewave from high freq signals (first and last 2s)
if stim_freq >= 12 && stim_freq <30
    aligned_resp = aligned_resp(2401:end-2400,:);
    aligned_stim = aligned_stim(2401:end-2400,:);
    ref_stim = x(2401:end-2400);
end


if plot_flag == 1
    %   Plots
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    % reference and current stim
    subplot(3,2,1:2)
    plot(ref_stim),hold on,plot(aligned_stim(:,3),'r')
    title(['stim & refstim, ',num2str(stim_freq),'Hz'])
   
    % newly aligned resp and stim together
    subplot(3,2,3:4)
    plot(aligned_stim(:,3)), hold on, plot(aligned_resp(:,3),'r')
    title('shifted res, shifted stim')

    % first 200 samples of both (stim should start @0deg amp)
    subplot(3,2,5)
    plot(aligned_stim(1:200,3)), hold on, plot(aligned_resp(1:200,3),'r')
    
    % last 200 samples of both
    subplot(3,2,6)
    plot(aligned_stim(end-200:end,3)), hold on, plot(aligned_resp(end-200:end,3),'r')
   pause 
   close all
end

% If the stimulus has errors in video analysis template matching just use
% the reference signal..

% if min(stim(:,4)) == 0
%     aligned_stim = ref_stim;    
%     ref_stim_flag = 1;
% else aligned_stim = stim(d+1:end,3);
%     ref_stim_flag = 0;
% end
% 
% aligned_resp = resp(d+1:end,3);
% 
% if length(aligned_resp) - length(aligned_stim) > 0
%     aligned_resp = aligned_resp(1:(length(aligned_stim)),:);
% elseif length(aligned_resp) - length(aligned_stim) < 0
%     aligned_stim = aligned_stim(1:(length(aligned_resp)),:);
% end
% 
% % try to get rid of offset from starting vid analysis at non-zero angle
% aligned_resp = aligned_resp - mean(resp(1:d,3));
% aligned_resp = aligned_resp - mean(aligned_resp);
% 
% 
% 
% 
% 
% 
% 
