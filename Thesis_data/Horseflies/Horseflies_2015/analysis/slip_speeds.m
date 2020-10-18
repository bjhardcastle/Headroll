clear all
load 'Z:\Ben\Horseflies_2015\analysis\DATA_hf_fixed_sines_nonrelslip.mat'

% headroll(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)

for freqidx = 2: length(stimfreqs)
    
    numbins = 101;
    % numbins of velocity, up to 1.5*max velocity experienced
    % cycle is 120degrees (4*30 deg amp)
    vellim = 200 + 5*stimfreqs(freqidx)*120;

    binvec(freqidx,:) = linspace(0,vellim,numbins);
    
    for condidx = 1:4   % c1 = intact, c2 = halteres off, c3 = intact dark, c4 = halteres off dark
        idxcounter = 0;
        
        for flyidx = 1:length(flies)
            for trialidx = 0:size(headroll(flyidx).cond(condidx).freq(freqidx).trial,2)
                if trialidx > 0 && ~isnan(headroll(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx))
                    
                    idxcounter = idxcounter + 1;
                    headvel = [];thoraxvel = [];
                    
                    % take derivative of each time series, convert to deg/s
                    headvel = abs(diff(headroll(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)) ...
                        * framerates(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx) );
                    
                    % c5:c8 = thorax roll for c1:4
                    thoraxvel = abs(diff(stims(flyidx).cond(condidx).freq(freqidx).trial(:,trialidx)) ...
                        * framerates(flyidx).cond(condidx).freq(freqidx).trial(1,trialidx) );
                    
                    % perform histcounts on each current resp/stim (number
                    % of bins = length(binvec)
                    slipspeedcts.f(freqidx).c(condidx).t(idxcounter,:) = histcounts(headvel,binvec(freqidx,:));
                    slipspeedcts.f(freqidx).c(condidx + 4).t(idxcounter,:) = histcounts(thoraxvel,binvec(freqidx,:));
                    
                end
            end
        end
        if condidx == 4
            thorax_slipspeed = [];
            % For the current frequency, plot c1 vs c3 slipspeed velocity
            % distributions ( intact lightON vs no halteres, lightON ) )
            
            % For headfixed-equivalent condition, we use the stim traces,
            % ie. the thorax velocity distributions. Get the total sums for
            % all 4 conditions, then divide by 4 to get an average, while
            % maintaining a comparable 'count number' on y-axis
            thorax_slipspeed = ( nansum(slipspeedcts.f(freqidx).c(5).t) + nansum(slipspeedcts.f(freqidx).c(5).t) ...
                + nansum(slipspeedcts.f(freqidx).c(7).t) + nansum(slipspeedcts.f(freqidx).c(8).t) )/4;
            figure
            hold on
            plot(binvec(freqidx,1:end-1) , nansum(slipspeedcts.f(freqidx).c(1).t))
            plot(binvec(freqidx,1:end-1) , nansum(slipspeedcts.f(freqidx).c(3).t))
            plot(binvec(freqidx,1:end-1) , thorax_slipspeed,'k')
            xlabel('angular velocity, \circ /s')
            title(['Horsefly, n = 4: ',num2str(stimfreqs(freqidx)),' Hz'])
            pause
        end
        
    end
end

% accummulate velocities for all flies for each freq.

% plot for each freq