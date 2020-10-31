%% blowfly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

% if bodererun
%     bode_rel_first = 0;
%     remake_fixed_sines_cv
%     cd(fullfile(rootpathHR))
% else
    load('..\mat\DATA_cv_chirp');
% end

getHRplotParams
flyname = 'cv';

% condSelect = [1,2];
condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = cv_col;
% color_mat{condSelect(2)} = darkGreyCol;
% legCell = {'no ocelli';'no halteres'};

% plot_bode_script
% plot_slipspeed_script
plot_chirp_timeseries_script
%% horsefly
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

% if bodererun
%         bode_rel_first = 0;
% remake_fixed_sines_tb
%     cd(fullfile(rootpathHR))
% else
    load('..\mat\DATA_tb_chirp');
% end

getHRplotParams
flyname = 'tb';

% condSelect = [1,3];
condSelect = [1];
color_mat = {};
color_mat{condSelect(1)} = tb_col;
% color_mat{condSelect(2)} = darkGreyCol;
% legCell = {'no ocelli';'no ocelli, dark';'no halteres';'no halteres, dark'};

% plot_bode_script
% plot_slipspeed_script
plot_chirp_timeseries_script
%% ea
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

% if bodererun
%         bode_rel_first = 0;
% remake_fixed_sines_ea
%     cd(fullfile(rootpathHR))
% else
load('..\mat\DATA_ea_chirp');
% end

getHRplotParams
flyname = 'ea';

% condSelect = [1,3];
condSelect = [2];
% 
color_mat = {};
color_mat{condSelect(1)} = ea_col;
% color_mat{condSelect(2)} = darkGreyCol;
% legCell = {'intact';'no ocelli';'no halteres'};

% plot_bode_script
% plot_slipspeed_script
plot_chirp_timeseries_script
%% eb
try
    cd(fullfile(rootpathHR))
catch
    cd('G:\My Drive\Headroll\scripts')
end
clearvars
getHRplotParams

% if bodererun
%         bode_rel_first = 0;
% remake_fixed_sines_ea
%     cd(fullfile(rootpathHR))
% else
load('..\mat\DATA_eb_chirp');
% end

getHRplotParams
flyname = 'eb';

condSelect = [1];

color_mat = {};
color_mat{condSelect(1)} = eb_col;
% color_mat{condSelect(2)} = darkGreyCol;

% plot_bode_script
% plot_slipspeed_script
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

% plot_bode_script
% plot_slipspeed_script
plot_chirp_timeseries_script