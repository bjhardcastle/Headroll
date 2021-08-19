% Some parameter values which are common across plots, for ease of making
% consistent changes
try
    set(groot,'defaultLineLineJoin','Round')
    set(groot,'defaultPatchLineJoin',get(groot,'defaultLineLineJoin'))
catch
end

thisfilepath = mfilename('fullpath'); 
rootpathHR = fullfile(fileparts(thisfilepath));
if strcmp(rootpathHR(end-6:end),'private')
   rootpathHR = rootpathHR(1:end-8);
end
printpath = fullfile(fileparts(rootpathHR),'plots');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOTS

%% Options applied to all plots
HRprintflag = 1; % save pdf/png to disk
errorbardots = 1; % add dots at each datapoint on top of shaded error bar
HRrerun = 0; % re-run analysis and save data

%% Plot aesthetics 
pdfbkgTransparent = 1;
defaultAxisHeight_cm = 5;
defaultImageHeight_cm = 5;
defaultAxisWidth_cm = 5;

axisTickLength = 0.1; % set ticklength  = axisTickLength/ axisDim(max)  in centimeters
axisLabelFontSize = 8;
defaultMarkerSize = 5;
errorbarMarkerSize = 2;
defaultLineWidth = 0.5;
thickLineWidth = 1;

%% Plot size
plotsize_square_half = [103 141 300 240];
plotsize_bode=[   208 295 400 325];

%% save names 

plotnames = struct;
plotnames.CFScycles = 'cfs_cycles';
plotnames.slipspeedPDF = 'slipspeed_pdf';
plotnames.slipspeedMode = 'slipspeed_mode';
plotnames.slipspeedMedian = 'slipspeed_median';
plotnames.chirpTimeseries = 'chirp_timeseries';
plotnames.bode = 'bode';

%% layouts

HRpanelOrder = {'cv';'tb';'ea'}; % for composite figs where plots are presented together we can save some time formatting in matlab
panelflag = 1; % toggle off to leave all axes intact

panellayout = struct;
panellayout.CFScycles = 'vertical';
panellayout.slipspeedPDF = 'vertical';
panellayout.slipspeedMode = 'horizontal';
panellayout.slipspeedMedian = 'horizontal';
panellayout.chirpTimeseries = 'vertical';
panellayout.bode = 'horizontal';

%% chirp plots
chirperrorbar = 1;

%% slipspeed mode/median plot options
SHOWLEGEND = 0;
plotted_as_fraction_of_max_stim = 1.5; % add to getHRplotParams
modeplot = 1;
shadederror = 1;
manualstim=1;

%% individual cycle options

cycleshadederror = 0;
cycle_rel_resp = 0;
if cycleshadederror
    cycindividualflydata = 1; % plot mean data of each fly rather than all trials
else
    cycindividualflydata = 0; % plot all trials
end

%% bode plot options
bodefilterflag = 0; % run additional low freq filter during analysis

bode_rel_first =  0; % 1, subtract HR from TR before calculating gain/phase; 0, calc phase, then subtract and find gain

bodelogXplot = 0;
bodeplotdb = 0;
bodeshadederror = 1;
bodesubplots = 0; %1, gain+phase plots in one fig; 0, separate figs
bodecheckplots = 0; %1 , plot individual time-series when aligning/removing pre-stim/refstim

bodeReconstructSlipspeeds = 0; % sanity check

%% Model functions **
modelrerun = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COLORS

lightGreyCol = [0.9 0.9 0.9];
midGreyCol = [0.75 0.75 0.75];
darkGreyCol = [0.5 0.5 0.5];

% Hoverfly colormap
hov_cols = 	{[0, 120, 90]./255;
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
et_col = hov_cols{2};
et_col = [101,73,49]./255;

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
  

