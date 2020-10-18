%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Compound eye and ocellar signla integration %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% for fly gaze stabilization %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HGK%%%%%%%%%%%%
close all             % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear                 % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% defining parameters/variables used for computation %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau_LP=20;      % time constant (LP) compound eye respone [ms]
tau_HP=15;      % time constant (HP) ocellar response [ms]
                       
t=(1:1:3000);         % time axis in ms (over 3 seconds)
                        
frequencies=[ 1 3 6 10 15 ];   % different stimulus frequencies [1/s]

speed_ind=5;              % # value defines the results of which stimulation
                          % frequency will be displayed (in array
                          % "frequency"). N/B: all results are saved.
                          

%%%%%%%%%%%%%%%%%%%%%%%%%% arrays %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Stim_CE=zeros(5,3000);    % Stimulus waveform (compound eye)
Stim_O=zeros(5,3000);     % Stimulus waveform (ocelli)

Stim_LP=zeros(5,3000); % arrays for low pass filtered stimulus (compound eye) 
Stim_HP=zeros(5,3000); % arrays for high pass filtered stimulus (ocelli) 

vt=zeros(5,3000);      % time-continuous membrane potential in DN.
vt_CE=zeros(5,3000);   % time-continuous membrane potential. in DN only CE

IO=zeros(5,3000);      % combined input current to DN.
IO_CE=zeros(5,3000);   % combined input current to DN. only CE

Rout=zeros(5,3000);    % DN response = sum of compound eye and ocellar inputs

gCE=1;                % output signal amplitude ( CE weighting factor for integration)
gO=0.5;                 % output signal amplitude ( O weighting factor for integration) 

% the processing could be more explicit. E.g. different oscillation
% amplitudes


%%%%%%% Parameters 'leaky integrate and fire' model %%%%%%%%%%%%%%%%%%%%%%%%%

theta=2.5;            % threshold potential [mV] for generting an action potential
tau=5;                % membrane time constant [ms] (of descending neuron, DN).      
dt=1;                 % integration variable [ms]  
Rin=5;                % input resistance of DN [mOhm]  

                                                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                            
% Computation of time-dependent DN response upon compound eye and ocellar %%
% input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                            
 for j=1:5                       % different stimulus frequencies

                            
v=0.36*(frequencies(j)*pi/180);  % v=(360*(frequencies(j)*pi/180))/1000. Stimulus 
                                 % frequency converted into angular velocity [deg/s]                             

omega(j)=v;                      % angular velocity [deg/s]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Compound eye and ocellar stimulus signals %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                            
Stim_CE(j,:)=sin(omega(j)*t);
Stim_O(j,:)=sin(omega(j)*t);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computing compound eye (CE) and ocellar (O) responses %%%%%%%%%%%%%%%%%%%%
% by applying low pass and high pass filter, respectively %%%%%%%%%%%%%%%%%%
% There is no ecplicit delay included for the different pathways !! %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:2999
    
    Stim_LP(j,i+1)=((Stim_CE(j,i+1)-Stim_LP(j,i))*(1/(1+tau_LP)))+Stim_LP(j,i);
    Stim_HP(j,i+1)=(tau_HP/(tau_HP+1))*(Stim_HP(j,i)+Stim_O(j,i+1)-Stim_O(j,i));    
% low-pass and high-pass filtered stimuli.
    
    
    I0(j,i+1)=Stim_LP(j,i+1)*gCE+Stim_HP(j,i+1)*gO;    %compute input current to DN due to CE and O
    I0_CE(j,i+1)=Stim_LP(j,i+1)*gCE;                   %compute input current to DN due to CE
% weighted by CE and O contributions to overall membrane potential modulations 
    
    
     vt(j,i+1) = vt(j,i) + dt*(- vt(j,i)/tau + Rin*I0(j,i+1)/tau);  %membrane potential both modalities
          
     if (vt(j,i+1) > theta)      % reaching threshold?
     
         vt(j,i+1) = 0;          % reset to resting level (any subthreshold events 
                                 % will be filtered by membran RC=tau (above).   
         vt(j,i) = 20;           % action potential (arbitray amplitude [mV])
     
     end
         
    
     vt_CE(j,i+1) = vt_CE(j,i) + dt*(- vt_CE(j,i)/tau + Rin*I0_CE(j,i+1)/tau);  
     %membrane potential, only based on CE input
          
     if (vt_CE(j,i+1) > theta)      % reaching threshold?
     
         vt_CE(j,i+1) = 0;          % reset to resting level 
         vt_CE(j,i) = 20;           % action potential
     
     end
     
     
end


    




Rout(j,:)=Stim_LP(j,:)+Stim_HP(j,:); % combined input to DN when both modalities are stimulated 


 end
 
%%%%%%%%%%%%%%%%%%%%%% end of computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%% plotting results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% explanation in figure titles, legends, and added texts %%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if speed_ind > 2 
    t_lim=500;
else
    t_lim=3000;
end

plot(t(1:t_lim),Stim_LP(speed_ind,1:t_lim),'-b'); % CE stimulus
axis([0 t_lim -2 2]);
hold on
plot(t(1:t_lim),Stim_HP(speed_ind,1:t_lim),'-r'); % O stimulus
plot(t(1:t_lim),Rout(speed_ind,1:t_lim),'-g'); % combined stimulus

xlabel('time [ms]');
ylabel('signal amplitude [rel units]');
legend('comp eye','ocelli','sum');

figure(2)

plot(t(1:t_lim),vt(speed_ind,1:t_lim),'-g'); % DN membrane potential (both stimuli)
axis([0 t_lim -10 25]);
hold on
plot(t(1:t_lim),Stim_CE(speed_ind,1:t_lim),'-b'); % CE stimulus
plot(t(1:t_lim),vt_CE(speed_ind,1:t_lim),'-k'); % DN membrane potential (only CE stimulus)

xlabel('time [ms]');
ylabel('mebrane potential [rel units]');
title('response in Descending Neuron')
legend('response both','stimulus only CE', 'response only CE');


%%%%%%%%%%%%%%%%%%%%% end of programme %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

