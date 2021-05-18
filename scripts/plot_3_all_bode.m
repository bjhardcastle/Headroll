%% blowfly

try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams
cd(fullfile(rootpathHR))

if bodererun
    remake_fixed_sines_cv
    cd(fullfile(rootpathHR))
elseif bode_rel_first
    load('..\mat\DATA_cv_gain_phase_rel_first');
else
    load('..\mat\DATA_cv_gain_phase');
end

getHRplotParams
flyname = 'cv';

condSelect = [1,2]; % these refer to positions in array, not original conditions: to change conditions, modify in 'remake_fixed_sines_cv' & rerun analysis 

bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = cv_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;

legCell = {'intact';'no halteres'};

plot_bode_script

%% horsefly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams
cd(fullfile(rootpathHR))

if bodererun
    remake_fixed_sines_tb
    cd(fullfile(rootpathHR))
elseif bode_rel_first
    load('..\mat\DATA_tb_gain_phase_rel_first');
else
    load('..\mat\DATA_tb_gain_phase');
end

getHRplotParams
flyname = 'tb';

condSelect = [1,3];

bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = tb_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'intact, dark';'no halteres';'no halteres, dark'};

plot_bode_script

%% hoverfly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams
cd(fullfile(rootpathHR))

if bodererun
    remake_fixed_sines_ea
    cd(fullfile(rootpathHR))
elseif bode_rel_first
    load('..\mat\DATA_ea_gain_phase_rel_first');
else
    load('..\mat\DATA_ea_gain_phase');
end

getHRplotParams
flyname = 'ea';

condSelect = [1,3];

bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = ea_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;

%{
 % % To show occluded ocelli condition too:
condSelect = [1,2,3];

bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = ea_col;
bodecolor_mat{condSelect(2)} = [0 0 0];
bodecolor_mat{condSelect(3)} = darkGreyCol;

%}

legCell = {'intact';'no ocelli';'+no halteres'};

% restrict range to those available in other flies:
stimfreqs(1) = nan;

plot_bode_script