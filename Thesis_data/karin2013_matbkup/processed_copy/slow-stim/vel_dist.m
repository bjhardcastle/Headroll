% Calculate head angular velocities during dynamic stimulus 

conditions = [light, dark, light_no_halteres];

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             

for cond = 1:length(conditions)
    dataresp = conditions(cond);
    datastim = stim;
    
    clean_up;
    

