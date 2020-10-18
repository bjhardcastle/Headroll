
range = 0:1:55; %angles
samp_freq = 20000;
static = 75*20000/500;
ramp = 25*20000/500;
unit = ramp+static;
trace = zeros(4*(length(range)-1)*unit,1);
for n = 1:length(range)-1
% trace(range(n)*unit + 1 : range(n)*unit + static) = range(n);
% trace(range(n)*unit + static +1 : range(n)*unit + unit) = range(n) + [1:ramp]*((range(n+1) - range(n)) / ramp);
trace(range(n)*unit + 1 : range(n)*unit + ramp) = range(n) + [1:ramp]*((range(n+1) - range(n)) / ramp);
trace(range(n)*unit + ramp +1 : range(n)*unit + unit) = range(n+1);
end

trace(55*unit+1-3000: 2*55*unit-3000) = flipud(trace(1: 55*unit));
trace(2*55*unit + 1: 4*55*unit) = - trace(1:2*55*unit);
plot(trace)


Steps_per_revolution = 5000;
Nsamples = length(trace);

trace = trace * Steps_per_revolution / 360;
traceround = round(trace);    % Amplitude in steps
traceround(length(traceround):length(traceround)+100) = 0;
traceround = circshift(traceround,100);
figure, plot(traceround)

% Step motor pulses
Pulse = zeros(Nsamples,1);
Pulse(2:Nsamples) = diff(traceround);

% First issue: are there any places where the change in steps in one sample
% is greater than 1?
two_steps_id = find(abs(Pulse) > 1);

% Second issue: are two pulses requiredin two successive samples?
two_successive_pulses = zeros(Nsamples,1);
for n = 1:Nsamples-1
    if (abs(Pulse(n)) == 1 && abs(Pulse(n+1)) == 1)
        Pulse(n+3) = Pulse(n+1);            % if two impulses are at consecutive samples
        Pulse(n+1) = 0;                     % shift the second one forward by 2 samples
    end                                     % BAAAAAAD!!
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


%%
% AO = analogoutput('nidaq','Dev1');
% addchannel(AO,0); % Channel 0: fly step motor driver pulses
% addchannel(AO,1); % Channel 1: fly step motor direction
% set(AO,'SampleRate',Samp_freq)
% aout = zeros(Nsamples,2);
% aout(:,1) = Pulse;
% aout(:,2) = Direction;
 
%%
%  putdata(AO, aout);  
%         start(AO); 

%% Tidy up
% delete(AO);
% clear AO*;