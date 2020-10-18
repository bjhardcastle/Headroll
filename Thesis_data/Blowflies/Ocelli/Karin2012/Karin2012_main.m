%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% Karin2012_main.m                                    %
%                                                     %
% Main script for analysis of headroll behaviour data %
% acquired by Karin in 2012 (ocellar contribution)    %
%                                                     %
% @author   das207@ic.ac.uk                           %
% @created  120402                                    %
% @modified 120407                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all;

 % Reanalyse raw data?
 RECALC_FLAG = 1
 
% Data parameteres

flies = 2:9;                     % "names" of flies to be included
freqs = [1,3.003,6.006,10.01];   % exact stimulation frequencies
amps = [10,20,30];               % stimulation amplitudes
conds = [1,2];                   % "names" of conditions
framerates = [250,500,500,500];  % camera rates used for each of the freqs


% Preprocessing parameters

clean_runs = 3;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             


% Which plots to plot

plot_cycles = 0;                % Display individual cycles (1 amplitude)
plot_ind = 0;                   % Plot individual flies in Bode plots


% Strings in input filenames

p1 = 'Exp_Ocelli\fly';          % Prefix of flynumber in path
p2 = '\fly';                    % ...
p3 = '_matlabfiles\';           % Suffix of flynumber in path

f1 = 'Hz_';                     % Prefix of stimfreq in filename
f2 = 'deg_C001H001S0001';       % Prefix of stimamplitude in filename


% Initialize result arrays

num_flies = length(flies);
num_freqs = length(freqs);
num_amps = length(amps);
num_conds = length(conds);
 
resp_gain_mean = zeros(num_flies,num_freqs,num_amps,num_conds);
resp_phase_mean = zeros(num_flies,num_freqs,num_amps,num_conds);
resp_gain_std = zeros(num_flies,num_freqs,num_amps,num_conds);
resp_phase_std = zeros(num_flies,num_freqs,num_amps,num_conds);

offset_mean = zeros(num_flies,num_freqs,num_amps,num_conds);
offset_std = zeros(num_flies,num_freqs,num_amps,num_conds);



% Start analysis
%resp_traces_mean = {[],[],[],[],[]};
%stim_traces_mean = {[],[],[],[],[]};
%time_save ={[],[],[],[],[]};
 
if RECALC_FLAG
    
for fly_nr = 1:num_flies
    
    fly = flies(fly_nr);
    resp_path = [p1,int2str(fly),p2,int2str(fly),p3]; % path of mat-files
    stim_path = [p1,int2str(2),p2,int2str(2),p3]; % path of mat-files
    
    for freq_nr = 1:num_freqs
        
        freq = freqs(freq_nr);
        
        for amp_nr = 1:num_amps
            
            amp = amps(amp_nr);    
            
            stim_file =[int2str(freq),f1,int2str(amp),f2,'stim.mat'];
            load([stim_path,stim_file]); % load stimulus data (in 'data')
            datastim = data;
            stim = datastim(:,3)';       % Extract stimulus timeseries
            
            
            for cond_nr = 1:num_conds
                
                cond = conds(cond_nr);
                
                resp_file =['fly',int2str(fly),'_C',int2str(cond),'_',int2str(freq),f1,int2str(amp),f2,'resp.mat'];
                load([resp_path,resp_file]); % load response data (in 'data')
                
% figure
% subplot(2,1,1)
% plot(data(:,3))
% hold on
% title(resp_file)
% subplot(2,1,2)
% plot(data(:,4))
                
                clean_up;                    % Clean up response data
             
% hold on,
% subplot(2,1,1)
% plot(data(:,3),'r')
% hold on, plot(stim,'k')
% subplot(2,1,2)
% plot(data(:,4),'r')
% 
% pause
% close all



                dataresp = data;
                
                Fs = framerates(freq_nr);    
                
                stimfreq = freq;
                
                
                time = dataresp(:,6)/Fs; % Create time vector
                resp = dataresp(:,3)';   % Extract response timeseries
                
                all_r(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=resp-mean(resp);       % every full length response trace
                all_s(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=stim-mean(stim);
                all_t(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=time;
                
                calc_gain_phase;            % Do xcorr analysis
                
                resp_gain_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain;
                resp_phase_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase;
                resp_gain_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain_std;
                resp_phase_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase_std;
                
                offset_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_offset;
                offset_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_offset_std;
                
                  calc_avcycle;               % Extract individual cycles
                    

                    rtmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=mean(resp_traces);    %mean of all cycles, in struct format
                    stmmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=mean(stim_traces);
                    tmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=time;
                    
                    all_resp_cycles(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:,:) = resp_traces;       %every cycle, in struct format
                    all_stim_cycles(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:,:) = stim_traces;

                    
                    resp_traces_mean{fly_nr,freq_nr,amp_nr,cond_nr}=mean(resp_traces);      %mean of all cycles, in cell format
                    stim_traces_mean{fly_nr,freq_nr,amp_nr,cond_nr}=mean(stim_traces);
                    time_save{:,fly_nr,freq_nr,amp_nr,cond_nr}=time;

                if plot_cycles
                
                    figure(flies(fly_nr)*10+conds(cond_nr)+5)
                    plot_avcycle;               % Plot all cycles
                  %  figure(flies(fly_nr)*100+conds(cond_nr)*10+amps(amp_nr))
                  % plot_scatter                % Plots a point for each cycle in a scatter Bode plot
                    
                end

                
            end
        end
    end
end


    save('TKarin2012data.mat')
else 
    load('TKarin2012data.mat')
end
   

% Plot Bode plot for each condition/amplitude combo


for cond_nr = 1:num_conds
    for amp_nr = 1:num_amps
        
        CLg=squeeze(resp_gain_mean(:,:,amp_nr,cond_nr));
        CLgm=mean(CLg,1);
        CLgs = std(CLg,1);
        
        CLp=squeeze(resp_phase_mean(:,:,amp_nr,cond_nr));
        CLpm=mean(CLp,1);
        CLps = std(CLp,1);
        
%         figure(cond_nr*10+amp_nr)
         figure(10+amp_nr)
        subplot(2,1,1)
                hold on

        
        h = errorbar(freqs,CLgm,CLgs);
        set(h, 'LineWidth', 2);
 
        if plot_ind
            hold on
            plot(freqs,CLg,'.')
            hold off            
        end
        
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain (linear units)')
        axis([0 11 0 0.5])
        
        subplot(2,1,2)
        hold on
        h = errorbar(freqs,CLpm,CLps);
        set(h, 'LineWidth', 2);
        if plot_ind
            hold on
            plot(freqs,CLp,'.')
            hold off
        end
        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -100 20])
    end
end


% Plot comparison bode plots C1 vs. C2 for each amplitude


for amp_nr = 1:num_amps
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        CLgm1 = mean(CLg1,1);
        CLgs1 = std(CLg1,1);
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        CLpm1 = mean(CLp1,1);
        CLps1 = std(CLp1,1);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        CLgm2 = mean(CLg2,1);
        CLgs2 = std(CLg2,1);
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        CLpm2 = mean(CLp2,1);
        CLps2 = std(CLp2,1);
        
        figure(amp_nr)
        
        subplot(2,1,1)
        
        
        h1 = errorbar(freqs,CLgm1,CLgs1);
        set(h1, 'LineWidth', 2);
        set(h1, 'Color', 'b');
        hold on
        
        h2 = errorbar(freqs,CLgm2,CLgs2);
        set(h2, 'LineWidth', 2);
        set(h2, 'Color', 'r');
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain (linear units)')
        axis([0 11 0 0.5])
        legend('C1','C2')
        hold off
        
        subplot(2,1,2)
        h3 = errorbar(freqs,CLpm1,CLps1);
        set(h3, 'LineWidth', 2);
        set(h3, 'Color', 'b');
        hold on
        
        h4 = errorbar(freqs,CLpm2,CLps2);
        set(h4, 'LineWidth', 2);
        set(h4, 'Color', 'r');        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -100 20])
        hold off
end


% Plot offest means and variances for condition and amplitude



for amp_nr = 1:num_amps
        
        offsets = squeeze(offset_mean(:,:,amp_nr,1));
        offm1 = mean(offsets,1);
        offs1 = std(offsets,1)/sqrt(num_flies);
        
        offstds = squeeze(offset_std(:,:,amp_nr,1));
        ostdm1 = mean(offstds,1)./offm1;
        ostds1 = (std(offstds,1)./offm1)/sqrt(num_flies);
        
        
        
        offsets = squeeze(offset_mean(:,:,amp_nr,2));
        offm2 = mean(offsets,1);
        offs2 = std(offsets,1)/sqrt(num_flies);
        
        offstds = squeeze(offset_std(:,:,amp_nr,2));
        ostdm2 = mean(offstds,1)./offm2;
        ostds2 = (std(offstds,1)./offm2)/sqrt(num_flies);        
        
        figure(amp_nr*10)
        
        subplot(2,1,1)
        
        
        h11 = errorbar(freqs,offm1,offs1);
        set(h11, 'LineWidth', 2);
        hold on
        h12 = errorbar(freqs,offm2,offs2);
        set(h12, 'LineWidth', 2, 'Color', 'r');
        hold off
        
        legend('C1','C2')
        title(['Offset analysis,' ,int2str(amps(amp_nr)),'° Amplitude (N=8, ±SEM)'])
        ylabel('Mean offset')
        axis([0 11 0 10])
        
        
        subplot(2,1,2)
        h13 = errorbar(freqs,ostdm1,ostds1);
        set(h13, 'LineWidth', 2);
        hold on
        h14 = errorbar(freqs,ostdm2,ostds2);
        set(h14, 'LineWidth', 2, 'Color', 'r');        
        hold off
        
        ylabel('Mean intra-individual varibility')
        xlabel('Frequency (Hz)')
        axis([0 11 0.5 1.5])
end


% Calculate and plot CE and O pathway frequency responses
% Caution, we here operate with the means of the estimated closed-lopp
% freqeuncy responses!

for amp_nr = 1:num_amps
        
        CLg1  = squeeze(resp_gain_mean(:,:,amp_nr,1));
        C1gain = CLg1;
        
        CLp1  = squeeze(resp_phase_mean(:,:,amp_nr,1));
        C1phase = CLp1;
        
        C1 = C1gain.*exp(1i*C1phase*pi/180);
        
        CLg2  = squeeze(resp_gain_mean(:,:,amp_nr,2));
        C2gain = CLg2;
        
        CLp2  = squeeze(resp_phase_mean(:,:,amp_nr,2));
        C2phase = CLp2;
        
        C2 = C2gain.*exp(1i*C2phase*pi/180);
        
        CE = C2./(1-C2);
        CEgain = abs(CE);
        CEphase = angle(CE)*180/pi;
                
        OC = - ( C1./(1-C1)-CE);
        OCgain = abs(OC);
        OCphase = angle(OC)*180/pi;
        
        figure(amp_nr)
        
        subplot(2,1,1)
        
%         OCphase = OCphase - (OCphase>0)*360;
%         CEphase = CEphase - (CEphase>0)*360;
        
        h1 = plot(freqs,CEgain,'.');
        set(h1, 'MarkerSize', 10);
        set(h1, 'Color', 'b');
        hold on
        
        h2 = plot(freqs,OCgain,'.');
        set(h2, 'MarkerSize', 10);
        set(h2, 'Color', 'r');
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),'°'])
        ylabel('Gain (linear units)')
        %axis([0 11 0 0.5])
        legend('CE','OC')
        hold off
        
        subplot(2,1,2)
        h3 = plot(freqs,CEphase,'.');
        set(h3, 'MarkerSize', 10);
        set(h3, 'Color', 'b');
        hold on
        
        h4 = plot(freqs,OCphase,'.');
        set(h4, 'MarkerSize', 10);
        set(h4, 'Color', 'r');        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -360 20])
        hold off
end


