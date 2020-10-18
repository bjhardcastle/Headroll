%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
% Robbers2012_main.m                                    %
%                                                       %
% Main script for analysis of headroll behaviour data   %
% acquired by Ben & Isuru in 2012 (ocellar contribution)
%
%                                                       %
% @author   das207@ic.ac.uk                             %
% @created  120402                                      %
% @modified Sep2012
% @modified for c3 and c4 Nov 1 2012
% @ heavily modified, incl circshift method for calc gain phase
% June 2016
% re-modified for all conditions, with changes to calc gain phase,
% and individual flight periods, May/June2013
% C3 halteres intact, CE + O
% C4 halteres intact, CE only

clc,


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Which operations to do
recalculate = 1;                % calc gain and phase data
% analyse flight sequences = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if recalculate == 1
    
    clear all
    
    flying = 1;
    
    
    % Data parameters
    load flightdata_c1_c4.mat
    allflies{1} = [8:15,17];           % C1, C2   ocelli/no ocelli (no halteres)
    allflies{2} = [18,19,21:22,24:29]; % C3, C4   ocelli/no ocelli (w halteres)
    freqs = [1.00,3.003,6.006,10.01];  % exact stimulation frequencies
    amps = [30];                       % stimulation amplitudes
    conds = [1,2,3,4];                 % "names" of conditions
    framerates = [500,500,500,500];    % camera rates used for each of the freqs
    
    % Preprocessing parameters
    clean_runs = 5;                  % number of interpolation runs on raw data
    tol = 950;                       % score below which interpolation is run
    sig_filter = [1 2 4 2 1]/10;     % smoothing filter
    
    
    % Strings in input filenames
    
    datapath = '.\data\';
    p1 = 'fly';                    % Prefix of flynumber in path
    p2 = '\';
    f1 = 'Hz_';                    % Prefix of stimfreq in filename
    f2 = 'deg_C001H001S000';       % Prefix of stimamplitude in filename
    
    repeats = 3;                    % Max number of video repeats
    
    % Initialize result arrays
    
    num_flies = length(allflies{1}) + length(allflies{2});
    num_freqs = length(freqs);
    num_amps = length(amps);
    num_conds = length(conds);
    
    resp_gain_mean = nan(2,num_flies,num_freqs,num_amps,num_conds);
    resp_phase_mean = nan(2,num_flies,num_freqs,num_amps,num_conds);
    resp_gain_std = nan(2,num_flies,num_freqs,num_amps,num_conds);
    resp_phase_std = nan(2,num_flies,num_freqs,num_amps,num_conds);
    
    offset_mean = zeros(2,num_flies,num_freqs,num_amps,num_conds);
    offset_std = zeros(2,num_flies,num_freqs,num_amps,num_conds);
    
    
    
    % Start analysis
    for group = 1:2                      % group 1 or 2 = allflies{1 or 2}
        
        for cond_nr = 1:num_conds
            
            flies = allflies{group};
            cond = conds(cond_nr);
            
            for fly_nr = 1:length(flies)
                
                fly = flies(fly_nr);
                resp_path = [datapath,p1,int2str(fly),p2]; % path of mat-files
                stim_path = [datapath,p1,int2str(fly),p2]; % path of mat-files
                
                for freq_nr = 1:num_freqs
                    
                    freq = freqs(freq_nr);
                    Fs = framerates(freq_nr);
                    stimfreq = freq;
                    
                    for amp_nr = 1:num_amps;
                        
                        amp = amps(amp_nr);
                        
                        for repeat = 1:repeats
                            
                            partial_resp_gain_mean = [];
                            
                            resp_file =['fly',int2str(fly),'_C',int2str(cond),'_',int2str(freq),f1,int2str(amp),f2,int2str(repeat),'resp.mat'];
                            
                            if exist([resp_path,resp_file],'file')
                                
                                load([resp_path,resp_file]); % load response data (in 'data')
                                clean_up;                    % Clean up response data
                                dataresp = data;
                                
                                stim_file = ['fly',int2str(fly),'_C',int2str(cond),'_',int2str(freq),f1,int2str(amp),f2,int2str(repeat),'stim.mat'];
                                load([stim_path,stim_file]); % load stimulus data (in 'data')
                                datastim = data;
                                
                                flight_times=flightdata{fly,freq_nr,amp_nr,cond_nr,repeat};
                                % fly number 1:29,  freq_nr 1:4,  amp_nr 1,  cond_nr 1:4,  repeat 1:3
                                flight_times=flight_times(find(flight_times));
                                
                                % gets frame numbers for start/ stop flying
                                
                                
                                
                                if isempty(flight_times)
                                    numflights = 1;
                                else
                                    numflights = 0.5*length(flight_times);
                                end
                                
%                                 disp(resp_file)
                                
                                
                                
                                for flight=1:numflights
                                    
                                    if flying == 1
                                        if isempty(flight_times)
                                            fstart=1;
                                            fstop=length(dataresp);
                                        else
                                            fstart=flight_times(flight*2-1);
                                            fstop=flight_times(flight*2);
                                        end
                                        
                                    elseif flying == 0
                                        
                                        if isempty(flight_times)
                                            partial_resp_gain_mean = NaN;
                                            partial_resp_phase_mean = NaN;
                                            continue
                                            
                                        elseif flight == 1
                                            if flight_times(1) >= Fs/stimfreq
                                                % skip the first  flight
                                                % (frame 1 : flight_times(1)
                                                % unless it's longer than 1 s
                                                fstart = 1;
                                                fstop = flight_times(1);
                                            elseif flight < 0.5*length(flight_times),
                                                fstart = flight_times(flight*2);
                                                fstop = flight_times(flight*2+1);
                                            else
                                                partial_resp_gain_mean = NaN;
                                                partial_resp_phase_mean = NaN;
                                                continue
                                            end
                                            
                                        elseif flight < 0.5*length(flight_times),
                                            fstart = flight_times(flight*2);
                                            fstop = flight_times(flight*2+1);
                                            
                                        elseif flight_times(flight) == length(dataresp),
                                            continue
                                            
                                        elseif   flight == length(flight_times)*0.5 && flight_times(flight*2) ~= 0 && ((length(resp) - flight_times(flight*2)) > Fs/stimfreq); 
                                            fstart = flight_times(flight*2);
                                            fstop = length(dataresp);
                                        else
                                            continue
                                         end
                                    end
                                    
                                    
                                    time = dataresp(fstart:fstop,6)/Fs; % Create time vector
                                    resp = datastim(fstart:fstop,3)' - 1.15*dataresp(fstart:fstop,3)';   % Extract relative response timeseries ( zero amplitude = no compensation )
                                    resp = 1.15*dataresp(fstart:fstop,3)'; % Correction applied for camera perspective;   % Extract relative response timeseries ( zero amplitude = no compensation )
%                                     resp = dataresp(fstart:fstop,3)'; % Correction applied for camera perspective;   % Extract relative response timeseries ( zero amplitude = no compensation )
                                    stim = datastim(fstart:fstop,3)';
                                    
                                    % ENABLE FRO VELOCITY 
                                    
%                                     stim = conv(stim,[1 -1])*Fs;
%                                     stim(end) = []; stim(1) = [];
%                                     resp = conv(resp,[1 -1])*Fs;
%                                     resp(end) = []; resp(1) = [];
                                    % work out relative resp within
                                    % calc_gp_circ
                                    calc_gain_phase_circ;            % Do xcorr analysis
                                    
                                    
                                    %  for each fly plot individual traces:
%                                    figure, plot(time,stim,time,resp), title(['fly ',num2str(fly),', freq ',num2str(freq),', flight ',num2str(flight),' repeat ',num2str(repeat),', gain ',num2str(CL_gain),''])
                                    

%                                         resp = datastim(fstart:fstop,3)' - 1.15*dataresp(fstart:fstop,3)';   % Extract relative response timeseries ( zero amplitude = no compensation )
%                                         resp = conv(resp,[1 -1])*Fs;
%                                         resp(end) = []; resp(1) = [];
                                        calc_gain_phase_circ
                                        partial_resp_gain_mean(flight) = CL_gain;
                                        partial_resp_gain_std(flight) = CL_gain_std;
                                        partial_offset_mean(flight) = CL_offset;
                                        partial_offset_std(flight) = CL_offset_std;
                                        partial_resp_phase_mean(flight) = CL_phase;
                                        partial_resp_phase_std(flight) = CL_phase_std;


                                    allfly_traces{group,fly_nr,freq_nr,amp_nr,cond_nr,flight}=CL_gain;
                                    allfly_phase{group,fly_nr,freq_nr,amp_nr,cond_nr,flight}=CL_phase;
                                    
                                    
                                    
                                end
                            end
                            
                            if repeat ~=1                       %
%                                 partial_resp_gain_mean
                                resp_gain_mean(group,fly_nr,freq_nr,amp_nr,cond_nr) = nanmean([resp_gain_mean(group,fly_nr,freq_nr,amp_nr,cond_nr) nanmean(partial_resp_gain_mean) ]);
%                                 resp_gain_mean(group,fly_nr,freq_nr,amp_nr,cond_nr)
                                resp_phase_mean(group,fly_nr,freq_nr,amp_nr,cond_nr) = nanmean([resp_phase_mean(group,fly_nr,freq_nr,amp_nr,cond_nr)  nanmean(partial_resp_phase_mean) ]);
                            else
                                resp_gain_mean(group,fly_nr,freq_nr,amp_nr,cond_nr) = nanmean(partial_resp_gain_mean);
                                resp_phase_mean(group,fly_nr,freq_nr,amp_nr,cond_nr) = nanmean(partial_resp_phase_mean);
                            end
                        end
                    end
                end
            end
        end
    end
    
    
    assignin('base','gains',allfly_traces);
    assignin('base','phase',allfly_phase);
    assignin('base','resp_gain_mean',resp_gain_mean);
    assignin('base','resp_phase_mean',resp_phase_mean);
    
    save('DATA_RF_gain_phase.mat','resp_gain_mean','resp_phase_mean','gains','phase','freqs');
else
    load DATA_RF_gain_phase.mat
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load DATA_RF_gain_phase.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Plot C1 vs C2 (without halteres)


%GAIN
figure

figa1 = subplot(2,1,1);

%%plot c1 flies
for n = 1:4,
    for f = 1:9,
        
        ta1(n,f) = resp_gain_mean(1,f,n,1,1);
        
    end
    st1(n) = nanstd(ta1(n,:))/sqrt(9);
end
h1 = errorbar(round(freqs),nanmean(ta1,2),st1);
set(h1,'LineWidth', 2.5);
hold on

%%plot c2 flies
for n = 1:4,
    for f = 1:9,
        
        ta2(n,f) = resp_gain_mean(1,f,n,1,2);
        
    end
    st2(n) = nanstd(ta2(n,:))/sqrt(9);
end
h2 = errorbar(round(freqs),nanmean(ta2,2),st2);
set(h2,'LineWidth', 2.5);
hold on



title(['Gain and phase of closed-loop head roll response, N = 9, stimulus amplitude 30°'],'fontsize',12)
ylabel('Gain [linear units]','FontSize',12)
set(figa1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
axis([0 11 0 0.7])
% legend('Compound eyes + ocelli','Compound eyes','Location','NorthEast')



%PHASE
figa2 = subplot(2,1,2);

%%plot c1 flies
for n = 1:4,
    for f = 1:9,
        tb1(n,f) = resp_phase_mean(1,f,n,1,1);
    end
    pt1(n) = nanstd(tb1(n,:))/sqrt(9);
end
p1 = errorbar(round(freqs),nanmean(tb1,2),pt1);
set(p1,'LineWidth', 2.5);
hold on

%%plot c2 flies
for n = 1:4,
    for f = 1:9,
        tb2(n,f) = resp_phase_mean(1,f,n,1,2);
    end
    pt2(n) = std(tb2(n,:))/sqrt(9);
end
p2 = errorbar(round(freqs),nanmean(tb2,2),pt2);
set(p2,'LineWidth', 2.5);
hold on

ylabel('Phase [°]','FontSize',12)
xlabel('Frequency [Hz]','FontSize',12)
set(figa2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 -50 10])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot C3 vs C4 (conditions with halteres)


%GAIN

figa1,
hold on

subplot(2,1,1);
%plot c3 flies
for n = 1:4,
    for f = 1:9,
        
        ta3(n,f) = resp_gain_mean(2,f,n,1,3);
    end
    st3(n) = nanstd(ta3(n,:))/sqrt(9);
end
h3 = errorbar(round(freqs),nanmean(ta3,2),st3);
set(h3,'LineWidth', 2.5);
hold on

%%plot c4 flies
for n = 1:4,
    for f = 1:10,
        
        ta4(n,f) =  resp_gain_mean(2,f,n,1,4);
        
    end
    st4(n) = nanstd(ta4(n,:))/sqrt(10);
end
h4 = errorbar(round(freqs),nanmean(ta4,2),st4);
set(h4,'LineWidth', 2.5);
hold on


title(['Gain and phase of closed-loop head roll response, N = 9, stimulus amplitude 30°'],'FontSize',12)
ylabel('Gain [linear units]','FontSize',12)
% set(figb1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 0 0.7])


%PHASE

figa2
subplot(2,1,2);
%plot c3 flies
for n = 1:4,
    for f = 1:9,
        tb3(n,f) = resp_phase_mean(2,f,n,1,3);
    end
    pt3(n) = nanstd(tb3(n,:))/sqrt(9);
end
p3 = errorbar(round(freqs),nanmean(tb3,2),pt3);
set(p3,'LineWidth', 2.5);
hold on

%%plot c4 flies
for n = 1:4,
    for f = 1:9,
        tb4(n,f) = resp_phase_mean(2,f,n,1,4);
    end
    pt4(n) = nanstd(tb4(n,:))/sqrt(10);
end
p4 = errorbar(round(freqs),nanmean(tb4,2),pt4);
set(p4,'LineWidth', 2.5);
hold on


ylabel('Phase [°]','FontSize',12)
xlabel('Frequency [Hz]','FontSize',12)
% set(figb2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 -50 10])
legend('Compound eyes + ocelli','Compound eyes','Halteres + compound eyes + ocelli', 'Halteres + compound eyes','Location','SouthEast')


%%
% robber
% 
% %GAIN
% figure
% 
% figa1 = subplot(2,1,1);
% 
% %%plot c1 flies
% for n = 1:4,
%     for f = 1:9,
%         
%         ta1(n,f) = 1 - resp_gain_mean(1,f,n,1,1);
%         
%     end
%     st1(n) = nanstd(ta1(n,:))/sqrt(9);
% end
% h1 = errorbar(round(freqs),nanmean(ta1,2),st1,'b');
% set(h1,'LineWidth', 2.5);
% hold on
% 
% %%plot c2 flies
% for n = 1:4,
%     for f = 1:9,
%         
%         ta2(n,f) = 1 - resp_gain_mean(1,f,n,1,2);
%         
%     end
%     st2(n) = nanstd(ta2(n,:))/sqrt(9);
% end
% h2 = errorbar(round(freqs),nanmean(ta2,2),st2,'r');
% set(h2,'LineWidth', 2.5);
% hold on
% 
% 
% 
% title(['1 - Gain and phase of closed-loop head roll response, N = 9, stimulus amplitude 30°'],'fontsize',12)
% ylabel(' 1- Gain [linear units]','FontSize',12)
% set(figa1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 0 0.7])
% legend('Compound eyes + ocelli','Compound eyes','Location','NorthEast')
% 
% 
% 
% %PHASE
% figa2 = subplot(2,1,2);
% 
% %%plot c1 flies
% for n = 1:4,
%     for f = 1:9,
%         tb1(n,f) = resp_phase_mean(1,f,n,1,1);
%     end
%     pt1(n) = nanstd(tb1(n,:))/sqrt(9);
% end
% p1 = errorbar(round(freqs),nanmean(tb1,2),pt1,'b');
% set(p1,'LineWidth', 2.5);
% hold on
% 
% %%plot c2 flies
% for n = 1:4,
%     for f = 1:9,
%         tb2(n,f) = resp_phase_mean(1,f,n,1,2);
%     end
%     pt2(n) = std(tb2(n,:))/sqrt(9);
% end
% p2 = errorbar(round(freqs),nanmean(tb2,2),pt2,'r');
% set(p2,'LineWidth', 2.5);
% hold on
% 
% ylabel('Phase [°]','FontSize',12)
% xlabel('Frequency [Hz]','FontSize',12)
% set(figa2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% % axis([0 11 -50 10])
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% Plot C3 vs C4 (conditions with halteres)
% 
% figure
% 
% %GAIN
% 
% figb1 = subplot(2,1,1);
% %plot c3 flies
% for n = 1:4,
%     for f = 1:9,
%         
%         ta3(n,f) = 1 - resp_gain_mean(2,f,n,1,3);
%     end
%     st3(n) = nanstd(ta3(n,:))/sqrt(9);
% end
% h3 = errorbar(round(freqs),nanmean(ta3,2),st3,'b');
% set(h3,'LineWidth', 2.5);
% hold on
% 
% %%plot c4 flies
% for n = 1:4,
%     for f = 1:10,
%         
%         ta4(n,f) = 1 - resp_gain_mean(2,f,n,1,4);
%         
%     end
%     st4(n) = nanstd(ta4(n,:))/sqrt(10);
% end
% h4 = errorbar(round(freqs),nanmean(ta4,2),st4,'r');
% set(h4,'LineWidth', 2.5);
% hold on
% 
% 
% title([' 1- Gain and phase of closed-loop head roll response, N = 9, stimulus amplitude 30°'],'FontSize',12)
% ylabel(' 1 - Gain [linear units]','FontSize',12)
% set(figb1,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% axis([0 11 0 0.7])
% 
% 
% %PHASE
% 
% figb2 = subplot(2,1,2);
% %plot c3 flies
% for n = 1:4,
%     for f = 1:9,
%         tb3(n,f) = resp_phase_mean(2,f,n,1,3);
%     end
%     pt3(n) = nanstd(tb3(n,:))/sqrt(9);
% end
% p3 = errorbar(round(freqs),nanmean(tb3,2),pt3,'b');
% set(p3,'LineWidth', 2.5);
% hold on
% 
% %%plot c4 flies
% for n = 1:4,
%     for f = 1:9,
%         tb4(n,f) = resp_phase_mean(2,f,n,1,4);
%     end
%     pt4(n) = nanstd(tb4(n,:))/sqrt(10);
% end
% p4 = errorbar(round(freqs),nanmean(tb4,2),pt4,'r');
% set(p4,'LineWidth', 2.5);
% hold on
% 
% 
% ylabel('Phase [°]','FontSize',12)
% xlabel('Frequency [Hz]','FontSize',12)
% set(figb2,'XTick',[1,3,6,10],'XTickLabel',{'1','3','6','10'},'fontsize',12)
% % axis([0 11 -50 10])
% legend('Halteres + compound eyes + ocelli', 'Halteres + compound eyes','Location','SouthEast')
% 
% 
