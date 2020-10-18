clear all


flies = [2:12,14];
stimfreqs = [0.011, 0.03, 0.1,0.3,  1 ,3.003, 6.006, 10.01, 15];   % exact stimulation frequencies
freqs = [0.011, 0.03, 0.1, 0.3, 1, 3, 6, 10, 15];
conds = [1,2,3,4];                   % "names" of conditions

project_path = 'C:\Users\bh608\Dropbox\Work\Nathalie2012\';
fly_path = '\Fly';
p2 = '\Stimulus\';                    % ...
p1 = '\Responce\';           % Suffix of flynumber in path
f1 = 'Hz_';                     % Prefix of stimfreq in filename
f2 = 'C001H001S0001';       % Prefix of stimamplitude in filename


% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 700;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter


clear headroll;

trialidx=1; % Fixed, only 1 trial
for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);

    for cidx = 1:4
        cidx;
        data_path = [project_path,'C',num2str(cidx),fly_path,num2str(fly)];
        
        for freqidx = 1:length(freqs),
            freq = freqs(freqidx);
            

            
            
            
                
                resp_fname = [p1,'Fly',num2str(fly),'_',num2str(freqs(freqidx)),'_40_C',num2str(cidx),'_',f2,'resp.mat'];
                stim_fname = [p2,'Fly',num2str(fly),'_',num2str(freqs(freqidx)),'_40_C',num2str(cidx),'_',f2,'stim.mat'];
                
                if exist([data_path resp_fname]) && exist([data_path stim_fname])
data_path, resp_fname
                    load([data_path,resp_fname]);
                    resp_data = data;
                    load([data_path,stim_fname]);
                    stim_data = data;
                    
                    if length(stim_data)-length(resp_data) ~= 0
                        
                        sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
                        sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                        
                    else
                        
%                         % Get reference stim and aligned response data
%                         [stim,data,Fs] = hf_remove_prestim(stim_data,resp_data,freqs(freqidx),0);
                        
                        stimfreq = freq;
                        stim = stim_data(:,3)-mean(stim_data(:,3));
                        stim = smooth(stim,8);
                        Fs = resp_data(1,7);
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
%                         fcut_hz = 1;
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


                        
                    end
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                    
                        resp_gain_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_phase_mean(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_gain_std(flyidx,freqidx,trialidx,cidx) = NaN;
                        resp_phase_std(flyidx,freqidx,trialidx,cidx) = NaN;

                end % If stim & resp files exist
            
        end
    end
end
save(['DATA_bf_fixed_sines.mat'],'headroll','framerates','flies','stimfreqs')
save('DATA_bf_gain_phase.mat','resp_gain_mean','resp_phase_mean','resp_gain_std','resp_phase_std');


