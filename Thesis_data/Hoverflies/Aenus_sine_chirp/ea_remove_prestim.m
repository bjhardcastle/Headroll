function [ref_stim,aligned_resp,aligned_stim,fps] = ea_remove_prestim(stim, resp, stim_freq, plot_flag)
%   Remove the section of sequence before the stim starts by aligning with a reference stim trace with known delay.
%   We trim all columns of stim & resp, not just rollangle(:,3)
%   Original data are left intact.
folder_path = [fileparts(mfilename('fullpath')) '\'];

%   Check resp and stim are the same length, if not there was a problem
%   with the video 
% if length(stim)-length(resp) ~= 0
%     error('Error: resp and stim data are different lengths. Check video . ');
% end



%   Find correct reference stim, based on freq and auto-detected FPS
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
        if length(stim)<9000 && length(stim)>7000
            load([folder_path 'reference_stim\1_400_20.mat']);
            fps = 400;
        elseif length(stim)>15000 && length(stim)<17000
            load([folder_path 'reference_stim\1_800_20.mat']);
            fps = 800;
        else
            sprintf('Error: 1Hz stim length out of bounds.')
            return
        end
        
    case 3
        num_cycles = 30;
        if  length(stim)<3000 && length(stim)>2000
            load([folder_path 'reference_stim\3_250_30.mat']);
            fps = 250;
        elseif  length(stim)>3000 && length(stim)<5000
            load([folder_path 'reference_stim\3_400_30.mat']);
            fps = 400;
        elseif  length(stim)>=9500 && length(stim)<11500
            load([folder_path 'reference_stim\3_1000_30.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'reference_stim\3_800_30.mat']);
            fps = 800;
        else
            sprintf('Error: 3Hz stim length out of bounds.')
        end
        
    case 6
        num_cycles = 60;
        if length(stim)>3000 && length(stim)<5000
            load([folder_path 'reference_stim\6_400_60.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'reference_stim\6_800_60.mat']);
            fps = 800;
        else
            sprintf('Error: 6Hz stim length out of bounds.')
        end
        
    case 10
        num_cycles = 100;
        if length(stim)>3000 && length(stim)<5000
            load([folder_path 'reference_stim\10_400_100.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'reference_stim\10_800_100.mat']);
            fps = 800;
        elseif length(stim)>10000 && length(stim)<13500
            load([folder_path 'reference_stim\10_1200_100.mat']);
            fps = 1200;
        else
            sprintf('Error: 10Hz stim length out of bounds.')
        end
        
    case 15
        num_cycles = 150;
        if length(stim)>9500 && length(stim)<11500 
            load([folder_path 'reference_stim\15_1000_150.mat']);
        fps = 1000;
          elseif length(stim)>11500 && length(stim)<13500
        load([folder_path 'reference_stim\15_1200_150.mat']);
        fps = 1200;
        end

    case 20
        num_cycles = 200;
        if length(stim)>9500 && length(stim)<11500
            load([folder_path 'reference_stim\20_1000_200.mat']);
            fps = 1000;
        elseif length(stim)>11500 && length(stim)<13500
            
            load([folder_path 'reference_stim\20_1200_200.mat']);
            fps = 1200;
        end
        
    case 25
        num_cycles = 250;
        if length(stim)>9500 && length(stim)<11500
            load([folder_path 'reference_stim\25_1000_250.mat']);
            fps = 1000;
        elseif length(stim)>11500 && length(stim)<13500
            load([folder_path 'reference_stim\25_1200_250.mat']);
            fps = 1200;
        end
        
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'reference_stim\chirp_800.mat']);
        
end

if size(x,2)>size(x,1)
    x = x';
end

ref_stim = x;

[s,r,d] = alignsignals(ref_stim, stim(:,3));

% Shift stim() and resp()
if d+length(ref_stim) < length(stim) % not enough data to shift for full alignment
    aligned_stim = stim(d+1:d+length(ref_stim),:);
    aligned_resp = resp(d+1:d+length(ref_stim),:);
else
     aligned_stim = stim(length(stim)-length(ref_stim)+1:end,:);
    aligned_resp = resp(length(stim)-length(ref_stim)+1:end,:);
end

% Trim ramped sinewave from high freq signals (first and last 2s)
if stim_freq >= 12 && stim_freq <30
    twoSec = fps*2;
    aligned_resp = aligned_resp(twoSec+1:end-twoSec,:);
    aligned_stim = aligned_stim(twoSec+1:end-twoSec,:);
    ref_stim = x(twoSec+1:end-twoSec);
end


% if min(stim(:,4)) == 0
%     aligned_stim = ref_stim;    
%     ref_stim_flag = 1;
% else
%     aligned_stim = stim(d+1:end,3);
%     ref_stim_flag = 0;
% end
% 
% 
% aligned_resp = resp(d+1:end,:);
% 

if size(aligned_resp,1) - size(aligned_stim,1) > 0
    aligned_resp = aligned_resp(1:(size(aligned_stim,1)),:);
elseif size(aligned_resp,1) - size(aligned_stim,1) < 0
    aligned_stim = aligned_stim(1:(size(aligned_resp,1)),:);
end
% if size(aligned_resp,1) - length(stim) > 0
%     aligned_resp = aligned_resp(1:(length(stim)),:);
%     aligned_stim = aligned_stim(1:(length(stim)),:);
% end

% try to get rid of offset resulting from starting vid analysis at non-zero angle
for arIdx = 1:3
aligned_resp(:,arIdx) = aligned_resp(:,arIdx) - mean(aligned_resp(:,arIdx));
aligned_stim(:,arIdx) = aligned_stim(:,arIdx) -  mean(aligned_stim(:,arIdx));
end

if min(aligned_stim(:,4)) == 0
    aligned_stim(:,3) = ref_stim;    
end

if plot_flag == 1
    %   Plots
    figure('units','normalized','outerposition',[0 0 1 1]);
     
    % reference and current stim
    subplot(3,2,1:2)
    plot(ref_stim,'r'),hold on,plot(aligned_stim(:,3),'k:')
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

% If the stim has errors in video analysis template matching just use
% the reference signal..




