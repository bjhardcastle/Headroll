%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% Karin2012_main.m                                    %
%                                                     %
% Main script for analysis of headroll behaviour data %
% acquired by Karin in 2012 (ocellar contribution)    %
%                                                     %
% @author   das207@ic.ac.uk                           %
% @created  120402                                    %
% @modified 120403                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;

% Data parameteres

flies = [2:9];                   % "names" of flies to be included
freqs = [1,3.003,6.006,10.01];   % exact stimulation frequencies
amps = [10,20,30];               % stimulation amplitudes
conds = [1,2];                   % "names" of conditions
framerates = [250,500,500,500];  % camera rates used for each of the freqs


% Preprocessing parameters

clean_runs = 20;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             


% Which plots to plot

plot_cycles = 0;                % Display individual cycles (1 amplitude)
plot_ind = 1;                   % Plot individual flies in Bode plots


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



% Start analysis

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
                
                clean_up;                    % Clean up response data
                dataresp = data;
                
                Fs = framerates(freq_nr);    
                
                stimfreq = freq;
                
                
                time = dataresp(:,6)/Fs; % Create time vector
                resp = dataresp(:,3)';   % Extract response timeseries
                
                calc_gain_phase;            % Do xcorr analysis
                
                resp_gain_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain;
                resp_phase_mean(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase;
                resp_gain_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_gain_std;
                resp_phase_std(fly_nr,freq_nr,amp_nr,cond_nr) = CL_phase_std;
                
                
                if plot_cycles
                    
                    [CL_gain,fly,freq,amp,cond]
                    
                    figure(flies(fly_nr)*10+conds(cond_nr)+5)
                    calc_avcycle;               % Extract individual cycles
                    plot_avcycle;               % Plot all cycles
                    
                    figure(flies(fly_nr)*100+conds(cond_nr)*10+amps(amp_nr))
                    
                    plot_scatter                % Plots a point for each cycle in a scatter Bode plot
                    
                end

                
            end
        end
    end
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
        
        figure(cond_nr*10+amp_nr)
        
        subplot(2,1,1)
        
        
        h = errorbar(freqs,CLgm,CLgs)
        set(h, 'LineWidth', 2);
 
        if plot_ind
            hold on
            plot(freqs,CLg,'.')
            hold off            
        end
        
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr)),' deg'])
        ylabel('Gain (linear units)')
        axis([0 11 0 0.5])
        
        subplot(2,1,2)
        h = errorbar(freqs,CLpm,CLps)
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
        
        h2 = errorbar(freqs,CLgm2,CLgs2)
        set(h2, 'LineWidth', 2);
        set(h2, 'Color', 'r');
        title(['Average all flies, Condition ',int2str(conds(cond_nr)),' and Amplitude ',int2str(amps(amp_nr))])
        ylabel('Gain (linear units)')
        axis([0 11 0 0.5])
        legend('C1','C2')
        hold off
        
        subplot(2,1,2)
        h3 = errorbar(freqs,CLpm1,CLps1)
        set(h3, 'LineWidth', 2);
        set(h3, 'Color', 'b');
        hold on
        
        h4 = errorbar(freqs,CLpm2,CLps2)
        set(h4, 'LineWidth', 2);
        set(h4, 'Color', 'r');        
        ylabel('Phase (degrees)')
        xlabel('Frequency (Hz)')
        axis([0 11 -100 20])
        legend('C1','C2')
        hold off
    end



