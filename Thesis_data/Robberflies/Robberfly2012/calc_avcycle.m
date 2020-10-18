% modified 5/11/12 to calculate average cycle for each period of flight individually
 
stimperiod = Fs/stimfreq;
num_cycles = floor(length(stim)/stimperiod);

resp_traces = [];
stim_traces = [];

for cycle = 1:num_cycles
    
    resp_traces(cycle,:) = (resp(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod))-mean(resp(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod))))';
    stim_traces(cycle,:) = (stim(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod))-mean(stim(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod))))';
    
end

time = [1:stimperiod]/Fs;
