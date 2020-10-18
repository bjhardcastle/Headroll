cd FLY8;
figure(8);

%freq 1

%%

load Fly8_1Hz_C2_C001H001S0001resp2.mat;
response8_1_1 = data;

load Fly8_1Hz_C2_C001H001S0001stim.mat;
stimulus8_1_1 = data;

Fs = response8_1_1(1,7);

if ( stimulus8_1_1(1,7) ~= Fs)
    disp('Warning: stim/resp sampling rates not identical.');
end

time = response8_1_1(:,6)/Fs; % Create time, stimulus and response
resp = response8_1_1(:,3);    % vectors.
stim = stimulus8_1_1(:,3);
stim = stim';
resp = stim-resp';
stimfreq = 1;

cd ..
find_gain_phase;
plot_scatter;
cd FLY8


%%

load Fly8_0.1Hz_C2_C001H001S0001resp2.mat;
response8_01_1 = data;

load Fly8_0.1Hz_C2_C001H001S0001stim.mat;
stimulus8_01_1 = data;

Fs = response8_01_1(1,7);

if ( stimulus8_01_1(1,7) ~= Fs)
    disp('Warning: stim/resp sampling rates not identical.');
end

time = response8_01_1(:,6)/Fs; % Create time, stimulus and response
resp = response8_01_1(:,3);    % vectors.
stim = stimulus8_01_1(:,3);
stim = stim';
resp = stim-resp';

stimfreq = 0.1;

cd ..
find_gain_phase;
plot_scatter;
cd FLY8

%%
cd ..