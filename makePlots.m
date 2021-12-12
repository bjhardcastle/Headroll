function makePlots()
cd(fileparts(mfilename('fullpath'))) % change working directory to this file location
addToPath(1) % add scripts folder to path
plot_0_all % remake all plots and save in 'plots' folder: makes use of options in getHRplotParams.m

function addToPath(manualSave)
%ADDTOPATH Adds folders required for headroll analysis
%
if nargin < 1 || isempty(manualSave) || ( manualSave~=0 && manualSave~=1)
    manualSave = -1;
end

if exist(fullfile(cd,'scripts'),'dir')
    scriptsDir = fullfile(cd,'scripts');
    addpath(genpath(scriptsDir)); % add with all subfolders
else
    disp('required ''scripts'' folder not found: DL from original repository')
    return
end

switch manualSave
    case -1
        % Prompt before saving path permanently
        disp('Analysis folder added to path temporarily.')
        disp('Save path to make it available next time Matlab opens?')
        response = '';
        while ~( strcmpi(response,'y') || strcmpi(response,'n') )
            if ~isempty(response)
                disp('Please enter ''y'' or ''n'' to choose yes or no.')
            end
            [response] = input('[y/n]: ','s');
        end
        
        if strcmpi(response,'y')
            savepath
            disp('Path saved.')
        else
            disp('Path not saved. Run ''addToPath'' again as required.')
        end
    case 1
        % use manual save argument to savepath without prompt
        savepath
    case 0 
        % use manual save argument to skip savepath 
end
