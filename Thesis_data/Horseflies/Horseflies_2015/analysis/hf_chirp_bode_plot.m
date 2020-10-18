% Find mean responses for each fly, then find mean
%
% Assumes 8000 sample length (800fps)
clear all,
load 'Z:\Ben\Horseflies_2015\analysis\reference_stim\chirp_800.mat';
ref_stim = x;




    clear headroll
    clear headroll_means
    headrollfile = 'DATA_hf_chirp.mat';
    load(headrollfile);
    
    headroll_means=[];
    for fly = 1:length(headroll)
        for c = 1:4
%             for t = 1: size(headroll(fly).cond(c).freq.trial,2)
%                 if ~isnan(headroll(fly).cond(c).freq.trial)
                    headroll_means(:,fly,c) = nanmean(headroll(fly).cond(c).freq.trial,2);   
%                 else headroll_means(:,fly,c) = NaN(8000,1);
%                 end 
%             end
        end
    end

    
    figure
    for c = 1:4
        d = iddata(nanmean(headroll_means(:,:,c),2),ref_stim(1:8000),1/800);
        w = linspace(0.5,65);
        g = spa(d,40,w);
        hold on
        h = bodeplot(g);
        setoptions(h,'FreqUnits','Hz',...
            'FreqScale','linear',...
            'MagUnits','dB',...
            'XLim',[0 10])
        title('Horsefly chirp response')
        showConfidence(h,3)
    end

% figure
% h = spectrumplot(g);
% % showConfidence(h,3)

