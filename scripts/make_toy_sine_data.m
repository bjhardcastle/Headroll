% reproduce slipspeed plots from toy sine-resp data, based on gain/phase
% calculated from actual data for each fly
if exist('phaseVec','var')
    toyPhase = phaseVec;
    toyGain = gainVec;
    
    % we don't need the actual fps, so just get a reasonable value based on
    % the frequency:
    fpsVec = [50,50,50,60,125,250,500,500,1000,1200,1200,1200];
    stimfreqVec = [0.03,0.06,0.1,0.3,0.6,1,3,6,10,15,20,25];

switch flyname
    case 'cv'
    rndn = -2;
    case 'tb'
        rndn = -1;
    case'ea'
        rndn = -2;        
end

toyPhase = toyPhase(:,~isnan(stimfreqs));
toyGain = toyGain(:,~isnan(stimfreqs));
stimfreqs = stimfreqs(~isnan(stimfreqs));
[~,sfIdx] = ismember(stimfreqVec,  roundn(stimfreqs,rndn));
   fpsVec = fpsVec( sfIdx(sfIdx>0 ) );
   
        disp('Using actual gain/phase data')

else
    disp('Using toy gain/phase data')
    % choose manually constructed toy data
flyname = 'tb';
switch flyname
    case 'cv'
        
        toyGain = [];
        toyGain(1,:) = [0.75, 0.55, 0.65, 0.8, 0.75, 0.7, 0.5, 0.4, 0.3 ,0.2];
        toyGain(2,:) = [0.45, 0.45, 0.5, 0.6, 0.8, 0.65, 0.5, 0.15, 0.4, 1 , 0.5];
        
        % phase in deg, +ve = phase-lag
        toyPhase = [];
        toyPhase(1,:) = [30, 30, 25, 25, 25, 0, 0, 0, 5, 15, 25];
        toyPhase(2,:) = [30, 30, -10, -10, -10, -10, 0, 10, 15, 0, 0];
        
        fpsVec = [50,50,60,125,250,500,500,500,1000,1200,1200];
        stimfreqs = [0.06,0.1,0.3,0.6,1,3,6,10,15,20,25];
        
    case tb
        toyGain = [];
        toyGain(1,:) = [0.5, 0.5, 0.55, 0.65, 0.8, 0.75, 0.7, 0.5, 0.4, 0.3 ,0.2];
        toyGain(2,:) = [0.45, 0.45, 0.5, 0.6, 0.8, 0.65, 0.5, 0.15, 0.4, 1 , 0.5];
        
        % phase in deg, +ve = phase-lag
        toyPhase = [];
        toyPhase(1,:) = [30, 30, 25, 25, 25, 0, 0, 0, 5, 15, 25];
        toyPhase(2,:) = [30, 30, -10, -10, -10, -10, 0, 10, 15, 0, 0];
        
        fpsVec = [50,50,60,125,250,500,500,500,1000,1200,1200];
        stimfreqs = [0.06,0.1,0.3,0.6,1,3,6,10,15,20,25];
        
    case 'ea'
        toyGain = [];
        toyGain(1,:) = [0.5, 0.5, 0.55, 0.65, 0.8, 0.75, 0.7, 0.5, 0.4, 0.3 ,0.2];
        toyGain(2,:) = [0.45, 0.45, 0.5, 0.6, 0.8, 0.65, 0.5, 0.15, 0.4, 1 , 0.5];
        
        % phase in deg, +ve = phase-lag
        toyPhase = [];
        toyPhase(1,:) = [30, 30, 25, 25, 25, 0, 0, 0, 5, 15, 25];
        toyPhase(2,:) = [30, 30, -10, -10, -10, -10, 0, 10, 15, 0, 0];
        
        fpsVec = [50,50,60,125,250,500,500,500,1000,1200,1200];
        stimfreqs = [0.06,0.1,0.3,0.6,1,3,6,10,15,20,25];
end
end
%%
flies = 1;
stims = struct;
framerates = struct;
headroll = struct;
for fidx = 1:length(stimfreqs)
    for cidx = 1:size(toyGain,1)
        %%
        t = linspace(0,50,50*fpsVec(fidx)) ;
        p = fpsVec(fidx)*stimfreqs(fidx);
        stim = 30*sin(2*pi*stimfreqs(fidx).*t);
        stims.cond(cidx).freq(fidx).trial(:,1) = stim;
        
        
        resp = 30*toyGain(cidx,fidx)*sin(2*pi*stimfreqs(fidx).*t - deg2rad(toyPhase(cidx,fidx)));
        
        resp = circshift((-toyGain(cidx,fidx).*stim ),round(toyPhase(cidx,fidx)*fpsVec(fidx)/(360*stimfreqs(fidx))))+ stim;
   %% new 
   
   r = toyGain(cidx,fidx)*stim;
   
        if ~exist('bode_rel_first','var') || ~bode_rel_first
    % %  take aligned head angle, subtract from thorax angle
    % % resp_win = ( stim_win - resp_win);   
      % resp = 30*toyGain(cidx,fidx)*sin(2*pi*stimfreqs(fidx).*t - deg2rad(toyPhase(cidx,fidx)));
        r0 = stim-r;
        resp = circshift(r0,-round( (toyPhase(cidx,fidx))*fpsVec(fidx)/(360*stimfreqs(fidx))));
else
    % % just take aligned head angle (resp is already relative to thorax
    % % angle)
   % % resp_win = resp_win;          
%        resp = -(circshift((toyGain(cidx,fidx).*stim ),round(toyPhase(cidx,fidx)*fpsVec(fidx)/(360*stimfreqs(fidx)))))+ stim;
%  resp = resp - mean(resp);
%%% PREVIOUS GOOD:
        r0 = circshift(r,-round(toyPhase(cidx,fidx)*fpsVec(fidx)/(360*stimfreqs(fidx))) );
        resp = r0 + stim;
 %%%%%%
        r0 = stim-r;
        resp = circshift(r0,-round( (toyPhase(cidx,fidx))*fpsVec(fidx)/(360*stimfreqs(fidx))));

        end
               resp = resp - mean(resp);

%%
        headroll.cond(cidx).freq(fidx).trial(:,1) = resp;
        
        framerates(1).cond(cidx).freq(fidx).trial(1) = fpsVec(fidx);
        
        %{
 figure,plot([t;t]',[stim;resp]')
        %}
        %%
    end
end

try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
getHRplotParams

%{
save(fullfile(rootpathHR,'..\mat\TOY_fixed_sines.mat'),'toyGain','toyPhase','headroll','framerates','stims','flies','stimfreqs');
%}

flyname = ['toy_' flyname];
condSelect = [1,2];
color_mat = {};
color_mat{condSelect(1)} = tb_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no halteres'};

bodeprintflag = 0;
plot_slipspeed_script