
% model_head(t,y,I,k,c,sYt,sY,sV,sVt)
clear all

for stim_freq = 1:30
amp = 30;
fps = 500;
t_step = 1/fps;
t_max = 10; %s
t_length = 2*t_max/t_step;
 
% % Sine stimulus trace 
sYt = linspace(-t_max,t_max,t_length);
sY = amp*sin(stim_freq*2*pi*sYt);
% Get stimulus velocity
sV = diff(sY)/t_step;
sVt = linspace(-t_max,t_max,length(sV));
chirptime = t_max;

% Chirp stimulus trace
%     chirptime = 10; %s    
%     cfps = chirptime*fps*20;
%     halftime = 5*cfps;
%     chirp_freq = 51;
%     Phase = 0;
%     k = 0.5*(chirp_freq - 0)/cfps/halftime;
%     Stim_sin = zeros(halftime,1);
%     Stim_sin = amp*sin( Phase + 2*pi* (0*(1:halftime) + 0.5*k*(1:halftime).^2 ) );
%     Stim_sin = [Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')) -fliplr(Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')))];
%     
%     Stim_sin(end:2*halftime) = 0;
%     % 1 second of zero padding from t=-1:0 (so that velocity at t=0 can be
%     % calculated)
%    
%     sY1 = downsample(Stim_sin,((chirptime+2)*fps*20/fps));
%     sY = [zeros(1,fps) sY1 zeros(1,fps)];
% 
%     sYt = linspace(-1,chirptime+2,length(sY));
%     % Get stimulus velocity
%     sV = diff(sY)/t_step;
%     sVt = linspace(-1,chirptime+2,length(sV));
%     
head_lag = 0.03; % Constant delay 30ms
rY = circshift(0.000000001*sY,ceil(head_lag*fps),2); % Relative movement of head, approx half of stim, opp direction
% sY is padded with zeros before t=0 (so that velocity at t=0 can be
% calculated), so circshift can be used to create a delayed head resp
rYt = linspace(-1,chirptime,length(rY));

% Physical parameters
% m = blowfly head mass: 8mg from (Schilstra & van Hateren 1999)
m = 8e-6; %kg, 
% L = distance between neck axis and centre of mass, approx 0.25mm
L = 2.5e-4; %m

% J = m * L^2;
J = 0.9e-10; %was 0.5e-10
k = 1e-10; %was 1e-11
c = 1e-8; % was 1e-9

% Solve model equations
tspan = [0 10];
y0 = [0 sV(500)];
% opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
[t,y] = ode45(@(t,y) model_head(t,y,J,k,c,sY,sYt,sV,sVt,rY,rYt), tspan, y0);


clear resp
resp = y(:,1) - mean(y(:,1));

  resp_diff = conv(resp,[1,-1]);
            stim_diff = conv(sY,[1,-1]);
            resp_vel  = abs(resp_diff(2:length(resp_diff))*fps);
            stim_vel  = abs(stim_diff(2:length(resp_diff))*fps);
                        
            xvalues = linspace(0,2*pi*stim_freq*30,50); %2 times the maximum angular speed of stim
            
            [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
            result(stim_freq).x_resp=(edges(1:end-1)+edges(2:end))/2;
            result(stim_freq).n_resp=N;
            result(stim_freq).mean_resp=median(resp_vel);
            [N,edges] = histcounts(stim_vel,xvalues,'Normalization','pdf');
            stimresult(stim_freq).x_resp=(edges(1:end-1)+edges(2:end))/2;
            stimresult(stim_freq).n_resp=N;
            stimresult(stim_freq).mean_resp=median(resp_vel);
end

for ff = 1:3:30
    
        mean_1(ff)= nanmean([result(ff).mean_resp]);
        stimmean(ff) = nanmean([result(ff).mean_resp]);
end
figure, plot(stimmean),hold on, plot(mean_1)
%%
%% plot mean traces for each condition (n=4)
%%

figure(89)
hold off
plot(sYt,sY,'Color',[0.6,0.6,0.6],'LineWidth',1 )
hold on,
plot(t,y(:,1)-mean(y(:,1)),'Color','k','LineWidth',1 )
xlim(tspan)
% legend('head','thorax')


% head position


    
    ylim([-30 30])
%     title('')
    



set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/800:1/800:10];

errbar = 1;
clear tvecs
tvecs(1,:) = [1:8000];
t(1,:)=0+timesection;
t(2,:)=24.5+timesection;
t(3,:)=4+timesection;
% for offset axes
xoffset(1) = 0.02;
xoffset(2) = 0.05;
xoffset(3) = 0.05;
% cmap = colormap(lines);
    ylim([-32 40])


    set(gca,'ytick',[-30,0,30])

        
        set(gca,'yticklabel',{[-30],[0],[30]})
    ylabel('Amplitude [\circ]')

    xlabel('Time [s]')
set(gca,'box','off')
     offsetAxes(gca,xoffset(1),0.3);   


set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\model_chirp','-openGL','-r660' )

