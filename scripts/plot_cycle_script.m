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
        
        allrespcyc = []; allstimcyc = []; flymeancyc = [];
        for flyidx = 1:length(respcycles)
            if ~isempty(respcycles(flyidx).cond) ...
                    && length(respcycles(flyidx).cond) >= cidx ...
                    && length(respcycles(flyidx).cond(cidx).freq) >= freqidx ...
                    && ~isempty(respcycles(flyidx).cond(cidx).freq{freqidx})
%                 try
                    stim = stimcycles(flyidx).cond(cidx).freq{freqidx};
                    stim = stim';
                    if cycle_rel_resp
                        resp = relrespcycles(flyidx).cond(cidx).freq{freqidx};
                    else
                        resp = respcycles(flyidx).cond(cidx).freq{freqidx};
                    end
                    resp = resp';
                    thisfps = framerates(flyidx).cond(cidx).freq(freqidx).trial;
                    thisfreq = stimfreqs(freqidx);
                    
                                flyrespcyc = [];

                    for cycidx = 1:size(resp,1)
                        % Then interpolate the current trial data to fit the time points in the
                        % standard trial (timeVector)
                        fitcyc = interp1( linspace(0,1/thisfreq,size(resp,2)) , resp(cycidx,:) , linspace(0,1/thisfreq, cycsamples) );
                        fitcyc = fitcyc - nanmean(fitcyc);
                        %                         if (cidx == 3 && any(ismember(flyidx,[5,6,7,8]))) || (cidx == 1 && flyidx==8)
                        %                             fitcyc = fitcyc./2;
                        %                         end
                        if ~all(fitcyc==0)
                            allrespcyc = [allrespcyc; fitcyc];
                            flyrespcyc = [flyrespcyc; fitcyc];
                        end
                        
                        fitcyc = interp1( linspace(0,1/thisfreq,size(stim,2)) , stim(cycidx,:) , linspace(0,1/thisfreq, cycsamples) );
                        fitcyc = fitcyc - nanmean(fitcyc);
                        % figure,plot(fitcyc),pause(0.1),close gcf
                        if ~all(fitcyc==0)
                            allstimcyc = [allstimcyc; fitcyc];
                        end
                    end
%                 catch
%                     disp('some cycles different length/framerate')
%                 end
                         
if ~isempty(flyrespcyc)
                flymeancyc = [flymeancyc; nanmean(flyrespcyc)];
            end

            end
        end
        
        allstimcyc = allstimcyc';
        allrespcyc = allrespcyc';
        flymeancyc = flymeancyc';
        %          if cycle_rel_resp
        %             allrespcyc = -allrespcyc;
        %         end
        allcycMean = nanmean(allrespcyc,2);
        allcycMean = allcycMean - nanmean(allcycMean);
        allcycStd = nanstd(allrespcyc,[],2);
        
        
        flycycMean = nanmean(flymeancyc,2);
        flymeancyc = flymeancyc - nanmean(flymeancyc);
        flycycStd = nanstd(flymeancyc,[],2);
        
        ct = ct+1;
        subplot(1,length(sfIdx),ct)
        hold on
        
        if cycindividualflydata
            indivData = flymeancyc;
            meanData = flycycMean;
            varData = flycycStd;
        else
            indivData = allrespcyc;
            meanData = allcycMean;
            varData = allcycStd;
        end
        
        
        if cycleshadederror
            
            lineprops.col = {color_mat{cidx}};
            lineprops.width = defaultLineWidth;
            
            h1{cidx} = mseb(linspace(1,length(meanData)),meanData',varData',lineprops,1);
            %             mseb(allrespcyc,'Color',[color_mat{cidx} 0.02],'LineWidth',0.01)
            
            plot(stimcycleideal,'Color',midGreyCol,'LineWidth',defaultLineWidth)
            
        else
            
            % % actual data:
            plot(indivData,'Color',[color_mat{cidx} 0.05],'LineWidth',0.01)
            
            % % to confirm freq/fps/phase of stim cycles (testing):
            %             plot(allstimcyc(:,2:end),'Color',[color_mat{cidx} 0.02],'LineWidth',0.01)
            
            plot(stimcycleideal,'Color',midGreyCol,'LineWidth',defaultLineWidth)
            
            if cycindividualflydata
                plot(meanData,'Color',[color_mat{cidx}],'LineWidth',defaultLineWidth)
                plot(indivData,'Color',[color_mat{cidx} 0.3],'LineWidth',0.3*defaultLineWidth)

            end
            
        end
        
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
        if ct > 1 || HRprintflag
            ax.YAxis.Visible = 'off';
        else
            trimYAxisToLims(gca)
        end
        set(gca,'color',[1 1 1 0]);
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
    if cycleshadederror
        suffix = [suffix '_mseb'];
    end
    if HRprintflag
        
        printHR
    end
    
end