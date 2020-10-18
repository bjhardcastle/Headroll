stimperiod = Fs/stimfreq;
num_cycles = floor(length(stim)/stimperiod);

resp_traces = [];
stim_traces = [];

for cycle = 1:num_cycles
    
    resp_traces(cycle,:) = data_resp(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod),3)';
    stim_traces(cycle,:) = data_stim(round((cycle-1)*stimperiod+1):round((cycle-1)*stimperiod)+floor(stimperiod),3)';
    
end

time = [1:stimperiod]/Fs;
