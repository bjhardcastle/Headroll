% freq range:
stimfreqVec = [1,3,6,10,15,20,25];

switch flyname
    case 'cv'
        rndn = -2;
    case 'tb'
        rndn = -1;
    case 'ea'
        rndn = -2;
end
stimfreqs = stimfreqs(~isnan(stimfreqs));
[~,sfIdx] = ismember(stimfreqVec,  roundn(stimfreqs,rndn));
sfIdx(sfIdx ==0) = [];

figure, ct = 0;
for cidx = 1:2
    for freqidx = sfIdx
        
        allcyc = [];
        for flyidx = 1:length(cycles)
            if ~isempty(cycles(flyidx).cond) ...
                    && length(cycles(flyidx).cond) >= cidx ...
                    && length(cycles(flyidx).cond(cidx).freq) >= freqidx ...
                    && ~isempty(cycles(flyidx).cond(cidx).freq{freqidx}) 
                try
                    allcyc = [allcyc;   cycles(flyidx).cond(cidx).freq{freqidx}'];
                catch
                    disp('some cycles different length/framerate')
                end
            end
        end
        
        
        allcyc = allcyc - nanmean(allcyc,2);
        allcyc = allcyc';
        allcycMean = nanmean(allcyc,2);
        allcycStd = nanstd(allcyc,[],1);
        
        ct = ct+1;
        subplot(2,length(sfIdx),ct)
        plot(allcyc,'Color',[0.8 0.1 0.1 0.1])%,'LineWidth',0.05)
        hold on
        %plot(allcycMean,'Color',[0.8 0.1 0.1 0.8],'LineWidth',2)
        
    end
end