% Calculate head angular velocities during dynamic stimulus 

% Preprocessing parameters
clean_runs = 3;                 % number of interpolation runs on raw data
tol = 775;                       % score below which interpolation is run
sig_filter = [1 2 4 2 1]/10;     % smoothing filter             

% Load files, interpolate values with low score
load Fly8_WNslow_no-ocelliresp.mat;
clean_up;
response{1} = data(543:end,3);                             % 1 light, with halteres

load Fly8_WNslow_without-halteres-lightsonresp.mat;
clean_up;
response{2} = data(516:end,3);                % 2 light, without halteres

load Fly8_WNslow_darkresp.mat;
clean_up;
response{3} = data(700:end,3);                             % 3 dark, with halteres

load Fly8_WNslow_without-halteres-darkresp.mat
clean_up;
response{4} = data(400:end,3);                 % 4 dark, without halteres

load Fly8_WNslow_no-ocellistim.mat
clean_up;
stimulus = data(544:end-488,3);


%%

for r = 1:length(response)
    data = response{r};
         
    stim = stimulus;
    head = data(1:length(stim));  % actual head angle
    rel = stim - head;             % relative head angle
    
    slowresp{r} = rel - mean(rel);
    slowstim{r} = stim - mean(stim);
%     
%     vels{r} = 500*gradient(head);   % angular velocity of head
%     
end
% 
% 
% h = []; omega = [];
% for n = 1:4,
% [h(n,:), omega(n,:)] = hist(abs(vels{n}),500);
% end
% 
% figure
% plot(omega(1,:),h(1,:), omega(2,:),h(2,:), omega(3,:),h(3,:), omega(4,:),h(4,:))
% legend('Light', 'Dark', 'Light, no halteres', 'Dark, no halteres'), xlabel('Angular vel, deg/s'), ylabel('count')
% 
% %%
%     y = stimulus;
%     
for r = 1:4
   
    XY = [];
    
    x = response{r}; 
   
    XY(:,1) = x(1:length(y));
    XY(:,2) = y;
     
    [C{r}, p{r}] = corrcoef(XY);
    
end
 
 
 save('slow_responses','slowresp','slowstim')

 