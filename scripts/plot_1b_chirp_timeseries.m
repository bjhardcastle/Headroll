%% blowfly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

    load('..\mat\DATA_cv_chirp');

getHRplotParams
flyname = 'cv';

condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = cv_col;

plot_chirp_timeseries_script
%% horsefly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

    load('..\mat\DATA_tb_chirp');

getHRplotParams
flyname = 'tb';

condSelect = [1];
color_mat = {};
color_mat{1} = tb_col;

plot_chirp_timeseries_script
%% e.aeneus
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

load('..\mat\DATA_ea_chirp');
% end

getHRplotParams
flyname = 'ea';

condSelect = [1];
% 
color_mat = {};
color_mat{1} = ea_col;

plot_chirp_timeseries_script
%% e.balteatus
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

load('..\mat\DATA_eb_chirp');

getHRplotParams
flyname = 'eb';

condSelect = [1];

color_mat = {};
color_mat{1} = eb_col;

plot_chirp_timeseries_script

%% e.tenax
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

load('..\mat\DATA_et_chirp');

getHRplotParams
flyname = 'et';

condSelect = [1];

color_mat = {};
color_mat{1} = et_col;

plot_chirp_timeseries_script

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
load('..\mat\DATA_model_chirp');

flyname = 'model';

condSelect = [1];

color_mat = {};


color_mat{condSelect(1)} = [0 0 0];

cond.flymeans = cond.mean; % for mseb, variance is zero since data is simulated

plot_chirp_timeseries_script