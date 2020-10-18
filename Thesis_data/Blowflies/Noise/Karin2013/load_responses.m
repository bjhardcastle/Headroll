clc, clear all, close all

% Plot to check the region of the stimulus startpoint
plot_stim_startpoint = 0;

% Trial parameters
fps = 500;
trial_duration = 50; % seconds 
num_frames = fps*trial_duration;
% time_vect = [0:1/fps:trial_duration-1];

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             

conditions{1} = '_WN_no-ocelli-';
conditions{2} = '_WN_dark-';
conditions{3} = '_WN_without-halteres_';
conditions{4} = '_WN_without-halteres_dark_';

for fly = 0:1
   
for cond = 1:4
    
for trial = 1:10
   
   clear data
   data_path = ['C:\Users\Ben\Dropbox\Work\Karin2013\Fly' int2str(fly) '\'];
   resp_file = ['Fly' int2str(fly),conditions{cond},int2str(trial),'resp.mat']; 
   
   if exist(([data_path,resp_file]),'file')
   load([data_path,resp_file])
   clean_up; 
  
   disp(resp_file)
   
   headabs = data(:,3);
   headabs = headabs - mean(headabs);
   
   clear data
   stim_file = ['Fly' int2str(fly),conditions{cond},int2str(trial),'stim.mat'];  
   load([data_path,stim_file]);
   clean_up; 
   
   body = data(:,3);
   body = body - mean(body);
   
   
   %find start of movement in stimulus trace.
   f = find(abs(body) >= 3);      
  
   n = 1;
                                
        clear g
        g = body(1:(f(n)));
        g = flipud(g);
        h = find( g <= mean(body(1:f(n))));
        
        if plot_stim_startpoint == 1
            
        plot(body,'r')
        axis([f(n)-250 f(n)+250 body(f(n))-5 body(f(n))+5])
        title([resp_file])
        
        end
       
                
        body = circshift(body, -f(n)+h(n) +1);    %shift to align with start of movement
        body = body(1:num_frames);  %cut off the end of the trace

        headabs = circshift(headabs, -f(n)+h(n) +1);
        headabs = headabs(1:num_frames)*1.15; %corect for camera perspective;
        
%  %  %    headrel = body - headabs ;  % gives same sign for compensation as stimulus
        headrel = headabs;                            % for computing correlation
    end
       
        resp{fly+1,cond,trial} = headrel;
        stim{fly+1,cond,trial} = body;
        
   end
end
end
 
