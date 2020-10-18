clear all
load 'DATA_hf_fixed_sines_nonrelslip.mat'

% headroll(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)

slipspeedcts = [];
for freqidx = 2: length(stimfreqs)
    
    numbins = 201;
    % numbins of velocity, up to 1.5*max velocity experienced
    % cycle is 120degrees (4*30 deg amp)
    vellim = 200 + 5*stimfreqs(freqidx)*120;
    binvec(freqidx,:) = linspace(0,vellim,numbins);
    
    for condidx = 1:3   % c1 = intact, c2 = ocelli occluded, c3 = ocelli occluded + halteres off
        idxcounter = 0;
        
        for flyidx = 1:length(flies)
            for trialidx = 0:size(headroll(flyidx).cond(condidx).freq(freqidx).trial,2)
                if trialidx > 0 && ~isnan(headroll(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx))
                    
                    idxcounter = idxcounter + 1;
                    headvel = [];thoraxvel = [];
                    
                    % take derivative of each time series, convert to deg/s
                    headvel = abs(diff(headroll(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)) ...
                        * framerates(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx) );
                    
                    % c4:c6 = thorax roll (obtained from reference stim, not
                    % analysed per trial) for c1:3
                    thoraxvel = abs(diff(stims(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)) ...
                        * framerates(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx) );
                    
                    % perform histcounts on each current resp/stim (number
                    % of bins = length(binvec)
                    slipspeedcts.f(freqidx).c(condidx).t(idxcounter,:) = histcounts(headvel,binvec(freqidx,:));
                    slipspeedcts.f(freqidx).c(condidx + 3).t(idxcounter,:) = histcounts(thoraxvel,binvec(freqidx,:));
                    
                end
            end
        end
        if condidx == 3
            thorax_slipspeed = [];
            % For the current frequency, plot c2 vs c3 slipspeed velocity
            % distributions ( no ocelli, vs no ocelli, no halteres )
            
            % For headfixed-equivalent condition, we use the stim traces,
            % ie. the thorax velocity distributions. Get the total sums for
            % all 3 conditions, then divide by 3 to get an average, while
            % maintaining a comparable 'count number' on y-axis
            thorax_slipspeed = ( nansum(slipspeedcts.f(freqidx).c(4).t) + nansum(slipspeedcts.f(freqidx).c(5).t) + nansum(slipspeedcts.f(freqidx).c(6).t) )/3;
            figure
            hold on
            plot(binvec(freqidx,1:end-1) , nansum(slipspeedcts.f(freqidx).c(2).t))
            plot(binvec(freqidx,1:end-1) , nansum(slipspeedcts.f(freqidx).c(3).t))
            plot(binvec(freqidx,1:end-1) , thorax_slipspeed,'k')
            xlabel('angular velocity, \circ /s')
            title(['Hoverfly, n = 5: ',num2str(stimfreqs(freqidx)),' Hz'])
            pause
        end
        
    end
end

% accummulate velocities for all flies for each freq.

% plot for each freq