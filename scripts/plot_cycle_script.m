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
stimcycle = 30.*sin(linspace(0,2*pi,cycsamples));

for cidx = condSelect
    
    figure('Units','centimeters','Position', [1 1 18 4]);
    ct = 0;
    Nmax = 0; Nmin = 99;
    for freqidx = sfIdx
        
        allcyc = [];
        for flyidx = 1:length(cycles)
            if ~isempty(cycles(flyidx).cond) ...
                    && length(cycles(flyidx).cond) >= cidx ...
                    && length(cycles(flyidx).cond(cidx).freq) >= freqidx ...
                    && ~isempty(cycles(flyidx).cond(cidx).freq{freqidx})
                try
                    cycs = cycles(flyidx).cond(cidx).freq{freqidx};
                    thisfps = framerates(flyidx).cond(cidx).freq(freqidx).trial;
                    thisfreq = roundn(stimfreqs(freqidx),rndn);
                    %                     if size(cycs,2)<size(cycs,1)
                    cycs = cycs';
                    %                     end
                    for cycidx = 1:size(cycs,1)
                        % Then interpolate the current trial data to fit the time points in the
                        % standard trial (timeVector)
                        fitcyc = interp1( linspace(0,ceil(1/thisfreq),size(cycs,2)) , cycs(cycidx,:) , linspace(0,ceil(1/thisfreq), cycsamples) );
                        fitcyc = fitcyc - nanmean(fitcyc);
                        % figure,plot(fitcyc),pause(0.1),close gcf
                        allcyc = [allcyc; fitcyc];
                    end
                catch
                    disp('some cycles different length/framerate')
                end
                %             else
                %                 disp('conditions not present')
            end
        end
        
        allcyc = allcyc';
        allcycMean = nanmean(allcyc,2);
        allcycStd = nanstd(allcyc,[],2);
        
        ct = ct+1;
        subplot(2,length(sfIdx),ct)
        hold on

        plot(allcyc,'Color',[color_mat{cidx} 0.1],'LineWidth',0.01)
        plot(stimcycle,'Color',[0 0 0],'LineWidth',defaultLineWidth)
        t = title (['', num2str(thisfreq), ' Hz']);
        
        %         title(['N = ' num2str(size(allcyc,2))],'FontSize',6)
        %         plot(allcycMean,'Color',[plotcol 0.8],'LineWidth',2)
        ylim([-40,40])
       
        set(gca,'ytick',[-30,0,30])
        set(gca,'yticklabel',{'-30','','30'})
        set(gca,'xtick',[1 cycsamples])
        set(gca,'xticklabel',[])
                
        pbaspect([1.2 1 1])

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
        
        if length(cycles) > Nmax
            Nmax = length(cycles);
        end
        if length(cycles) < Nmin
            Nmin = length(cycles);
        end
    end
    %     linkaxes
    
    
    setHRaxes(gca,1.5)
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