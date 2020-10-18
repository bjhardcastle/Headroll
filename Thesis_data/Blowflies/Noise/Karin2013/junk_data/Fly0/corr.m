clear all
fps = 500;
trial_duration = 50; %s
num_frames = fps*trial_duration;
% time_vect = [0:1/fps:trial_duration-1];


for fly = 0
    
%% C1: C.E. + haltere, light
for trial = 6:6
   
   clear data
   resp_file = ['Fly' int2str(fly) '_WN_no-ocelli-',int2str(trial),'resp.mat']; 
   

   load(resp_file);
   head = data(:,3);
   head = head - mean(head);
   clear data
   stim_file = ['Fly' int2str(fly) '_WN_no-ocelli-',int2str(trial),'stim.mat'];  
   load(stim_file);
   body = data(:,3);
   body = body - mean(body);
 

%find start of movement in stimulus trace.
f = find(abs(body) >= 0.1+abs(mean(body(1:20))));      

if (abs( body ( f(1) : f(1)+20 ) ) >= 0.05+(mean(body(1:f(1)))))
%if the next part of the trace looks like actual movement.. 
clear g
g = body(1:(f(1)));
g = flipud(g);
h = find( g <= mean(body(1:f(1))));


    body = circshift(body, -f(1)+h(1) +1);    %shift to align with start of movement
    body = body(1:num_frames);  %cut off the end of the trace
    
    head = circshift(head, -f(1)+h(1) +1);
    head = head(1:num_frames);
    
else
    disp('Error in computing start section length.')
    % Here: check the next section in 'f' and make sure it's around 0, up
    % to some other point that it crosses 0.1 
    plot(body,'r')
    axis([f(1)-50 f(1)+50 body(f(1))-0.5 body(f(1))+0.5])
     title(['Trial number ' num2str(trial) ''])
end

headrel = head - body;

C1.headrel(:,trial) = headrel;
C1.body(:,trial) = body;
 
headcorrected= head.*1.15;
headrelcorrected = headcorrected -body;


[C1.auto(:,trial),C1.lags_a(:,trial)] = xcorr(body,num_frames/2,'coeff');  
%flip headrel to compute correlation:
[C1.cross(:,trial),C1.lags_c(:,trial)] = xcorr(-headrel,body,num_frames/2,'coeff');   % separate 'lags' variables may not be neccesary..
C1.lags_a(:,trial) = C1.lags_a(:,trial)./5;
C1.lags_c(:,trial) = C1.lags_c(:,trial)./5;
C1.corr_lag(trial) = C1.lags_c(find(C1.cross(:,trial) == max(abs(C1.cross(:,trial)))));
C1.corr_gain(trial) = max(C1.cross(:,trial));

figure,
plot(body), hold on, plot(headrel,'r'), plot(headrelcorrected,'m')

end

%% C2: Without halteres, light

for trial = 1:10
   
   clear data
   resp_file = ['Fly' int2str(fly) '_WN_dark-',int2str(trial),'resp.mat']; 
   load(resp_file);
   head = data(:,3);
   head = head - mean(head);
   clear data
   stim_file = ['Fly' int2str(fly) '_WN_no-ocelli-',int2str(trial),'stim.mat']; 
   load(stim_file);
   body = data(:,3);
   body = body - mean(body);
 

%find start of movement in stimulus trace
f = find(abs(body) >= 0.1+abs(mean(body(1:20))));      

  
if (abs( body ( f(1) : f(1)+20 ) ) >= 0.1+(mean(body(1:(f(1))))))
%if the next part of the trace looks like actual movement..
clear g
g = body(1:(f(1)));
g = flipud(g);
h = find( g <= mean(body(1:(f(1)))));


    body = circshift(body, -f(1)+h(1) +1);    %shift to align with start of movement
    body = body(1:num_frames);  %cut off the end of the trace
    
    head = circshift(head, -f(1)+h(1) +1);
    head = head(1:num_frames);
    
else
    disp('Error in computing start section length.')
    % Here: check the next section in 'f' and make sure it's around 0, up
    % to some other point that it crosses 0.1 
    figure, plot(body,'r')
    axis([f(1)-50 f(1)+50 body(f(1))-0.5 body(f(1))+0.5])
    title(['Trial number ' num2str(trial) ''])
end



headrel = head - body;
C2.headrel(:,trial) = headrel;
C2.body(:,trial) = body;

 
[C2.auto(:,trial),C2.lags_a(:,trial)] = xcorr(body,num_frames/2,'coeff');  
%flip headrel to compute correlation:
[C2.cross(:,trial),C2.lags_c(:,trial)] = xcorr(-headrel,body,num_frames/2,'coeff');   % separate 'lags' variables may not be neccesary..
C2.lags_a(:,trial) = C2.lags_a(:,trial)./5;
C2.lags_c(:,trial) = C2.lags_c(:,trial)./5;
C2.corr_lag(trial) = C2.lags_c(find(C2.cross(:,trial) == max(abs(C2.cross(:,trial)))));
C2.corr_gain(trial) = max(C2.cross(:,trial));

end
  
%% C3: C.E. + haltere, dark

for trial = 1:10
   
   clear data
   resp_file = ['Fly' int2str(fly) '_WN_without-halteres_',int2str(trial),'resp.mat']; 
   load(resp_file);
   head = data(:,3);
   head = head - mean(head);
   clear data
   stim_file = ['Fly' int2str(fly) '_WN_no-ocelli-',int2str(trial),'stim.mat']; 
   load(stim_file);
   body = data(:,3);
   body = body - mean(body);
 

%find start of movement in stimulus trace
f = find(abs(body) >= 0.1+abs(mean(body(1:20))));      

  
if (abs( body ( f(1) : f(1)+20 ) ) >= 0.1+mean(body(1:(f(1)))))
%if the next part of the trace looks like actual movement..
clear g
g = body(1:(f(1)));
g = flipud(g);
h = find( g <= mean(body(1:(f(1)))));


    body = circshift(body, -f(1)+h(1) +1);    %shift to align with start of movement
    body = body(1:num_frames);  %cut off the end of the trace
    
    head = circshift(head, -f(1)+h(1) +1);
    head = head(1:num_frames);
    
else
    disp('Error in computing start section length.')
    % Here: check the next section in 'f' and make sure it's around 0, up
    % to some other point that it crosses 0.1 
    plot(body,'r')
    axis([f(1)-50 f(1)+50 body(f(1))-0.5 body(f(1))+0.5])
    title(['Trial number ' num2str(trial) ''])
end

headrel = head - body;
C3.headrel(:,trial) = headrel;
C3.body(:,trial) = body;
 
[C3.auto(:,trial),C3.lags_a(:,trial)] = xcorr(body,num_frames/2,'coeff');  
%flip headrel to compute correlation:
[C3.cross(:,trial),C3.lags_c(:,trial)] = xcorr(-headrel,body,num_frames/2,'coeff');   % separate 'lags' variables may not be neccesary..
C3.lags_a(:,trial) = C3.lags_a(:,trial)./5;
C3.lags_c(:,trial) = C3.lags_c(:,trial)./5;
C3.corr_lag(trial) = C3.lags_c(find(C3.cross(:,trial) == max(abs(C3.cross(:,trial)))));
C3.corr_gain(trial) = max(C3.cross(:,trial));

end

%% C4: Without halteres, dark

for trial = 1:2
   
   clear data
   resp_file = ['Fly' int2str(fly) '_WN_without-halteres_dark_',int2str(trial),'resp.mat']; 
   load(resp_file);
   head = data(:,3);
   head = head - mean(head);
   clear data
   stim_file = ['Fly' int2str(fly) '_WN_no-ocelli-',int2str(trial),'stim.mat']; 
   load(stim_file);
   body = data(:,3);
   body = body - mean(body);
 

%find start of movement in stimulus trace
f = find(abs(body) >= 0.1+abs(mean(body(1:20))));      

  
if (abs( body ( f(1) : f(1)+20 ) ) >= 0.1+(mean(body(1:(f(1))))))
%if the next part of the trace looks like actual movement..
clear g
g = body(1:(f(1)));
g = flipud(g);
h = find( g <= mean(body(1:(f(1)))));


    body = circshift(body, -f(1)+h(1) +1);    %shift to align with start of movement
    body = body(1:num_frames);  %cut off the end of the trace
    
    head = circshift(head, -f(1)+h(1) +1);
    head = head(1:num_frames);
    
else
    disp('Error in computing start section length.')
    % Here: check the next section in 'f' and make sure it's around 0, up
    % to some other point that it crosses 0.1 
    plot(body,'r')
    axis([f(1)-50 f(1)+50 body(f(1))-0.5 body(f(1))+0.5])
    title(['Trial number ' num2str(trial) ''])
end

headrel = head - body;
C4.headrel(:,trial) = headrel;
C4.body(:,trial) = body;
 
[C4.auto(:,trial),C4.lags_a(:,trial)] = xcorr(body,num_frames/2,'coeff');  
%flip headrel to compute correlation:
[C4.cross(:,trial),C4.lags_c(:,trial)] = xcorr(-headrel,body,num_frames/2,'coeff');   % separate 'lags' variables may not be neccesary..
C4.lags_a(:,trial) = C4.lags_a(:,trial)./5;
C4.lags_c(:,trial) = C4.lags_c(:,trial)./5;
C4.corr_lag(trial) = C4.lags_c(find(C4.cross(:,trial) == max(abs(C4.cross(:,trial)))));
C4.corr_gain(trial) = max(C4.cross(:,trial));

end

%%



figure,hold on
plot(mean(C1.lags_c,2), mean(C1.cross,2))
plot(mean(C1.lags_c,2), mean(C2.cross,2),'r')
plot(mean(C1.lags_c,2), mean(C3.cross,2),'k')
plot(mean(C1.lags_c,2), mean(C4.cross,2), 'Color', [0 0.5 0])
legend('CE+H, Light', 'CE, Light' , 'CE+H, Dark', 'CE, Dark')
title(['Mean cross-correlation, (relative head - body), Fly ' num2str(fly) ''])
xlabel('Lag (ms)')
ylabel('Normalised correlation')
axis([ -40 40 -0.25 1.01])
%%% for individual trial
% vline(C1.corr_lag(trial), 'r:', (['this trial: +' num2str(C1.corr_lag(trial)) ' ms']))

%%% for mean of multiple trials 
% vline(mean(corr_lag), 'r:', (['mean: +' num2str(mean(corr_lag)) ' ms']))

hold off

end