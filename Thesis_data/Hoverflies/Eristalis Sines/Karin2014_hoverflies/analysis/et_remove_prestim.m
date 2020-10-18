function [ref_stim,aligned_resp,fps] = remove_prestim(resp, stim_freq, plot_flag)
%   Remove the section of sequence before the stimulus starts by aligning with a reference stimulus trace with known delay.
%   We trim all columns of stim & resp, not just rollangle(:,3)
%   Original data are left intact.
folder_path = 'C:\Users\Ben\Dropbox\Work\Karin2014_hoverflies\';


%   Find correct reference stimulus, based on freq and auto-detected FPS
switch stim_freq
    
    case 0.01
        num_cycles = 1;
        load([folder_path 'stimuli\0.01Hz.mat']);
        fps = 50;
        
    case 0.03
        num_cycles = 3;
        load([folder_path 'stimuli\0.03Hz.mat']);
        fps = 50;
        
    case 0.06
        num_cycles = 3;
        load([folder_path 'stimuli\0.06Hz.mat']);
        fps = 50;
        
    case 0.1
        num_cycles = 4;
        load([folder_path 'stimuli\0.1Hz.mat']);
        fps = 50;
        
    case 0.3
        num_cycles = 10;
        load([folder_path 'stimuli\0.3Hz.mat']);
        fps = 60;
        
    case 0.6
        num_cycles = 3;
        load([folder_path 'stimuli\0.6Hz.mat']);
        fps = 500;
        
    case 1
        num_cycles = 20;
            load([folder_path 'stimuli\1Hz.mat']);
            fps = 250;
        
    case 3
        num_cycles = 30;
            load([folder_path 'stimuli\3Hz.mat']);
            fps = 500;
        
    case 6
        num_cycles = 60;
            load([folder_path 'stimuli\6Hz.mat']);
            fps = 500;
        
    case 10
        num_cycles = 100;
            load([folder_path 'stimuli\10Hz.mat']);
            fps = 1000;

    case 15
        num_cycles = 90;
        load([folder_path 'stimuli\15Hz.mat']);
        fps = 1000;
        
    case 20
        num_cycles = 120;
        load([folder_path 'stimuli\20Hz.mat']);
        fps = 1000;
        
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'stimuli\chirp_800.mat']);
        
end

ref_stim = x;

[s,r,d] = alignsignals(ref_stim, data(:,3));
aligned_stim = stim(d+1:d+length(ref_stim),:);
aligned_resp = resp(d+1:d+length(ref_stim),:);


if plot_flag == 1
    %   Plots
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    % reference and current stim
    subplot(3,2,1:2)
    title('stim & refstim')
    plot(ref_stim),hold on,plot(stim(:,3),'r')
    
    % newly aligned resp and stim together
    subplot(3,2,3:4)
    title('shifted res, shifted stim')
    plot(aligned_stim(:,3)), hold on, plot(aligned_resp(:,3),'r')
    
    % first 200 samples of both (stim should start @0deg amp)
    subplot(3,2,5)
    plot(aligned_stim(1:200,3)), hold on, plot(aligned_resp(1:200,3),'r')
    
    % last 200 samples of both
    subplot(3,2,6)
    plot(aligned_stim(end-200:end,3)), hold on, plot(aligned_resp(end-200:end,3),'r')
    
end







