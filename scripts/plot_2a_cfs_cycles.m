%% blowfly
try
	getHRplotParams
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
    remake_fixed_sines_cv
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_cv_fixed_sines');
end

getHRplotParams
flyname = 'cv';

condSelect = [1,2]; % these refer to positions in array, not original conditions: to change conditions, modify in 'remake_fixed_sines_cv' & rerun analysis 

color_mat = {};
color_mat{condSelect(1)} = cv_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'no halteres'};

plot_cycle_script

%% horsefly
try
	getHRplotParams
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
    remake_fixed_sines_tb
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_tb_fixed_sines');
end

getHRplotParams
flyname = 'tb';

condSelect = [1,3];
% condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = tb_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'intact, dark';'no halteres';'no halteres, dark'};

plot_cycle_script

%% hoverfly
try
	getHRplotParams
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

if bodererun
    remake_fixed_sines_ea
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_ea_fixed_sines');
end

% resp_gain_mean(5,:,:,:) = NaN;
% resp_gain_mean(7,:,:,:) = NaN;

getHRplotParams
flyname = 'ea';

condSelect = [1,2,3];
% condSelect = [1];
% 
color_mat = {};
color_mat{condSelect(1)} = ea_col;
color_mat{condSelect(2)} = [0 0 0];
color_mat{condSelect(3)} = darkGreyCol;

legCell = {'intact';'no ocelli';'+no halteres'};

plot_cycle_script

%% model - need to save 'respcycles','relrespcycles' and 'stimcycles' in 'remake_model_head'
%{
try
	getHRplotParams
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
load('..\mat\DATA_model_fixed_sines_rel_first');

flyname = 'model';

condSelect = [1,1];

color_mat = {};

color_mat{condSelect(1)} = [0 0 0];
color_mat{condSelect(2)} = [0 0 0];
legCell = {'0.5 gain';'0.5 gain'};

% plot_bode_script
plot_cycle_script

%}