clear all


flies = [2,3,4,5,6];
stimfreqs = [0.01,0.03,0.06,0.1,0.3,0.6,1,3.003,6.00,10.0,15,20,25];
freqs = roundn(stimfreqs,-2);

project_path = 'C:\Users\Ben\Dropbox\Work\Thesis_data\Hoverflies\Aenus_sine_chirp\data\';
fly_path = 'hoverfly';

% Preprocessing parameters
clean_runs = 5;                 % number of interpolation runs on raw data
tol = 800;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter

% nb different fps used through these experiments

clear headroll;

for flyidx = 1:length(flies)
    fly = flies(flyidx);
    fprintf(['fly ',num2str(fly),'\n']);

    for cidx = 1:3
        cidx;
        data_path = [project_path,fly_path,num2str(fly),'\c',num2str(cidx),'\'];
        
        for freqidx = 1:length(freqs),
            freq = freqs(freqidx);
            
            trial_nexist_flag = 0;
            trialidx=0;
            
            while trial_nexist_flag == 0;
                trialidx = trialidx + 1;
                
                resp_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_resp.mat'];
                stim_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hz_',num2str(trialidx),'_stim.mat'];
                
% 
%                 resp_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzresp.mat'];
%                 stim_fname = ['c',num2str(cidx),'_',num2str(freqs(freqidx)),'Hzstim.mat'];
                
                
                if exist([data_path resp_fname]) && exist([data_path stim_fname])
                    
                    load([data_path,resp_fname]);
                    resp_data = data;
                    load([data_path,stim_fname]);
                    stim_data = data;
                    
                    
                    if length(stim_data)-length(resp_data) ~= 0
                        
%                         sprintf(['Different lengths: Fly ',num2str(fly),' C',num2str(cidx),' ',num2str(freq),'Hz trial ',num2str(trialidx)])
%                         sprintf(['Resp length ',num2str(length(resp_data)),', Stim length ',num2str(length(stim_data)),''])
                        
                        resp_data(length(resp_data):length(stim_data),1:3)=0;
                        
                    end
                      
                        

%                         if flyidx == 2 && freqidx > 10
%                             [stim,trimmed_data,fps] = hf_remove_prestim(stim_data,resp_data,freqs(freqidx),1);                                                   
%                         else
%                         % Get reference stim and aligned response data
                        [stim,trimmed_data,aligned_stim,fps] = hf_remove_prestim(stim_data,resp_data,freqs(freqidx),0);
%                         end

                        
                       % Clean resp data
                        hf_clean_up;
                        
                        
                        
                        % Remove baseline drift by filtering freqs <0.5Hz
                        resp_DC = trimmed_data(:,3);
                        %{
                        dt_s = 1/fps;
                        f0_hz = 1/dt_s;
                        fcut_hz = 1;
                        [b,a] = butterhigh1(fcut_hz/f0_hz);
                        resp_AC = filtfilt(b,a,resp_DC);
                        %}
                        resp = resp_DC;
                        
                        % Find offset of response baseline
                        %{
                        os = mean(resp_AC);
                        resp = resp_AC - os;
                                              
                                                
                       %}
                        % Thorax roll - head roll
%                         rel_resp = stim - resp_DC;
                        
                       
                        % Smooth response
%                         rel_resp = smooth(rel_resp,8);
                        
%                         eval(strcat('headroll.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=rel_resp;'));
%                         eval(strcat('framerates.fly',num2str(flyidx),'.cond',num2str(cidx),'.freq',num2str(floor(freqs(freqidx))),'.trial(:,',num2str(trialidx),')=fps;'));
                         
                        
%                         headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = rel_resp;
%                         
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = resp_DC;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = fps;
                        stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= aligned_stim(:,3);
                        
                        % velocities
                        slipspeed(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = diff(resp_DC)*fps;


%                     end %Different lengths check
                    
                else % condition folder doesn't exist
                    trial_nexist_flag = 1;                        
                        headroll(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                        framerates(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                        stims(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx)= NaN;
                        slipspeed(flyidx).cond(cidx).freq(freqidx).trial(:,trialidx) = NaN;
                end % If stim & resp files exist
            end
        end
    end
end
save(['DATA_hf_fixed_sines_nonrelslip.mat'],'headroll','framerates','stims','flies','stimfreqs')


