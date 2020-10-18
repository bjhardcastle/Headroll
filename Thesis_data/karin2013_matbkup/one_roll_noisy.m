function one_roll_mod()

% Kit's one_motor_roll.m 
% changed for testing new dynamic stimulus
% 10/4/2013

%% Query user to input the experiment variables, set up data directory first
c = (fix(clock));
Data_dir_name = ['D:/data/Karin2013/' num2str(c(1)) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5)) '_' num2str(c(6)) '/' ];


Previous_stim_dir = ['D:/data/Karin2013/last_used_stimulus/'];
Previous_stim_loc = ['' Previous_stim_dir 'Previous_stim.mat'];

Regen_flag = 0; % 0 if previous stimulus is to be used, 1 if new stim is to be generated

if (exist(Previous_stim_dir) == 0)
    mkdir(Previous_stim_dir)    
    disp(sprintf('\n\nNo previous stimulus exists.'))
    Regen_flag = 1;
    Previous_stim = 0;
elseif (exist(Previous_stim_loc) == 0)
    disp(sprintf('\n\nNo previous stimulus exists.\n\n'))
     Regen_flag = 1;
     Previous_stim = 0;
else
    disp(sprintf(['Loading stimulus....']))
    eval(['Previous_stim = load(Previous_stim_loc);'])

    disp(sprintf(['\nFirst generated ' Previous_stim.Generation_date'.']))
    disp(['' num2str(Previous_stim.Trial_duration) 's long, ' num2str(max(abs(Previous_stim.Stimulus_trace))) ' max deg/s, ' num2str(std(Previous_stim.Stimulus_trace)) ' s.d.'])
end


Approve_stim_flag = 0; % 0 to repeat stimulus generation, 1 to stop

while (Approve_stim_flag == 0)


[Regen_flag Samp_freq Trial_duration Steps_per_revolution Time_scale Noise_amp Stim_plots] = subfn_input_experiment_parameters(Regen_flag, Previous_stim);

if (Regen_flag == 1) 
% Create motor outputs for fly 
[Stim_pulse Stim_direction Nsamples Stimulus_trace] = subfun_generate_motor_commands(Trial_duration, Samp_freq, Steps_per_revolution, Time_scale, Noise_amp, Stim_plots);

if (Stim_plots == 1)
%Approve stimulus or generate a new one
[Approve_stim_flag] = subfun_query_user_for_approval();
else Approve_stim_flag = 1;
end

else
    % If the previous stimulus is going to be used:   
    Stim_direction = Previous_stim.Stim_direction;
    Stim_pulse = Previous_stim.Stim_pulse;
    Nsamples = Previous_stim.Nsamples;
    Samp_freq = Previous_stim.Samp_freq;
   
    Approve_stim_flag = 1;  
end

end

%% Create the analogue output, digital output, and analogue input channels.
% Analogue outputs: step motor driver pulses and directions
% Use <daqhwinfo('nidaq')> to check device name. [Might need <daqregister('nidaq')> first.]
AO = analogoutput('nidaq','Dev1');
addchannel(AO,0); % Channel 0: fly step motor driver pulses
addchannel(AO,1); % Channel 1: fly step motor direction
set(AO,'SampleRate',Samp_freq)
aout = zeros(Nsamples,2);
aout(:,1) = Stim_direction;
aout(:,2) = Stim_pulse;

%% Save Session experiment parameters

% If a new stimulus was generated and used, overwrite data in 'Previous_stim' directory for use next time
if (Regen_flag == 1)
    Generation_date = datestr(now);
    eval(['save ' Previous_stim_loc ' Generation_date Stim_direction Stim_pulse Nsamples Samp_freq Trial_duration Steps_per_revolution Time_scale Noise_amp Stimulus_trace'])
    disp(sprintf('\n\nNew stimulus saved for next time. Note down the following to check its identity:'))
    disp(['' num2str(Trial_duration) 's long, ' num2str(max(abs(Stimulus_trace))) ' max deg/s, ' num2str(std(Stimulus_trace)) ' s.d.'])
else
    Generation_date = Previous_stim.Generation_date;
end

mkdir(Data_dir_name)
eval(['save ' Data_dir_name 'stimulus Generation_date Stim_direction Stim_pulse Nsamples Samp_freq Trial_duration Steps_per_revolution Time_scale Noise_amp Stimulus_trace'])

%% Loop through trials
Ntrial = 0;
Trial_repeat_flag = 1; % 1 for repeat, 0 for stop
while (Trial_repeat_flag == 1)
    
    % Perform trial or stop
    [Trial_repeat_flag Ntrial] = subfun_query_user_for_trial(Ntrial);
    if (Trial_repeat_flag > 0)
        putdata(AO, aout);  
        start(AO); 
    end
end

%% Tidy up
delete(AO);
clear AO*;

function [Regen_flag Samp_freq Trial_duration Steps_per_revolution Time_scale Noise_amp Plot_flag] = subfn_input_experiment_parameters(Regen_flag, Previous_stim)
% Function queries user for session number and experimental variables
% Values are initialised to make it more user friendly.


reply_noise_amp_default = '10';
reply_time_scale_default = '15';
reply_trial_dur_default = '50';
reply_sampling_frequency_default = '60000';
reply_correct_inputs_default = 'y';
reply_plot_flag_default = 'y';

enter_values_flag = 1;
while (enter_values_flag == 1)
    % Enter experiment parameters or use default values
    if  Regen_flag == 1;
        reply_skip = 'e';
    else
    reply_skip = input('Use previous stimulus (d) or enter new parameters (e)? [d] ', 's');
    end
%     reply_skip = input('Enter experimental parameters (e) or use default values (d)? [e] ', 's');
    if (reply_skip == 'e')
          reply_noise_amp = input(['Noise sigma multiplier?            [' reply_noise_amp_default '] '], 's');
          reply_time_scale = input(['Time scale multiplier?            [' reply_time_scale_default '] '], 's');
          reply_trial_dur = input(['Trial duration (s)?            [' reply_trial_dur_default '] '], 's');
          reply_plot_flag = input(['Plot stimulus trace and stats (y or n)?            [' reply_plot_flag_default '] '], 's');
          reply_sampling_frequency = input(['What is the sampling frequency?                    [' reply_sampling_frequency_default '] '], 's');
          
          Regen_flag = 1;
    else
          reply_noise_amp =  num2str(Previous_stim.Noise_amp);
          reply_time_scale = num2str(Previous_stim.Time_scale);
          reply_trial_dur = num2str(Previous_stim.Trial_duration);
          reply_sampling_frequency = num2str(Previous_stim.Samp_freq);
          reply_plot_flag_default = 'n';
          reply_plot_flag = input(['Plot stimulus trace/stats (y or n)?            [' reply_plot_flag_default '] '], 's');

          reply_correct_inputs_default = 'y';
          Regen_flag = 0;
    end
          
    % Fill in default values if no answer is returned

    if (isempty(reply_noise_amp))
       reply_noise_amp = reply_noise_amp_default;
    end
    if (isempty(reply_time_scale))
          reply_time_scale = reply_time_scale_default;
    end
    if (isempty(reply_trial_dur))
        reply_trial_dur = reply_trial_dur_default;
    end
    if (isempty(reply_plot_flag))
        reply_plot_flag = reply_plot_flag_default;
    end
    if (isempty(reply_sampling_frequency))
        reply_sampling_frequency = reply_sampling_frequency_default;
    end
    
    % Convert string replies to numbers
    Noise_amp = str2double(reply_noise_amp);
    Time_scale = str2double(reply_time_scale);
    Trial_duration = str2double(reply_trial_dur);
    Samp_freq = str2double(reply_sampling_frequency);
    if (reply_plot_flag == 'n')
        Plot_flag = 0;
    else 
        Plot_flag = 1;
    end
       
  
    % Set the steps per revolution
            Steps_per_revolution = 5000;
   
            % Display parameter choices.
    disp(sprintf('\n\nThanks. The entered or previous paramaters are:'))
%     disp(['Session number                                      ' reply_session_no])
%     disp(['Stimulation frequency                               ' reply_freq_stim ' Hz'])
%     disp(['Stimulation phase offset                            ' reply_phase_stim ' degrees'])
%     disp(['Stimulation amplitude                               ' reply_amp_stim  ' degrees'])
%     disp(['Sampling frequency                                  ' reply_sampling_frequency ' degrees\n\n'])
    
    disp(['Noise multiplier                                ' num2str(Noise_amp)])
    disp(['Time scale multiplier                           ' num2str(Time_scale)])
%     disp(['Steps per revolution                                ' num2str(Steps_per_revolution)])
    disp(['Sampling frequency                              ' num2str(Samp_freq)])
    disp(sprintf(['Stimulation and recording duration              ' num2str(Trial_duration) ' seconds\n\n']))
    
    % Check this is correct
    if (reply_skip == 'd')
        enter_values_flag = 0;
    else
        reply_correct_inputs = input('Is this correct? If not, we will reenter the values. y/n [y]', 's');
        if (isempty(reply_correct_inputs))
            reply_correct_inputs = reply_correct_inputs_default;
        end
        if (reply_correct_inputs == 'y')
            enter_values_flag = 0;
            
        else
           
        end
    end
    
    
end

function [Pulse Direction Nsamples Stim_noise_smooth] = subfun_generate_motor_commands(Trial_duration, Samp_freq, Steps_per_revolution, Tscale, Noise_amp, Stim_plots)

Nsamples = Trial_duration * Samp_freq;
Time = (0:1/Samp_freq:(Nsamples-1)/Samp_freq);


Noise_amp = 10;             %amplitude multiplier for noisy signal  (10 is ok with 15)
Tscale = 15;                %temporal stretching factor for noisy signal (up to 15 is ok)
Noise = zeros(Trial_duration * Tscale, 1);   
Noise = randn(1, length(Noise)+1); 
Noise(1) = 0;               %motor must start and stop at 0 position
Noise(length(Noise)) = 0;

Stim_noise = zeros(Nsamples,1);
Stim_noise = interp1(Noise, 1 : (Tscale/Samp_freq) : length(Noise) - (1/Samp_freq));


Stim_noise = Stim_noise * Noise_amp * Steps_per_revolution / 360;
Stim_noise_smooth = smooth(Stim_noise, 150);          %smooth 

% %%%%%%% temporary
% Stim_noise_smooth = load('current_stimulus');
% Stim_noise_smooth = Stim_noise_smooth.Stimulus_trace;
% %%%%%%%%%


Stim_noise_smoothround = round(Stim_noise_smooth);    % Amplitude in steps


% Step motor pulses
Pulse = zeros(Nsamples,1);
Pulse(2:Nsamples) = diff(Stim_noise_smoothround);

% First issue: are there any places where the change in steps in one sample
% is greater than 1?
two_steps_id = find(abs(Pulse) > 1);

% Second issue: are two pulses requiredin two successive samples?
two_successive_pulses = zeros(Nsamples,1);
for n = 1:Nsamples-1
    if (abs(Pulse(n)) == 1 && abs(Pulse(n+1)) == 1)
        Pulse(n+3) = Pulse(n+1);            % if two impulses are at consecutive samples
        Pulse(n+1) = 0;                     % shift the second one forward by 2 samples
    end                                     % BAD!
end 
for n = 1:Nsamples-1
    if (abs(Pulse(n)) == 1 && abs(Pulse(n+1)) == 1)
        two_successive_pulses(n) = 1;
    end
end
two_successive_pulses_id = find(two_successive_pulses > 0);

% Tell the user if change required
if(isempty(two_steps_id) == 0 || isempty(two_successive_pulses_id) == 0)
    disp('Increase sample frequency, or decrease the steps per revolution, for this combination of stimulus frequency and amplitude.')
end
if(isempty(two_steps_id) && isempty(two_successive_pulses_id))
    disp('Parameters are great.')
end

% Direction of pulses
Direction = zeros(Nsamples,1);
Direction_flag = -1;
for n = 1:Nsamples
    if (Pulse(n) == 0 || Pulse(n) == Direction_flag)
        Direction(n) = Direction_flag;
    else
        Direction_flag = -Direction_flag; % switch the direction
        Direction(n-1:n) = Direction_flag; % change direction one sample earlier
    end
end

% Convert to 0 - 5 V ranges
Pulse = 5 * Pulse.^2;
Direction = 2.5 * (Direction + 1);
 

clear Gradient
Gradient = gradient(Stim_noise_smooth/5000*360,1/Samp_freq);
% assignin('base', 'Stimulus', Stim_noise_smooth/5000*360)
% assignin('base', 'Gradient', Gradient)

if Stim_plots == 1,
    
    
close(figure(1))
figure(1)
a1 = subplot(2,2,1:2);
% plot(a1, Time,Stim_noise/Steps_per_revolution*360)
% hold on,
plot(a1, Time,Stim_noise_smooth/Steps_per_revolution*360,'r')
xlabel('time, s')
ylabel('roll, deg')
title('Stimulus')

% a2 = subplot(4,1,2);          %plot pulses and direction changes
% plot(a2, Time,Pulse)
% title('Pulses')
% % a3 = subplot(4,1,3);
% plot(a3, Time,Direction)
% title('Direction changes')
%linkaxes([a1 a2 a3],'x')



%plot fft of stimulus
Samp_time = 1/Samp_freq;
L = length(Stim_noise_smooth);
time=(0:L-1)*Samp_time;
NFFT = 2^nextpow2(L);
Stim_fft = fft(Stim_noise_smooth,NFFT)/L;
f = Samp_freq/2*linspace(0,1,NFFT/2+1);
a4 = subplot(2,2,3);
plot(f,2*abs(Stim_fft(1:NFFT/2+1)))
title('Frequency spectrum')
xlabel('Freq, Hz')
axis([0 40 0 max(2*abs(Stim_fft(1:NFFT/2+1)))])

%plot histogram of ang.velocities
a5 = subplot(2,2,4);
hist(Gradient,50)
title('Velocity distribution')
xlabel('Ang. vel., deg/s')

end


function [Trial_repeat_flag Ntrial] = subfun_query_user_for_trial(Ntrial)

disp(sprintf(['\n\nTrial ' num2str(Ntrial+1) '...']))
reply = input('...perform trial? y/n [y]: ', 's');

if (isempty(reply))
    reply = 'y';
end

if (reply == 'y')
    Ntrial = Ntrial + 1;
    Trial_repeat_flag = 1;
elseif (reply == 'n')
    Trial_repeat_flag = 0;
else
    disp('\n   Please press <y>, <n> or <enter>.')
    [Trial_repeat_flag Ntrial] = subfun_query_user_for_trial(Ntrial);
end

function [Approve_stim_flag] = subfun_query_user_for_approval()
    reply = input('Do you want to continue with this stimulus? y/n? [y]', 's');
    
    if (isempty(reply))
        reply = 'y';
    end
    
    if (reply == 'y')
        Approve_stim_flag = 1;
    elseif (reply == 'n')
        Approve_stim_flag = 0;
    else    
        disp('\n   Please press <y>, <n> or <enter>.')
        [Approve_stim_flag] = subfun_query_user_for_approval();
    
end

