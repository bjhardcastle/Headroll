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

condSelect = [1,2];
% condSelect = [1];
bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = cv_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no halteres'};

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
% condSelect = [1];
bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = tb_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no ocelli, dark';'no halteres';'no halteres, dark'};

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

% resp_gain_mean(5,:,:,:) = NaN;
% resp_gain_mean(7,:,:,:) = NaN;

getHRplotParams
flyname = 'ea';

condSelect = [2,3];
% condSelect = [1];
% 
bodecolor_mat = {};
bodecolor_mat{condSelect(1)} = ea_col;
bodecolor_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'no ocelli';'no halteres'};

% restrict range to those available in other flies:
stimfreqs(1) = nan;

plot_bode_script