% Some parameter values which are common across plots, for ease of making
% consistent changes 
thisfilepath = mfilename('fullpath'); 
rootpathHR = fullfile(fileparts(thisfilepath));
printpath = fullfile(fileparts(rootpathHR),'plots');

%% Colors %%

lightGreyCol = [0.9 0.9 0.9];
midGreyCol = [0.75 0.75 0.75];
darkGreyCol = [0.5 0.5 0.5];


% Colors (trying to fit with Omoto 2017 diagrams)
%
% 
% TuBuCols(1,:) = [109 148 207]./255;   % inferior bulb 
% TuBuCols(2,:) = [57 80 163]./255;     % superior bulb
% TuBuCols(3,:) = [119 104 169]./255;   % anterior bulb
% TuBuCols(4,:) = [0 158 173]./255;     % TuTu
% 
% MeTuCols(1,:) = [84 207 96]./255;     % lighter green 
% MeTuCols(2,:) = [51 153 52]./255;     % darker green 
% 

objCols.R49E09_AOTU = [109 148 207]./255;   % inferior bulb 
objCols.R88A06_AOTU = [57 80 163]./255;     % superior bulb
objCols.R34H10_AOTU = [119 104 169]./255;   % anterior bulb
objCols.R49E09_Bu = [109 148 207]./255;     % inferior bulb 
objCols.R88A06_Bu = [57 80 163]./255;       % superior bulb
objCols.R88A06_Bu_ant = [87 74 130]./255;   % anterior bulb (in 88A06)
objCols.R34H10_Bu = [119 104 169]./255;     % anterior bulb
objCols.R73C04_AOTU = [84 207 96]./255;     % lighter green 
objCols.R56F07_AOTU = [51 153 52]./255;     % darker green 
objCols.R17F12_AOTU = [0 158 173]./255;     % turquoise 
objCols.R7R8 = [190 50 160]./255;           % purple/pink
objCols.DmDRA = [165 60 190]./255;          % purple/lilac
objCols.R34D03_Bu = [217 82 25]./255;       % red/orange
objCols.R34D03_EB = [200 62 55]./255;       % red/orange
objCols.R19C08_Bu = [220 25 34]./255;       % red
objCols.R78B06_Bu = [192 27 72]./255;       % red/purple
objCols.SS00096_PB = [203 158 56]./255;     % yellow 

fig2s3ROIcols(1,:) = [32 96 33]./255;       % dark green
fig2s3ROIcols(2,:) = [51 153 52]./255;      % mid green
fig2s3ROIcols(3,:) = [159 223 160]./255;    % light green
fig2s3ROIcols(4,:) = [33 32 96]./255;       % dark blue
fig2s3ROIcols(5,:) = [65 64 191]./255;      % mid blue
fig2s3ROIcols(6,:) = [160 159 223]./255;    % light blue

%%
% Hoverfly colormap 
hov_cols = 	{      [0, 120, 90]./255;
            [0, 69, 52]./255;
      [190, 175, 8]./255;
            [117, 107, 5]./255; 
            [0.6 0.6 0.6]};
        
%Horsefly colormap blue (C1-2) red(C3-4)
horse_cols = {[51 155 255]./255;
    [0 76 153]./255;
    [255 102 102]./255;
    [153 0 0]./255;
    [0.6 0.6 0.6]};

robber_cols = {[70 190 8]./255;
    [43,117,5]./255;
    [190,8,70]./255;
    [117,5,43]./255;
    [0.6 0.6 0.6]};

% Blowfly colormap blue (C1-3) orange (C4-5). C6 = grey
color_mat = {[150 185 255]./255;
    [0 114 189]./255;
    [0 30 120]./255;
    [246 156 30]./255;
    [215 110 0]./255;
    [0.6 0.6 0.6]};

% original from thesis
eb_col = hov_cols{3};
ea_col = hov_cols{1};
tb_col = horse_cols{3};
cv_col = color_mat{2};

% rgb more saturated version of thesis cols
eb_col = [187 181 48]./255;
ea_col =  [66 151 37]./255;
tb_col =  [208 40 92]./255;
cv_col =  [19 95 194]./255;

% approx. eye-color
eb_col = [221 54 24]./255;
ea_col =  [117 120 0]./255;
tb_col =  [56 25 9]./255;
cv_col =  [212 81 0]./255;

% Plot size
plotsize_square_half = [103 141 300 240];
plotsize_bode=[   208 295 400 325];
%%

plotnames = struct;
plotnames.CFScycles = 'cfs_cycles';
plotnames.slipspeedPDF = 'slipspeed_pdf';
plotnames.slipspeedMode = 'slipspeed_mode';
plotnames.slipspeedMedian = 'slipspeed_median';
plotnames.chirpTimeseries = 'chirp_timeseries';
plotnames.bode = 'bode';

%%
HRpanelOrder = {'cv';'tb';'ea'}; % for composite figs where plots are presented together we can save some time formatting in matlab 
panelflag = 1; % toggle off to leave all axes intact

panellayout = struct;
panellayout.CFScycles = 'vertical';
panellayout.slipspeedPDF = 'vertical';
panellayout.slipspeedMode = 'horizontal';
panellayout.slipspeedMedian = 'horizontal';
panellayout.chirpTimeseries = 'vertical';
panellayout.bode = 'horizontal';



%% slipspeed mode/median plot options
SHOWLEGEND = 0;
plotted_as_fraction_of_max_stim = 1.5; % add to getHRplotParams
modeplot = 1;
shadederror = 0;
manualstim=1;

%% individual cycle options 
cycleshadederror = 0; 
cycle_rel_resp = 0;
cycindiviualflydata = 0; % plot mean data of each fly rather than all trials
%% bode plot options
bodererun = 0; % re-run analysis and save data
bodefilterflag = 0; % run additional low freq filter during analysis

bode_rel_first =  0; % 1, subtract HR from TR before calculating gain/phase; 0, calc phase, then subtract and find gain 

bodelogXplot = 0; 
bodeplotdb = 0; 
bodeshadederror = 1; 
bodesubplots = 0; %1, gain+phase plots in one fig; 0, separate figs
bodecheckplots = 0; %1 , plot individual time-series when aligning/removing pre-stim/refstim

bodeprintflag = 1 ;

bodeReconstructSlipspeeds = 0; % sanity check 
%% Model functions **
modelrerun = 0;

%% Plot aesthetics ** 
pdfbkgTransparent = 1;
defaultAxisHeight_cm = 5;
defaultImageHeight_cm = 5;
defaultAxisWidth_cm = 5;

axisTickLength = 0.1; % set ticklength  = axisTickLength/ axisDim(max)  in centimeters
axisLabelFontSize = 8;
defaultMarkerSize = 5;
defaultLineWidth = 0.5;
thickLineWidth = 1;