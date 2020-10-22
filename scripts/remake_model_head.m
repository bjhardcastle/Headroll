getHRplotParams

% Physical parameters
% m = blowfly head mass: 8mg from (Schilstra & van Hateren 1999)
m = 8e-6; %kg,

% L = distance between neck axis and centre of mass, approx 0.25mm
L = 0.00025; %m

% R = radius of head, approx 2mm
R = 0.002;

J = 2/3*(m*R^2); % for thin-walled spherical shell
J = 3.5e-10; % Sabattier et al., 2014, from (Schilstra & van Hateren 1999)

k = 1e-7;
c = 1e-8;
% k = 1e-7; % Sabattier et al., 2014, 
% c = 1e-8; % Sabattier et al., 2014, 

% Stabilization effort:
head_lag = 0.005; % Constant delay of 5ms (motor system)
stab_gain = 0.000000001;

% Stimulus parameters
amp = 30; % +/- stimulus roll angle
% fps = 800; % for fixed sines only: currently loading reference chirp stim
% t_step = 1/fps;
% t_max = 10; % trial time, seconds
% t_length = 2*t_max/t_step;

for chirp_stim = 1%[1,0]
    headroll = struct;
    stims = struct;
    framerates = struct;
    
    if chirp_stim
        stimfreqs = 51;
    else
        stimfreqs = [0.1,1,3,6,10,15,20,25];
        stimrates = [500,500,500,500,1000,1000,1000,1000];
    end
    
    for fIdx  = 1:length(stimfreqs)
        stim_freq = stimfreqs(fIdx);
        
        
        if ~chirp_stim    % Sine stimulus trace
           fps = stimrates(fIdx);
            t_max = 20/stim_freq; % at least 20 cycles
            if t_max < 10
                t_max = 10;
            end
            stimtime = t_max;
            t_step = 1/fps;

    t_length = 2*t_max*fps;
            sYt = linspace(-t_max,t_max,t_length);
            sY = amp*sin(stim_freq*2*pi*sYt);
            stims(1).cond(1).freq(fIdx).trial = sY'; % for saving to disk in same format as experiments..
            framerates(1).cond(1).freq(fIdx).trial = fps; % for saving to disk in same format as experiments..
            
            % Get stimulus velocity
            sV = diff(sY)/t_step;
            sVt = linspace(-t_max,t_max,length(sV));
            stimtime = t_max;
                 
            % Get active stabilization effort (near zero while looking at passive
        % response)
        rY = circshift(stab_gain*sY,ceil(head_lag*fps),2); % Relative movement of head, approx half of stim, opp direction
        rYt = linspace(-t_max,t_max,length(rY));
        
        elseif chirp_stim % Chirp stimulus trace
            %%
            fps = 800;
            t_max = 10;
            stimtime = t_max; %s
            %cfps = 2*stimtime*fps;
            halftime = 0.5*stimtime*fps;
            chirp_freq = 40.5/fps;
            Phase = 0;
            %k = 0.5*(stim_freq - 0)/cfps/halftime;
            chirp_rate = 0.5*(chirp_freq - 0)/halftime;
            
            Stim_sin = amp*sin( Phase + 2*pi* (0*(1:halftime) + 0.5*chirp_rate*(1:halftime).^2 ) );
            %Stim_sin = [Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')) -fliplr(Stim_sin(1:find(floor(Stim_sin*1000) ==0,1,'last')))];
            Stim_sin = [Stim_sin -fliplr(Stim_sin)];
            
            %Stim_sin(end:2*halftime) = 0;
            
            %%
            chirp_fps = 800;   % 800 | 1000 | 1200 fps available
            load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(chirp_fps) '.mat'])
            %                 figure, plot(linspace(0,10,12000),x)
            %                 hold on
            %                 plot(linspace(0,10,fps*10),Stim_sin)
            Stim_sin = x;
            if size(Stim_sin,1) == length(Stim_sin)
                Stim_sin = Stim_sin';
            end
            fps = chirp_fps;
            t_step = 1/chirp_fps;
            stims(1).cond(1).trial = Stim_sin; % for saving to disk in same format as experiments..
            framerates(1).cond(1).trial = fps;
            
            
            % 1 second of zero padding from t=-1:0 (so that velocity at t=0 can be
            % calculated)
            sY1 = Stim_sin;            
            %sY1 = downsample(Stim_sin,4*length(Stim_sin)/fps);
            sY = [zeros(1,fps) sY1 zeros(1,fps)];
            sYt = linspace(-1,stimtime+1,length(sY));
            
            % Get stimulus velocity
            sV = diff(sY)/t_step;
            sVt = linspace(-1,stimtime+1,length(sV));
               
            % Get active stabilization effort (near zero while looking at passive
        % response)
        rY = circshift(stab_gain*sY,ceil(head_lag*fps),2); % Relative movement of head, approx half of stim, opp direction
        rYt = linspace(-1,stimtime,length(rY));
        
end
        
        % Solve model equations
        tspan = sYt;%[0 t_max];
        y0 = [0 sV(fps)];
        % opts = odeset('RelTol',1e-2,'AbsTol',1e-4);
        [t,y] = ode45(@(t,y) model_head(t,y,J,k,c,sY,sYt,sV,sVt,rY,rYt), tspan, y0);
        
        
        %{
        figure
        hold off
        plot(sYt,sY,'Color',[0.6,0.6,0.6],'LineWidth',1 )
        hold on,
        if chirp_stim
            plot(t,y(:,1),'Color','k','LineWidth',1 )
        else
            plot(t,y(:,1)- mean(y(:,1)),'Color','k','LineWidth',1 )
        end
        
        %xlim(tspan)
        
        pbaspect([4,1,1])
        %}
        
        
        
        if ~chirp_stim
            % assign for saving fixed_sines data
            headroll(1).cond(1).freq(fIdx).trial = y(sYt>0,1);
        else
            
            % assign for saving chirp data
            cond = struct;
            cond.mean = y(sYt>0 & sYt<=10,1)';
            cond.flymeans = [];
            cond.framerates = length(y(:,1))/10;
            cond.flies = [];
            cond.stimfreqs = 51;
            
            load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(chirp_fps) '.mat'])
            if size(x,1)>size(x,2)
                x = x';
            end
            refstim = resample(x,length(y(:,1)),length(x));
        end
    end
    
    if ~chirp_stim
        save(fullfile(rootpathHR,'..\mat\DATA_model_fixed_sines.mat'),'headroll','framerates','stims','stimfreqs');
    else
        % old format: save(fullfile(rootpathHR,'..\mat\DATA_model_chirp.mat'),'headroll','stims','framerates');
        % new:
        save(fullfile(rootpathHR,'..\mat\DATA_model_chirp.mat'),'cond','refstim')
    end
end
%% plot trace
%{
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

% set(gca,'yticklabel',{-30,0,30})
ylabel('Roll angle (\circ)')

xlabel('Time (s)')
set(gca,'box','off')
%      offsetAxes(gca,xoffset(1),0.3);

set(gcf,'color','w');
%}
