
function [ref_stim,aligned_resp,aligned_stim,fps] = tb_remove_prestim(stim, resp, stim_freq, plot_flag)
%   Remove the section of sequence before the stimulus starts by aligning with a reference stimulus trace with known delay.
%   We trim all columns of stim & resp, not just rollangle(:,3)
%   Original data are left intact.
folder_path = [fileparts(fileparts(mfilename('fullpath'))) '\'];

%   Check resp and stim are the same length, if not there was a problem
%   with the video analysis
if length(stim)-length(resp) ~= 0
    error('Error: resp and stim data are different lengths. Check video analysis. ');
end

%   Find correct reference stimulus, based on freq and auto-detected FPS
switch stim_freq
    case 0.1
        num_cycles = 4;
        load([folder_path 'analysis\reference_stim\0.1_100_4.mat']);
        fps = 100;
        
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
        if  length(stim)<3000 && length(stim)>2000
            load([folder_path 'analysis\reference_stim\3_250_30.mat']);
            fps = 250;
        elseif  length(stim)>3000 && length(stim)<5000
            load([folder_path 'analysis\reference_stim\3_400_30.mat']);
            fps = 400;
        elseif  length(stim)>=9500 && length(stim)<11500
            load([folder_path 'analysis\reference_stim\3_1000_30.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'analysis\reference_stim\3_800_30.mat']);
            fps = 800;
        else
            sprintf('Error: 3Hz stim length out of bounds.')
        end
        
        
    case 6
        num_cycles = 60;
        if length(stim)>3000 && length(stim)<5000
            load([folder_path 'analysis\reference_stim\6_400_60.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'analysis\reference_stim\6_800_60.mat']);
            fps = 800;
        else
            sprintf('Error: 6Hz stim length out of bounds.')
        end
        
    case 10
        num_cycles = 100;
        if length(stim)>3000 && length(stim)<5000
            load([folder_path 'analysis\reference_stim\10_400_100.mat']);
            fps = 400;
        elseif length(stim)>7000 && length(stim)<9500
            load([folder_path 'analysis\reference_stim\10_800_100.mat']);
            fps = 800;
        else
            sprintf('Error: 10Hz stim length out of bounds.')
        end
    case 15
        num_cycles = 150;
        if length(stim)>9500 && length(stim)<11500
            load([folder_path 'analysis\reference_stim\15_1000_150.mat']);
            fps = 1000;
        elseif length(stim)>11500 && length(stim)<13500
            load([folder_path 'analysis\reference_stim\15_1200_150.mat']);
            fps = 1200;
        end
        
    case 20
        num_cycles = 200;
        if length(stim)>9500 && length(stim)<11500
            load([folder_path 'analysis\reference_stim\20_1000_200.mat']);
            fps = 1000;
        elseif length(stim)>11500 && length(stim)<13500
            
            load([folder_path 'analysis\reference_stim\20_1200_200.mat']);
            fps = 1200;
        end
        
    case 25
        num_cycles = 250;
        if length(stim)>9500 && length(stim)<11500
            load([folder_path 'analysis\reference_stim\25_1000_250.mat']);
            fps = 1000;
        elseif length(stim)>11500 && length(stim)<13500
            load([folder_path 'analysis\reference_stim\25_1200_250.mat']);
            fps = 1200;
        end
        
    case 51
        num_cycles = 51;
        fps = 800;
        load([folder_path 'analysis\reference_stim\chirp_800.mat']);
        
end

ref_stim = x - mean(x);

[s,r,d] = alignsignals(ref_stim, stim(:,3));

aligned_stim = stim(d+1:d+length(ref_stim),:);

aligned_resp = resp(d+1:d+length(ref_stim),:);


% For 1000fps horsefly_2016 vids: trim ramped sinewave from high freq signals (first and last 2s)
if stim_freq >= 12 && stim_freq <30
    twoSec = fps*2;
    aligned_resp = aligned_resp(twoSec+1:end-twoSec,:);
    aligned_stim = aligned_stim(twoSec+1:end-twoSec,:);
    ref_stim = x(twoSec+1:end-twoSec);
    
end

% try to get rid of offset resulting from starting vid analysis at non-zero angle
for arIdx = 1:3
    aligned_resp(:,arIdx) = aligned_resp(:,arIdx) -  mean(aligned_resp(:,arIdx));
    aligned_stim(:,arIdx) = aligned_stim(:,arIdx) - mean(aligned_stim(:,arIdx));
end


% if stim_freq >= 12 && stim_freq <30
    % lots of errors so just use the reference stim trace
        
        if xcorr(aligned_stim(:,3)',ref_stim,0) < 0
            %ref_stim = -ref_stim;
            aligned_resp(:,1:3) = -aligned_resp(:,1:3);
            aligned_stim(:,1:3) = -aligned_stim(:,1:3);
           
            %{
            figure
            hold on
            plot(ref_stim,'r')
            plot(actual_stim,'b')
            plot(aligned_resp(:,3),'k')
            %}
        end
       
        
        
            amp =  round((max(aligned_stim(2:end-1,3)) - min(aligned_stim(2:end-1,3))) /2);
            if amp > 30
                for arIdx = 1:3
                    aligned_resp(:,arIdx) = aligned_resp(:,arIdx).*30./amp;
                    aligned_stim(:,arIdx) = aligned_stim(:,arIdx).*30./amp;
                end
            end
            if min(aligned_stim(:,4)) == 0
                aligned_stim(:,3) = ref_stim;
            end
            amp =  round((max(aligned_stim(2:end-1,3)) - min(aligned_stim(2:end-1,3))) /2);
            if amp > 30
                for arIdx = 1:3
                    aligned_resp(:,arIdx) = aligned_resp(:,arIdx).*30./amp;
                    aligned_stim(:,arIdx) = aligned_stim(:,arIdx).*30./amp;
                end
            end

%         aligned_stim = ref_stim;
%         ref_stim = actual_stim;
        
      
    
% 
% else
%     aligned_stim = aligned_stim(:,3);    
% end
% 
actual_stim =  aligned_stim(:,3);    

if plot_flag == 1
    %   Plots
    figure('units','normalized','outerposition',[0 0 1 1]);
    
    % reference and current stim
    subplot(4,2,1:2)
    title('stim & refstim')
    plot(x),hold on,plot(stim(:,3),'r'), plot(d,0,'*')
    
    % newly aligned stim and ref together
    subplot(4,2,3:4)
    title('shifted stim & ref')
    if stim_freq >= 12 && stim_freq <30,
        stimshift = 2000;
        cla,plot(aligned_stim,'r'), hold on, plot(actual_stim,'k:','LineWidth',1.2)
    else
        stimshift =0 ;    
        plot(circshift(aligned_stim,[stimshift,0]),'r'), hold on, plot(ref_stim,'k:')

    end
    
    % newly aligned resp and stim together
    subplot(4,2,5:6)
    title('shifted res, shifted stim')
    plot(aligned_stim), hold on, plot(aligned_resp(:,3),'r')
    
    % first 200 samples of both (stim should start @0deg amp)
    subplot(4,2,7)
    plot(aligned_stim(1:200)), hold on, plot(aligned_resp(1:200,3),'r')
    
    % last 200 samples of both
    subplot(4,2,8)
    plot(aligned_stim(end-200:end)), hold on, plot(aligned_resp(end-200:end,3),'r')
    
    pause
    
    close(gcf)
end
end

