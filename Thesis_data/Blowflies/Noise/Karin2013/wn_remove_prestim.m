function [ref_stim,aligned_resp,aligned_stim,fps] = remove_prestim(stimulus, response, stim_freq, plot_flag)
%   Remove the section of sequence before the stimulus starts by aligning with a reference stimulus trace with known delay.
%   We trim all columns of stim & resp, not just rollangle(:,3)
%   Original data are left intact.
folder_path = [];

%   Check resp and stim are the same length, if not there was a problem
%   with the video analysis
% if length(stimulus)-length(response) ~= 0
%     error('Error: resp and stim data are different lengths. Check video analysis. ');
% end



%   Find correct reference stimulus, based on freq and auto-detected FPS
switch stim_freq
    case 0.01
        num_cycles = 1;
        load([folder_path 'analysis\reference_stim\0.01_100_1.mat']);
        fps = 100;
        
    case 0.03
        num_cycles = 3;
        load([folder_path 'analysis\reference_stim\0.03_100_3.mat']);
        fps = 100;
        
    case 0.1
        num_cycles = 4;
        load([folder_path 'analysis\reference_stim\0.1_100_4.mat']);
        fps = 100;
        
    case 0.3
        num_cycles = 12;
        load([folder_path 'analysis\reference_stim\0.3_100_12.mat']);
        fps = 100;
        
    case 0.06
        num_cycles = 3;
        load([folder_path 'analysis\reference_stim\0.06_100_3.mat']);
        fps = 100;
        
    case 0.6
        num_cycles = 30;
        load([folder_path 'analysis\reference_stim\0.6_100_30.mat']);
        fps = 100;

    case 1
        num_cycles = 20;
        if length(stimulus)<9000 && length(stimulus)>7000
            load([folder_path 'analysis\reference_stim\1_400_20.mat']);
            fps = 400;
        elseif length(stimulus)>15000 && length(stimulus)<17000
            load([folder_path 'analysis\reference_stim\1_800_20.mat']);
            fps = 800;
        else
            sprintf('Error: 1Hz stim length out of bounds.')
            return
        end
        
    case 3
        num_cycles = 30;
        if  length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'analysis\reference_stim\3_400_30.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'analysis\reference_stim\3_800_30.mat']);
            fps = 800;
        else
            sprintf('Error: 3Hz stim length out of bounds.')
        end
        
    case 6
        num_cycles = 60;
        if length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'analysis\reference_stim\6_400_60.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'analysis\reference_stim\6_800_60.mat']);
            fps = 800;
        else
            sprintf('Error: 6Hz stim length out of bounds.')
        end
        
    case 10
        num_cycles = 100;
        if length(stimulus)>3000 && length(stimulus)<5000
            load([folder_path 'analysis\reference_stim\10_400_100.mat']);
            fps = 400;
        elseif length(stimulus)>7000 && length(stimulus)<9500
            load([folder_path 'analysis\reference_stim\10_800_100.mat']);
            fps = 800;
        elseif length(stimulus)>10000 && length(stimulus)<13500
            load([folder_path 'analysis\reference_stim\10_1200_100.mat']);
            fps = 1200;
        else
            sprintf('Error: 10Hz stim length out of bounds.')
        end
        
    case 15
        num_cycles = 150;
        load([folder_path 'analysis\reference_stim\15_1200_150.mat']);
        fps = 1200;

    case 20
        num_cycles = 200;
        load([folder_path 'analysis\reference_stim\20_1200_200.mat']);
        fps = 1200;

    case 25
        num_cycles = 250;
        load([folder_path 'analysis\reference_stim\25_1200_250.mat']);
        fps = 1200;
        
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'analysis\reference_stim\chirp_800.mat']);
        
    case 99 % noisy stimulus
        num_cycles = 1;
        fps = 500;
        load('ref_stim.mat')
        x = ref_stim;

end

ref_stim = x;

if length(stimulus) < 25000
[s,r,d] = alignsignals(ref_stim(1:length(stimulus)), stimulus(:,3));
else
    [s,r,d] = alignsignals(ref_stim, stimulus(:,3));
end
    
% Shift stim() and resp()
if min(stimulus(:,4)) == 0 || length(stimulus) < length(ref_stim)+d % not enough data to shift for full alignment
    aligned_stim = ones(25000,8); % to keep it 25000x8..
    aligned_stim(:,3) = ref_stim;

    aligned_resp = response(d+1:d+length(ref_stim),:);    
else
    
    aligned_stim = stimulus(d+1:d+length(ref_stim),:) - mean(stimulus(1:d+1,3));
     aligned_resp = response(d+1:d+length(ref_stim),:);     
end


if d>0 
    aligned_resp(:,3) = aligned_resp(:,3) - mean(response(1:d,3));
end

% Trim ramped sinewave from high freq signals (first and last 2s)
if stim_freq >= 12 && stim_freq <= 30
    aligned_resp = aligned_resp(2401:end-2400,:);
    aligned_stim = aligned_stim(2401:end-2400,:);
    ref_stim = x(2401:end-2400);
end

% Discard data with errorscore of zero 
[error_places, error_locs] = find(aligned_resp(:,4)==0);

if  min(diff(error_locs)) == 1,
    % there are periods with consecutive errors
    aligned_stim = nan(25000,8); 
    aligned_stim = nan(25000,8);
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







