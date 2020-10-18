% Hoverfly roll stabilisation analysis

plot_cycles = 0;
% Currently plots individual cycles with mean subtracted off

flies = [10,11,12];
conds = [1];
repeats = 1;
amps = 40;
freqs = [0.01,0.03,0.06,0.1,0.3,0.6,1,3,6,10,15,20];
framerates = [50,50,50,50,60,500,250,500,500,1000,1000,1000];
% 0.6Hz excluded for now - different frame rates between trials/stim 
tol = 800;                       % score below which interpolation is run
clean_runs = 3;


abspath = 'C:\Users\Ben\Dropbox\Work\Karin2014_hoverflies\';
resp_folder = 'sorted\';
p1 = 'fly';                     %prefix to fly folder name
stim_folder = 'stimuli\';


% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

clear headroll;

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);

    for cidx = 1:length(conds)
        cidx;
        data_path = [project_path,fly_path,num2str(fly),'\'];
        
        for freqidx = 1:length(freqs),
            freq = freqs(freqidx);
            Fs = fps(freqidx);
            
            for trialidx = 1;
                
                   
                resp_fname = ['',num2str(freqidx),'Hz.mat'];
                
                if exist([data_path resp_fname])
                    
                    load([data_path,resp_fname]);
                    resp_data = data;
                    
                    if length(stim_data)-length(resp_data) ~= 0
                        
                        sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                        sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                        
                    else
                        
                        % Get reference stim and aligned response data
                        [stim,data,Fs] = et_remove_prestim(resp_data,freqs(freqidx),1);
                        
                        stimfreq = freq;
                        stim = stim_data(:,3)-mean(stim_data(:,3));
                        stim = smooth(stim,8);

                        if resp_data(1,7) ~= stim_data(1,7)
                        
                        sprintf(['Different framerates: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                        sprintf(['Fs from resp_data: ',num2str(resp_data(1,7)),', Fs from stim_data: ',num2str(resp_data(1,7)),''])
                        
                        end
                        
                        % Clean resp data                       
                        clean_up;
                    
                        
                        % Remove baseline drift by filtering freqs <0.5Hz
%                         resp_DC = resp_data(:,3);
%                         dt_s = 1/Fs;
%                         f0_hz = 1/dt_s;
%                         fcut_hz = 50;
%                         [b,a] = butterhigh1(fcut_hz/f0_hz);
%                         resp_AC = filtfilt(b,a,resp_DC);
%                         % Find offset of response baseline
%                         os = mean(resp_AC);
%                         resp = resp_AC - os;
                        
                        
                        
                        % Thorax roll - head roll
                        rel_resp = stim - resp_data(:,3);
                        
                        
                        % Smooth response
                        rel_resp = smooth(rel_resp,8);
                        
%                         eval(strcat('headroll.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=rel_resp;'));
%                         eval(strcat('framerates.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=Fs;'));
                        
                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = rel_resp;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = Fs;
                        
                        resp = rel_resp';
                        stim = stim';
                       
                        calc_gain_phase;

%                         subplot(2,1,1)
%                         scatter([1:num_steps],gain)
%                         subplot(2,1,2)
%                         scatter([1:num_steps],phase)
%                         pause(1)
                                       
                        resp_gain_mean(flyidx,freqidx,trialidx,cidx) = CL_gain;
                        resp_phase_mean(flyidx,freqidx,trialidx,cidx) = CL_phase;
                        resp_gain_std(flyidx,freqidx,trialidx,cidx) = CL_gain_std;
                        resp_phase_std(flyidx,freqidx,trialidx,cidx) = CL_phase_std;
                        Fs_table(flyidx,freqidx,trialidx,cidx) = Fs;

                       

                        
                    end
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                    
                        resp_gain_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_phase_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;
                        Fs_table(flyidx,freqidx,trialidx,cidx) = NaN;

                end % If stim & resp files exist
            end
        end
    end
end
save(['DATA_et_fixed_sines.mat'],'headroll','framerates','flies','stimfreqs')
save('DATA_et_gain_phase.mat','resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std','Fs_table');





