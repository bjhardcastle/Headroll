%% blowfly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
    bode_rel_first = 0;
    remake_fixed_sines_cv
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_cv_fixed_sines');
end

getHRplotParams
printpath = '..\plots\';
flyname = 'cv';

condSelect = [1,2];
% condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = cv_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no halteres'};

% plot_bode_script
plot_slipspeed_script

%% horsefly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
        bode_rel_first = 0;
remake_fixed_sines_tb
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_tb_fixed_sines');
end

getHRplotParams
printpath = '..\plots\';
flyname = 'tb';

condSelect = [1,3];
% condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = tb_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'no ocelli';'no ocelli, dark';'no halteres';'no halteres, dark'};

% plot_bode_script
plot_slipspeed_script
%% hoverfly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
    bode_rel_first = 0;
    remake_fixed_sines_ea
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_ea_fixed_sines');
end

% resp_gain_mean(5,:,:,:) = NaN;
% resp_gain_mean(7,:,:,:) = NaN;

getHRplotParams
printpath = '..\plots\';
flyname = 'ea';

condSelect = [2,3];
% condSelect = [1];
% 
color_mat = {};
color_mat{condSelect(1)} = ea_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'no ocelli';'no halteres'};

% plot_bode_script
plot_slipspeed_script

%% model
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end

getHRplotParams

if modelrerun
    clearvars
    remake_model_head
end

clearvars
getHRplotParams
load('..\mat\DATA_model_fixed_sines');

printpath = '..\plots\';
flyname = 'model';

condSelect = [1,1];

color_mat = {};

color_mat{condSelect(1)} = [0 0 0];
color_mat{condSelect(2)} = [0 0 0];
legCell = {'0.5 gain';'0.5 gain'};

% plot_bode_script
plot_slipspeed_script