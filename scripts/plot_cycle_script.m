% don't call directly this script directly: run from 'plot_2a_cfs_cycles'
plotname = 'CFScycles';
savename = [plotnames.(plotname) '_' flyname ];


c1 = condSelect(1);
c2 = condSelect(2);

switch flyname
    case 'cv'
        rndn = -2;
    case 'tb'
        rndn = -1;
    case 'ea'
        rndn = -2;
    case 'model'
        rndn = 0;
end

% freq range:
plotfreqs = [1,3,6,10,15,20,25];
stimfreqs = stimfreqs(~isnan(stimfreqs));
[~,sfIdx] = ismember(plotfreqs,  roundn(stimfreqs,rndn));
sfIdx(sfIdx ==0) = [];

% cycle resolution:
cycsamples = 100;
stimcycleideal = 30.*sin(linspace(0,2*pi,cycsamples));

for cidx = condSelect
    
    figure('Units','centimeters','Position', [1 1 18 20]);
    ct = 0;
    Nmax = 0; Nmin = 99;
    for freqidx = sfIdx
        
        allrespcyc = []; allstimcyc = [];
        for flyidx = 1:length(respcycles)
            if ~isempty(respcycles(flyidx).cond) ...
                    && length(respcycles(flyidx).cond) >= cidx ...
                    && length(respcycles(flyidx).cond(cidx).freq) >= freqidx ...
                    && ~isempty(respcycles(flyidx).cond(cidx).freq{freqidx})
                try
                    stim = stimcycles(flyidx).cond(cidx).freq{freqidx};
                    stim = stim';
                    resp = respcycles(flyidx).cond(cidx).freq{freqidx};
                    resp = resp';
                    thisfps = framerates(flyidx).cond(cidx).freq(freqidx).trial;
                    thisfreq = stimfreqs(freqidx);

                    for cycidx = 1:size(resp,1)
                        % Then interpolate the current trial data to fit the time points in the
                        % standard trial (timeVector)
                        fitcyc = interp1( linspace(0,1/thisfreq,size(resp,2)) , resp(cycidx,:) , linspace(0,1/thisfreq, cycsamples) );
                        fitcyc = fitcyc - nanmean(fitcyc);
                        % figure,plot(fitcyc),pause(0.1),close gcf
                        allrespcyc = [allrespcyc; fitcyc];
                        
                        fitcyc = interp1( linspace(0,1/thisfreq,size(stim,2)) , stim(cycidx,:) , linspace(0,1/thisfreq, cycsamples) );
                        fitcyc = fitcyc - nanmean(fitcyc);
                        % figure,plot(fitcyc),pause(0.1),close gcf
                        allstimcyc = [allstimcyc; fitcyc];
                        
                    end
                catch
                    disp('some cycles different length/framerate')
                end
                %             else
                %                 disp('conditions not present')
            end
        end
        
        allstimcyc = allstimcyc';
        allrespcyc = allrespcyc';
        allcycMean = nanmean(allrespcyc,2);
        allcycStd = nanstd(allrespcyc,[],2);
        
        ct = ct+1;
        subplot(2,length(sfIdx),ct)
        hold on

%         plot(allrespcyc,'Color',[color_mat{cidx} 0.02],'LineWidth',0.01)
                plot(allstimcyc,'Color',[color_mat{cidx} 0.02],'LineWidth',0.01)
plot(stimcycleideal,'Color',midGreyCol,'LineWidth',defaultLineWidth)
        t = title (['', num2str(roundn(thisfreq,rndn)), ' Hz']);
        
        %         title(['N = ' num2str(size(allcyc,2))],'FontSize',6)
        %         plot(allcycMean,'Color',[plotcol 0.8],'LineWidth',2)
        ylim([-65,65])
       
        set(gca,'ytick',[-30,0,30])
        set(gca,'yticklabel',{'-30','','30'})
        set(gca,'xtick',[1 cycsamples])
        set(gca,'xticklabel',[])
                
%         daspect([100 60 1])

        set(gca,'clipping','off')
%         daspect(gca,[100 80 1])
        ax = gca;
        ax.XAxis.Visible = 'off';
        ax.YAxis.Label.String = 'Roll angle (\circ)';
        if ct > 1
            ax.YAxis.Visible = 'off';
        else
            trimYAxisToLims(gca) 
        end
        
        setHRaxes(gca,2.38,1.5)
        
        if length(respcycles) > Nmax
            Nmax = length(respcycles);
        end
        if length(respcycles) < Nmin
            Nmin = length(respcycles);
        end  

    end
    %     linkaxes
    tightfig(gcf)

    
    if Nmin == Nmax
        suffix = ['C' num2str(cidx) '_N=' num2str(Nmin)];
    else
        suffix = ['C' num2str(cidx) '_N=' num2str(Nmin) 'to' num2str(Nmax)];
    end
    
    if bodeprintflag
        printHR
    end
    
end