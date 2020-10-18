


cd FLY10
load10C2

figure(1102)

for i = 1:11
   eval(strcat('data_resp = response10_',int2str(name_array(2,i)),'_1;')); 
   eval(strcat('data_stim = stimulus10_',int2str(name_array(2,i)),'_1;'));
   Fs = data_resp(1,7);
   if ( data_stim(1,7) ~= Fs)
      disp('Warning: stim/resp sampling rates not identical.');
   end
   
   time = data_resp(:,6)/Fs; % Create time, stimulus and response
   resp = data_resp(:,3);    % vectors.
   stim = data_stim(:,3);
   stim = stim';
   resp = stim-resp';

   stimfreq = name_array(1,i);

   cd ..
   find_gain_phase_OL;
   plot_scatter;
   cd FLY10
   
end

load10C3

figure(1103)

for i = 1:11
   eval(strcat('data_resp = response10_',int2str(name_array(2,i)),'_1;')); 
   eval(strcat('data_stim = stimulus10_',int2str(name_array(2,i)),'_1;'));
   Fs = data_resp(1,7);
   if ( data_stim(1,7) ~= Fs)
      disp('Warning: stim/resp sampling rates not identical.');
   end
   
   time = data_resp(:,6)/Fs; % Create time, stimulus and response
   resp = data_resp(:,3);    % vectors.
   stim = data_stim(:,3);
   stim = stim';
   resp = stim-resp';

   stimfreq = name_array(1,i);

   cd ..
   find_gain_phase_OL;
   plot_scatter;
   cd FLY10
   
end
cd ..

