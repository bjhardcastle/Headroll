clear all

chirp_stim = 1;  % 0:sine stim, 1:chirp stim

for stim_freq = 1:30
    
    amp = 30; % +/- stimulus roll angle
    fps = 500;
    t_step = 1/fps;
    t_max = 10; % trial time, seconds
    t_length = 2*t_max/t_step;
    
    
    if ~chirp_stim    % Sine stimulus trace

        sYt = linspace(-t_max,t_max,t_length);
        sY = amp*sin(stim_freq*2*pi*sYt);
        % Get stimulus velocity
        sV = diff(sY)/t_step;
        sVt = linspace(-t_max,t_max,length(sV));
        stimtime = t_max;
        
    elseif chirp_stim % Chirp stimulus trace
        
        stimtime = 10; %s
        cfps = stimtime*fps*20;
        halftime = 5*cfps;
        chirp_freq = 51;
        Phase = 0;
        k = 0.5*(chirp_freq - 0)/cfps/halftime;
        Stim_sin = zeros(halftime,1);
        Stim_sin = amp*sin( Phase + 2*pi* (0*(1:halftime) + 0.5*k*(1:halftime).^2 ) );
        Stim_sin = [Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')) -fliplr(Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')))];
        
        Stim_sin(end:2*halftime) = 0;
        
        % 1 second of zero padding from t=-1:0 (so that velocity at t=0 can be
        % calculated)       
        sY1 = downsample(Stim_sin,((stimtime+2)*fps*20/fps));
        sY = [zeros(1,fps) sY1 zeros(1,fps)];
        
        sYt = linspace(-1,stimtime+2,length(sY));
        % Get stimulus velocity
        sV = diff(sY)/t_step;
        sVt = linspace(-1,stimtime+2,length(sV));
    end
    
    % Get active stabilization effort (near zero while looking at passive
    % response)
    head_lag = 0.03; % Constant delay of 30ms
    rY = circshift(0.000000001*sY,ceil(head_lag*fps),2); % Relative movement of head, approx half of stim, opp direction
    rYt = linspace(-1,stimtime,length(rY));
    
    % Physical parameters
    % m = blowfly head mass: 8mg from (Schilstra & van Hateren 1999)
    m = 8e-6; %kg,
    % L = distance between neck axis and centre of mass, approx 0.25mm
    L = 2.5e-4; %m
    
    % J = m * L^2;
    J = 0.5e-10;
    k = 1e-11;
    c = 1e-9;
    
    % Solve model equations
    tspan = [0 10];
    y0 = [0 sV(500)];
    % opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
    [t,y] = ode45(@(t,y) model_head(t,y,J,k,c,sY,sYt,sV,sVt,rY,rYt), tspan, y0);
    
    clear resp
    resp = y(:,1);
    
    resp_diff = conv(resp,[1,-1]);
    stim_diff = conv(sY,[1,-1]);
    resp_vel  = abs(resp_diff(2:length(resp_diff))*fps);
    stim_vel  = abs(stim_diff(2:length(resp_diff))*fps);
    
    xvalues = linspace(0,2*pi*stim_freq*30,50); %2 times the maximum angular speed of stim
    
    [N,edges] = histcounts(resp_vel,xvalues,'Normalization','pdf');
    result(stim_freq).x_resp=(edges(1:end-1)+edges(2:end))/2;
    result(stim_freq).n_resp=N;
    result(stim_freq).mean_resp=median(resp_vel);
end

for ff = 1:30
    
    mean_1(ff)= nanmean([result(ff).mean_resp]);
    
end

%% plot trace

figure
hold off
plot(sYt,sY,'Color',[0.6,0.6,0.6],'LineWidth',1 )
hold on,
    if chirp_stim   
        plot(t,y(:,1),'Color','k','LineWidth',1 )
    else
        plot(t,y(:,1)- mean(y(:,1)),'Color','k','LineWidth',1 )
    end
    
xlim(tspan)

pbaspect([4,1,1])
hold off
clear t

timesection = [1/800:1/800:10];

errbar = 1;
clear tvecs
tvecs(1,:) = [1:8000];
t(1,:)=0+timesection;
t(2,:)=24.5+timesection;
t(3,:)=4+timesection;
% % for offset axes
% xoffset(1) = 0.02;
% xoffset(2) = 0.05;
% xoffset(3) = 0.05;
% cmap = colormap(lines);
ylim([-40 40])

set(gca,'ytick',[-30,0,30])

set(gca,'yticklabel',{[-30],[0],[30]})
ylabel('Amplitude [\circ]')

xlabel('Time [s]')
set(gca,'box','off')
%      offsetAxes(gca,xoffset(1),0.3);

set(gcf,'color','w');
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter 2\Figures\chirpstim','-painters','-transparent', '-eps','-q101')
% export_fig('C:\Users\Ben\Dropbox\Work\Thesis\Chapter_3\Figures\model_chirp','-openGL','-r660' )

