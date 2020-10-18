%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% Karin2012_model.m                                   %
%                                                     %
%                                                     %
%                                                     %
%                                                     %
% @author   das207@ic.ac.uk                           %
% @created  120409                                    %
% @modified 120409                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Set simulation time

Fs = 1E4;
t_end = 10;

time = 1/Fs:1/Fs:t_end;
num_steps = length(time);

dT = 1/Fs;


% Set input signal

A_TR = 30;
f_TR = 10;

TR = A_TR * sin( f_TR * time );


% Set model params

th = 5;


% Set start parameters

TR_0 = 0;
TS_0 = 0;


% Initialize result vectors

Error_sig = zeros(1,num_steps);
dError_sig = zeros(1,num_steps);
Ocelli_star = zeros(1,num_steps);
CEyes_star = zeros(1,num_steps);
Ocelli_out = zeros(1,num_steps);
CEyes_out = zeros(1,num_steps);
HR = zeros(1,num_steps);
HR_out = zeros(1,num_steps);




for step = 2:num_steps

    Error_sig(step)   = TR(step-1)-HR_out(step-1);
    dError_sig(step)  = (Error_sig(step)-Error_sig(step-1))/dT;
    
    Ocelli_star(step) = (6*dT)/(1-6*dT)*( sum(dError_sig)-sum(Ocelli_star) );
    CEyes_star(step)  =  (12*dT)/(1-6*dT)*( sum(dError_sig)-sum(CEyes_star) );
    
    Ocelli_out(step)  = Ocelli_star(max([step-round(0.005/dT),1]));
    CEyes_out(step)   = CEyes_star(max([step-round(0.015/dT),1]));
    
    HR(step)          = Ocelli_out(step)+CEyes_out(step);
    
    if abs(HR(step)) < th
        HR(step) = 0;
    else
        HR(step) = HR(step)-sign(HR(step))*th;
    end
    
    HR_out(step) = sum(HR)*dT;
    
end