%% Plot graphs for Tabanus bromius chirp experiments
% C1 Intact, light
% C2 Intact, dark
% C3 Hs off, light
% C4 Hs off, dark

% load horsefly chirp data
if ~exist('tbload_chirp','var')
    clear all
    load('..\mat\DATA_tb_chirp.mat') % was DATA_horsefly_chirp.mat from processing
    tbload_chirp=1;
end

getHRplotParams
printpath = '..\plots\';
savename = 'chirp_abs_timeseries';



% organise mean responses
flies = [2,3,4,5];
freqs = [51];
fps = 800;
lencond = 4;

clear condmean* allmean*
% mean condition for each fly
for cidx = 1:lencond
    for fidx = 1:length(flies)
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            condmean(cidx).fly(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial,2);
            condmeanstim(cidx).fly(fidx,:) = nanmean(stims.fly(fidx).cond(cidx).trial,2);
        end
    end
    allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);
    
end


% aggregate all trials for all flies, by condition
for cidx = 1:lencond
    
    allidx = 0;
    for fidx = 1:length(flies)
        
        % ts = length trials, tn = num trials
        [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
        if ts > 2 % trial data exists
            for tidx = 1: tn
                allidx = allidx + 1;
                condallfly(cidx).all(allidx,:) = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                condallflystim(cidx).all(allidx,:) = stims.fly(fidx).cond(cidx).trial(:,tidx);
            end
        end
        
        
    end
    condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(flies) - 1);
    condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(flies) - 1);
    
end

% % plot mean traces for each condition (n=4)
% %

t = [1/fps:1/fps:10];
figure
errbar = 0;

% head position

for cidx = 1
    
    plot(t,nanmean(condmeanstim(cidx).fly),'Color',midGreyCol,'LineWidth',defaultLineWidth )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly),'Color',tb_col,'LineWidth',defaultLineWidth )
    end
    
    ylim([-30 30])
    %     title('')
    
end




set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/fps:1/fps:10];

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
% set(gca,'yticklabel',{[num2str(-30) '\circ'],[],[num2str(30) '\circ']})
set(gca,'yticklabel',{[num2str(-30)],[],[num2str(30)]})
ylabel('Roll angle (\circ)')
xlabel('Time (s)')

offsetAxes(gca);
setHRaxes(gca,[],7)
tightfig(gcf)
addExportFigToolbar
suffix = ['tb_N=' num2str(length(flies))];
printHR


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfile for plotting Eristalinus aeneus CHIRP DATA
% c1 - intact
% c2 - ocelli painted, lights on 
% c3 - ocelli painted, without halteres, lights on
if ~exist('eaload_chirp','var')
    clear all
    load ('..\mat\DATA_ea_chirp.mat')
    eaload_chirp=1;
end

getHRplotParams
printpath = '..\plots\';
savename = 'chirp_abs_timeseries';


% organise mean responses
flies = [1,2,3,4,5,7];
lencond = 3;
fps = 1200;

clear cond* allmean*
% mean condition for each fly

% Unlike the blowfly data, we have 1 trial per fly here EXCEPT fly 1, where
% there are 8 trials. So take mean trial for fly 1, then continue process
    for cidx = 1:lencond
        for fidx = 1:length(flies) %fly 8 is missing wind cond
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                condmean(cidx).fly(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial,2);
                condmeanstim(cidx).fly(fidx,:) = nanmean(stims.fly(fidx).cond(cidx).trial,2);
            else
                condmean(cidx).fly(fidx,:) = NaN(1,12000);
                condmeanstim(cidx).fly(fidx,:) = NaN(1,12000);

            end
        end
        allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);

    end


% aggregate all trials for all flies, by condition

    for cidx = 1:lencond
        
        allidx = 0;
        for fidx = 1:length(flies)
            
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                for tidx = 1: tn
                    allidx = allidx + 1;
                    condallfly(cidx).all(allidx,:) = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                    condallflystim(cidx).all(allidx,:) = stims.fly(fidx).cond(cidx).trial(:,tidx);
                end
                
            else
                condmean(cidx).fly(fidx,:) = NaN(1,12000);
                condmeanstim(cidx).fly(fidx,:) = NaN(1,12000);

            end
            
            
        end
        condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(flies) - 1);
        condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(flies) - 1);
        
    end


% plot mean traces for each condition (n=6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


t = [1/fps:1/fps:10];
figure
errbar = 0;

% head position

for cidx = 2
    
    plot(t,nanmean(condmeanstim(cidx).fly),'Color',midGreyCol,'LineWidth',defaultLineWidth )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly),'Color',ea_col,'LineWidth',defaultLineWidth )
    end
    
    ylim([-30 30])
    %     title('')
    
end




set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/fps:1/fps:10];

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
% set(gca,'yticklabel',{[num2str(-30) '\circ'],[],[num2str(30) '\circ']})
set(gca,'yticklabel',{[num2str(-30)],[],[num2str(30)]})
ylabel('Roll angle (\circ)')
xlabel('Time (s)')

offsetAxes(gca);
setHRaxes(gca,[],7)
tightfig(gcf)
addExportFigToolbar
suffix = ['ea_N=' num2str(max(sum(~isnan(condmean(cidx).fly))))];
printHR




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot graphs for episyrphus  chirp experiments
if ~exist('ebload_chirp','var')
    clear all
    load ('..\mat\DATA_eb_chirp.mat')
    ebload_chirp=1;
end

getHRplotParams
printpath = '..\plots\';
savename = 'chirp_abs_timeseries';

fps = 800;

% plot mean traces for condition 1 (n=8)
%

t = [1/fps:1/fps:10];
figure
errbar = 0;

cidx = 1;
clear cond* all*
condmean(cidx).fly = chirp;
condsem(cidx).fly = nanstd(chirp,1)./sqrt(sum(~isnan(chirp(:,1))));

for cidx = 1
    
    plot(t, refstim','Color',midGreyCol,'LineWidth',defaultLineWidth )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly),'Color',eb_col,'LineWidth',defaultLineWidth )
    end
    
    ylim([-30 30])
    %     title('')
    
end




set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/fps:1/fps:10];

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
% set(gca,'yticklabel',{[num2str(-30) '\circ'],[],[num2str(30) '\circ']})
set(gca,'yticklabel',{[num2str(-30)],[],[num2str(30)]})
ylabel('Roll angle (\circ)')
xlabel('Time (s)')

offsetAxes(gca);
setHRaxes(gca,[],7)
tightfig(gcf)
addExportFigToolbar
suffix = ['eb_N=' num2str(max(sum(~isnan(condmean(cidx).fly))))];
printHR


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Subfile for plotting calliphora vicina CHIRP DATA
% c1 - intact
% C1 Intact, light
% C2 Intact, dark
% C3 Hs off, light
% C4 Hs off, dark
if ~exist('cvload_chirp','var')
    clear all
    load ('..\mat\DATA_cv_chirp.mat')
    cvload_chirp=1;
end

getHRplotParams
printpath = '..\plots\';
savename = 'chirp_abs_timeseries';


% organise mean responses
flies = [9,10,11,12,13,14,15,16];
%fly 8 is missing wind cond
fps = 800;

clear condmean
% mean condition for each fly
for widx = 1 %just use with wind cond
    for cidx = 1:5
        for fidx = 1:length(flies) %fly 8 is missing wind cond
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.wind(widx).fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                condmean(cidx).fly(fidx,:) = nanmean(headroll.wind(widx).fly(fidx).cond(cidx).trial,2);
                condmeanstim(cidx).fly(fidx,:) = nanmean(stims.wind(widx).fly(fidx).cond(cidx).trial,2);
            end
        end
        allmeanstim(cidx,:) = nanmean(condmeanstim(cidx).fly);
    % Makes no difference working out relative response with mean head
    % traces compared to doing it with individual traces, so do it here:
    allmeanrel(cidx,:) = nanmean(condmeanstim(cidx).fly) - nanmean(condmean(cidx).fly);
    allmean(cidx,:) = nanmean(condmean(cidx).fly);

    end
end

clear condallfly
% aggregate all trials for all flies, by condition
for widx = 1 %just use with wind cond
    for cidx = 1:5
        
        allidx = 0;
        for fidx = 1:length(flies)
            
            % ts = length trials, tn = num trials
            [ts,tn] = size(headroll.wind(widx).fly(fidx).cond(cidx).trial);
            if ts > 2 % trial data exists
                for tidx = 1: tn
                    allidx = allidx + 1;
                    condallfly(cidx).all(allidx,:) = headroll.wind(widx).fly(fidx).cond(cidx).trial(:,tidx);
                    condallflystim(cidx).all(allidx,:) = stims.wind(widx).fly(fidx).cond(cidx).trial(:,tidx);
                end
            end
            
            
        end
        condsem(cidx,:) = nanstd(condallfly(cidx).all)/sqrt(length(flies) - 1);
        condsemstim(cidx,:) = nanstd(condallflystim(cidx).all)/sqrt(length(flies) - 1);
        
    end
end


t = [1/fps:1/fps:10];
figure(89)
errbar = 0;

% head position

for cidx = 1
    
    plot(t,nanmean(condmeanstim(cidx).fly),'Color',midGreyCol,'LineWidth',defaultLineWidth )
    hold on
    if errbar == 1
        %error bars on:
        mseb(t, nanmean(condmean(cidx).fly), condsem(cidx,:) );
    else
        plot(t, nanmean(condmean(cidx).fly),'Color',cv_col,'LineWidth',defaultLineWidth )
    end
    
    ylim([-30 30])
    %     title('')
    
end




set(gcf,'Position', [103 141 600 150]);
hold off
clear t

timesection = [1/fps:1/fps:10];

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
% set(gca,'yticklabel',{[num2str(-30) '\circ'],[],[num2str(30) '\circ']})
set(gca,'yticklabel',{[num2str(-30)],[],[num2str(30)]})
ylabel('Roll angle (\circ)')
xlabel('Time (s)')

offsetAxes(gca);
setHRaxes(gca,[],7)
tightfig(gcf)
addExportFigToolbar
suffix = ['cv_N=' num2str(length(flies))];
printHR


