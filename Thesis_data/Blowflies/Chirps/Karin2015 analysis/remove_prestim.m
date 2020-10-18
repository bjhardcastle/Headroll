function [aligned_stim,aligned_resp] = remove_prestim(stim, resp, stim_freq)

% Remove the section of sequence before the stimulus starts by aligning
% with a reference stimulus trace with known delay.
% We trim all columns of stim & resp, not just rollangle(:,3)
folder_path = 'Z:\Ben\Horseflies_2015\';
% Check length of stimulus and determine fps
switch stim_freq
    case 0.1
        fps = 100;
        num_cycles = 4;
        load([folder_path 'analysis\reference_stim\0.1_100_4.mat']);   
    
    case 1
        num_cycles = 20;
        if length(stim)<9000 && length(stim)>7000
            load([folder_path 'analysis\reference_stim\1_400_20.mat']);
            fps = 400;
        elseif length(stim)>15000 && length(stim)<17000
            load([folder_path 'analysis\reference_stim\1_800_20.mat']);
            fps = 800;
        else 
            sprintf('Error: 1Hz stim length out of bounds.')
            return
        end
        
    case 3
        num_cycles = 30;
        if length(stim)<9000 && length(stim)>7000
            load([folder_path 'analysis\reference_stim\3_400_30.mat']);
            fps = 400;
        elseif length(stim)>15000 && length(stim)<17000
            load([folder_path 'analysis\reference_stim\3_800_30.mat']);
            fps = 800;
        else 
            sprintf('Error: 3Hz stim length out of bounds.')
        end
            
    case 6
        num_cycles = 60;
        if length(stim)<9000 && length(stim)>7000
            load([folder_path 'analysis\reference_stim\6_400_60.mat']);
            fps = 400;
        elseif length(stim)>15000 && length(stim)<17000
            load([folder_path 'analysis\reference_stim\6_800_60.mat']);
            fps = 800;
        else 
            sprintf('Error: 6Hz stim length out of bounds.')
        end
    case 10
        num_cycles = 60;
        fps = 800;
        load([folder_path 'analysis\reference_stim\10_800_100.mat']);
            
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'analysis\reference_stim\chirp_800.mat']);
        
end
ref_stim = x;

[s,r,d] = alignsignals(ref_stim, stim(:,3));
aligned_stim = stim(d+1:d+length(ref_stim),:);
aligned_resp = resp(d+1:d+length(ref_stim),:);


figure('units','normalized','outerposition',[0 0 1 1]);

subplot(3,2,1:2)
title('stim & refstim')
plot(ref_stim(:,3)),hold on,plot(stim(:,3),'r')

subplot(3,2,3:4)
title('shifted res, shifted stim')
plot(aligned_stim(:,3)), hold on, plot(aligned_resp(:,3),'r')

subplot(3,2,5)
plot(aligned_stim(1:200,3)), hold on, plot(aligned_resp(1:200,3),'r')

subplot(3,2,6)
plot(aligned_stim(end-200:end,3)), hold on, plot(aligned_resp(end-200:end,3),'r')










