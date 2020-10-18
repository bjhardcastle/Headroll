%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% Karin2012_main_C5C6.m                                %
%                                                     %
% Main script for analysis of headroll behaviour data %
% acquired by Karin in 2012 (ocellar contribution)    %
%                                                     %                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all;

% Data parameteres

flies = [18,19,21];                   % "names" of flies to be included
freqs = [1,3.003,6.006,10.01];   % 3.003, exact stimulation frequencies
amps = [30];               % stimulation amplitudes
conds = [5,6];                   % "names" of conditions
framerates = [500,500,500,500];  % camera rates used for each of the freqs


% Preprocessing parameters

clean_runs = 3;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             


% Which plots to plot

plot_cycles = 0;                % Display individual cycles (1 amplitude)
plot_ind = 1;                   % Plot individual flies in Bode plots


% Strings in input filenames

p1 = '.\data\fly';          % Prefix of flynumber in path
p2 = '\';                    % ...
p3 = '';           % Suffix of flynumber in path

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

% Load reference stim files (body fixed so no sting to measure)
load 'ref_stims_C5C6.mat'

% Start analysis

for fly_nr = 1:num_flies
    
    fly = flies(fly_nr)
    resp_path = [p1,int2str(fly),p2]; % path of mat-files
    %     Stims obtained from reference .mat
    %     stim_path = [p1,int2str(fly),p2,int2str(fly),p3]; % path of mat-files
    
    for freq_nr = 1:num_freqs
        
        freq = freqs(freq_nr);
        
        for amp_nr = 1:num_amps
            
            amp = amps(amp_nr);    
                                  
            
            for cond_nr = 1:num_conds
                
                cond = conds(cond_nr);
                
                datastim = ref_stim_traces(freq_nr).freqidx(1,:);       % Extract stimulus timeseries
                
                resp_file =['fly',int2str(fly),'_C',int2str(cond),'_',int2str(freq),f1,int2str(amp),f2,'resp.mat'];
                load([resp_path,resp_file]); % load response data (in 'data')
                
                
                clean_up;                    % Clean up response data
                dataresp = data;  
                resp = dataresp(:,3)';
                stim = datastim(1:length(resp));
              
                stimfreq = freq;
                
                Fs = framerates(freq_nr);    
                
                time = dataresp(:,6)/Fs; % Create time vector
               % resp = dataresp(:,3)';   % Extract response timeseries
%                 resp = - datastim(:,3)' + dataresp(:,3)';
                



                calc_gain_phase;            % Do xcorr analysis

                
                resp(length(dataresp)+1:length(datastim)) = NaN;
                stim(length(dataresp)+1:length(datastim)) = NaN;
                time(length(dataresp)+1:length(datastim)) = NaN;

                all_r(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=resp-nanmean(resp);       % every full length response trace
                all_s(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=stim-nanmean(stim);
                all_t(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=time;

                
                resp_gain_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain;
                resp_phase_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase;
                resp_gain_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain_std;
                resp_phase_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase_std;
                
                offset_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_offset;
                offset_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_offset_std;
                
                calc_avcycle;               % Extract individual cycles
                
                rtmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=nanmean(resp_traces);    %mean of all cycles, in struct format
                stmmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=nanmean(stim_traces);
                tmean(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:)=time;
                
                all_resp_cycles(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:,:) = resp_traces;       %every cycle, in struct format
                all_stim_cycles(freq_nr).a(amp_nr).c(cond_nr).animal(fly_nr,:,:) = stim_traces;
                
                
                resp_traces_mean{fly_nr,freq_nr,amp_nr,cond_nr}=nanmean(resp_traces);      %mean of all cycles, in cell format
                stim_traces_mean{fly_nr,freq_nr,amp_nr,cond_nr}=nanmean(stim_traces);
                time_save{:,fly_nr,freq_nr,amp_nr,cond_nr}=time;

                
                if plot_cycles
                
                    
                    figure(flies(fly_nr)*10+conds(cond_nr)+5)
                    plot_avcycle;               % Plot all cycles
                    
%                     figure(flies(fly_nr)*100+conds(cond_nr)*10+amps(amp_nr))
                    
%                     plot_scatter                % Plots a point for each cycle in a scatter Bode plot
%                     
                end

                
            end
        end
    end
end
save('TRobbers2012data.mat')
