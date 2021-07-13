%% Tb
clearvars
getHRplotParams

load('..\Thesis_data\Horseflies\Horseflies_2015\analysis\DATA_horsefly_chirp.mat');

framerates = 800;
flies = [2,3,4,5];
stimfreqs = 51;

cond = struct;
flymean = [];
for cidx = 1:length(headroll.fly(1).cond)
    for fidx = 1:length(headroll.fly)
        [~,meanIdx] = min(size(headroll.fly(fidx).cond(cidx).trial));
        flymean(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial, meanIdx);
    end
    
    cond(cidx).mean = nanmean(flymean,1);
    cond(cidx).flymeans = flymean;
    cond(cidx).framerates = framerates;
    cond(cidx).flies = flies;
    cond(cidx).stimfreqs = stimfreqs;
end

load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(framerates) '.mat'])
if size(x,1)>size(x,2)
    x = x';
end
refstim = x;

save(fullfile(rootpathHR,'..\mat\DATA_tb_chirp.mat'),'cond','refstim')

%% Ea
clearvars
getHRplotParams
load('..\Thesis_data\Hoverflies\Aenus_sine_chirp\DATA_chirp.mat');

framerates = 1200;
flies = [1,2,3,4,5,7];
stimfreqs = 51;

cond = struct;
flymean = [];
for cidx = 1:length(headroll.fly(1).cond)
    for fidx = 1:length(headroll.fly)
        [~,meanIdx] = min(size(headroll.fly(fidx).cond(cidx).trial));
        try
            flymean(fidx,:) = nanmean(headroll.fly(fidx).cond(cidx).trial, meanIdx);
        catch
            trials = [];
            for tidx = 1:size(headroll.fly(fidx).cond(cidx).trial, meanIdx)
                if meanIdx == 1
                    trial = headroll.fly(fidx).cond(cidx).trial(:,tidx);
                else
                    trial = headroll.fly(fidx).cond(cidx).trial(tidx,:);
                end
                
                if all(isnan(trial))
                    trials(tidx,:) = nan(1,framerates*10);
                else
                    disp('check trial length')
                end
            end
            flymean(fidx,:) = nanmean(trials,1);
        end
    end
    
    cond(cidx).mean = nanmean(flymean,1);
    cond(cidx).flymeans = flymean;
    cond(cidx).framerates = framerates;
    cond(cidx).flies = flies;
    cond(cidx).stimfreqs = stimfreqs;
end

load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(framerates) '.mat'])
if size(x,1)>size(x,2)
    x = x';
end
refstim = x;

save(fullfile(rootpathHR,'..\mat\DATA_ea_chirp.mat'),'cond','refstim')

%% Eb
clearvars
getHRplotParams
load('..\Thesis_data\Hoverflies\Aenus_sine_chirp\episyrph_chirp.mat');

flies = [1:13];
stimfreqs = 51;
framerates = 800;

cond = struct;
flymean = [];
for cidx = 1
    for fidx = 1:size(chirp,1)
        flymean(fidx,:) = chirp(fidx,:);
    end
    cond(cidx).mean = nanmean(flymean,1);
    cond(cidx).flymeans = flymean;
    cond(cidx).framerates = framerates;
    cond(cidx).flies = flies;
    cond(cidx).stimfreqs = stimfreqs;
end

load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(framerates) '.mat'])
if size(x,1)>size(x,2)
    x = x';
end
refstim = x;

save(fullfile(rootpathHR,'..\mat\DATA_eb_chirp.mat'),'cond','refstim')

%% Et
remake_chirp_et
clearvars
getHRplotParams
load('..\Thesis_data\Hoverflies\Eristalis Sines\Hoverflies_2015\eristalis_chirp_example.mat')


flies = [1];
stimfreqs = 51;
framerates = 800;

cond = struct;
flymean = [];
for cidx = 1
    for fidx = 1
        flymean(fidx,:) = resp(:,3);
    end
    cond(cidx).mean = nanmean(flymean,1);
    cond(cidx).flymeans = flymean;
    cond(cidx).framerates = framerates;
    cond(cidx).flies = flies;
    cond(cidx).stimfreqs = stimfreqs;
end

load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(framerates) '.mat'])
if size(x,1)>size(x,2)
    x = x';
end
refstim = x;

save(fullfile(rootpathHR,'..\mat\DATA_et_chirp.mat'),'cond','refstim')

%% Cv
clearvars
getHRplotParams
load('..\Thesis_data\Blowflies\Chirps\Karin2015 analysis\wind.mat');

framerates = 800;
flies = [9,10,11,12,13,14,15,16];
stimfreqs = 51;


cond = struct;
flymean = [];
for cidx = 1:length(headroll.wind.fly(1).cond)
    for fidx = 1:length(headroll.wind.fly)
        [~,meanIdx] = min(size(headroll.wind.fly(fidx).cond(cidx).trial));
        try
            flymean(fidx,:) = nanmean(headroll.wind.fly(fidx).cond(cidx).trial, meanIdx);
        catch
            trials = [];
            for tidx = 1:size(headroll.wind.fly(fidx).cond(cidx).trial, meanIdx)
                if meanIdx == 1
                    trial = headroll.wind.fly(fidx).cond(cidx).trial(:,tidx);
                else
                    trial = headroll.wind.fly(fidx).cond(cidx).trial(tidx,:);
                end
                
                if all(isnan(trial))
                    trials(tidx,:) = nan(1,framerates*10);
                else
                    disp('check trial length')
                end
            end
            flymean(fidx,:) = nanmean(trials,1);
        end
    end
    
    cond(cidx).mean = nanmean(flymean,1);
    cond(cidx).flymeans = flymean;
    cond(cidx).framerates = framerates;
    cond(cidx).flies = flies;
    cond(cidx).stimfreqs = stimfreqs;
end

load(['..\Thesis_data\Hoverflies\Aenus_sine_chirp\reference_stim\chirp_' num2str(framerates) '.mat'])
if size(x,1)>size(x,2)
    x = x';
end
refstim = x;

save(fullfile(rootpathHR,'..\mat\DATA_cv_chirp.mat'),'cond','refstim')

%% model
remake_model_head