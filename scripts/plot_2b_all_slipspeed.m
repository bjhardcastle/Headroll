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
    bode_rel_first = 0;
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

plot_slipspeed_script

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
    bode_rel_first = 0;
    remake_fixed_sines_tb
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_tb_fixed_sines');
end

getHRplotParams
flyname = 'tb';

condSelect = [1,3];

color_mat = {};
color_mat{condSelect(1)} = tb_col;
color_mat{condSelect(2)} = darkGreyCol;
legCell = {'intact';'intact, dark';'no halteres';'no halteres, dark'};

plot_slipspeed_script

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
    bode_rel_first = 0;
    remake_fixed_sines_ea
    cd(fullfile(rootpathHR))
else
    load('..\mat\DATA_ea_fixed_sines');
end

getHRplotParams
flyname = 'ea';

condSelect = [1,3];

color_mat = {};
color_mat{condSelect(1)} = ea_col;
color_mat{condSelect(2)} = darkGreyCol;

legCell = {'intact';'no halteres'};

plot_slipspeed_script

%% model
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
load('..\mat\DATA_model_fixed_sines');

flyname = 'model';

condSelect = [1,1];

color_mat = {};

color_mat{condSelect(1)} = [0 0 0];
color_mat{condSelect(2)} = [0 0 0];
legCell = {'0.5 gain';'0.5 gain'};

plot_slipspeed_script