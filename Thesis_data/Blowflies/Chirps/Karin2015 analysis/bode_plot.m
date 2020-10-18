% Find mean responses for each fly, then find mean
clear all,
load ref_stim.mat

wind_cond{1} =('wind');
wind_cond{2} =('no_wind');

for f = 1:2;
    clear headroll
    clear headroll_means
    headrollfile = strcat(wind_cond{f},'.mat');
    load(headrollfile);
    
    headroll_means=[];
    for c = 1:5
        for testflies = 1:length(headroll)
            
            try
                if ~isnan(headroll(testflies).cond(c).trial),
                    headroll_means(:,testflies,c) = nanmean(headroll(testflies).cond(c).trial,2);
                else
                    headroll_means(:,testflies,c) = NaN(8000,1);
                end
            catch
            end
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
            'XLim',[0 25])
        title([wind_cond{f}])
        showConfidence(h,3)
    end
end

%
% figure
% h = spectrumplot(g);
% % showConfidence(h,3)

