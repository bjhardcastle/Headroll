

load10C2

figure(102)
cond = 2;
for p = 1:10
   eval(strcat('data_resp = response_',int2str(name_array(2,p)),'_1;')); 
   eval(strcat('data_stim = stimulus_',int2str(name_array(2,p)),'_1;'));
   Fs = data_resp(1,7);
   if ( data_stim(1,7) ~= Fs)
      disp('Warning: stim/resp sampling rates not identical.');
   end
   
   time = data_resp(:,6)/Fs; % Create time, stimulus and response
   resp = data_resp(:,3);    % vectors.
   stim = data_stim(:,3);
   stim = stim';
   resp = stim-resp';

   stimfreq = name_array(1,p);

   
   find_gain_phase;
   plot_scatter;
   
   
   
end



figure(103)

cond = 3;

for p = 1:10
   eval(strcat('data_resp = response_',int2str(name_array(2,p)),'_1;')); 
   eval(strcat('data_stim = stimulus_',int2str(name_array(2,p)),'_1;'));
   Fs = data_resp(1,7);
   if ( data_stim(1,7) ~= Fs)
      disp('Warning: stim/resp sampling rates not identical.');
   end
   
   time = data_resp(:,6)/Fs; % Create time, stimulus and response
   resp = data_resp(:,3);    % vectors.
   stim = data_stim(:,3);
   stim = stim';
   resp = stim-resp';

   stimfreq = name_array(1,p);
   
   find_gain_phase;
   plot_scatter;
   
   
end


