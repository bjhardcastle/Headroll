
load Fly10_0.011Hz_C3_C001H001S0001resp.mat;
clean_up;
response_1_1 = data;

load Fly10_0.011Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_1_1 = data;


load Fly10_0.03Hz_C3_C001H001S0001resp.mat;
clean_up;
response_2_1 = data;

load Fly10_0.03Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_2_1 = data;


load Fly10_0.06Hz_C3_C001H001S0001resp.mat;
clean_up;
response_3_1 = data;

load Fly10_0.06Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_3_1 = data;


load Fly10_0.1Hz_C3_C001H001S0001resp.mat;
clean_up;
response_4_1 = data;

load Fly10_0.1Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_4_1 = data;


load Fly10_0.3Hz_C2_C001H001S0001resp.mat;
clean_up;
response_5_1 = data;

load Fly10_0.3Hz_C2_C001H001S0001stim.mat;
clean_up;
stimulus_5_1 = data;


load Fly10_0.6Hz_C3_C001H001S0001resp.mat;
clean_up;
response_6_1 = data;

load Fly10_0.6Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_6_1 = data;


load Fly10_1Hz_C3_C001H001S0001resp.mat;
clean_up;
response_7_1 = data;

load Fly10_1Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_7_1 = data;


load Fly10_3Hz_C3_C001H001S0001resp.mat;
clean_up;
response_8_1 = data;

load Fly10_3Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_8_1 = data;



load Fly10_6Hz_C3_C001H001S0001resp.mat;
clean_up;
response_9_1 = data;

load Fly10_6Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_9_1 = data;




load Fly10_10Hz_C3_C001H001S0001resp.mat;
clean_up;
response_10_1 = data;

load Fly10_10Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_10_1 = data;



load Fly10_15Hz_C3_C001H001S0001resp.mat;
clean_up;
response_11_1 = data;

load Fly10_15Hz_C3_C001H001S0001stim.mat;
clean_up;
stimulus_11_1 = data;


name_array = [0.011 0.03 0.06 0.1 0.3 0.6 1 3 6 10 15];
name_array = [name_array; 1 2 3 4 5 6 7 8 9 10 11]; 