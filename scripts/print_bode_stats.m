
disp(flyname)
statsWrite = 1;
freq = bodestats.(flyname).freqs(1,:)';
alpha = 0.05%/length(freq);
flynames = cellstr(repmat(flyname,length(freq),1));

% Gain
intact = bodestats.(flyname).gainmean(1,:)';
haltereless = bodestats.(flyname).gainmean(2,:)';
N1 = bodestats.(flyname).gainN(1,:)';
N2 = bodestats.(flyname).gainN(2,:)';
pval = nan(size(freq));
for fidx = 1:length(freq)
    c = bodestats.(flyname).gainvals{1}(:,fidx);
    c1 = c(~isnan(c));
        
    c = bodestats.(flyname).gainvals{2}(:,fidx);
    c2 = c(~isnan(c));

    % implement stats for gain vals
    pval(fidx) = ranksum(c1,c2,'tail','right');
end
sig = logical(pval<alpha);
gainTable = table(flynames,freq,pval,sig,intact,haltereless,N1,N2)
if statsWrite
writetable(gainTable,['../plots/bode_gain_stats.xls'],"Range",flyrange,"AutoFitWidth",true)
end
%% Phase
intact = bodestats.(flyname).phasemean(1,:)';
haltereless = bodestats.(flyname).phasemean(2,:)';
N1 = bodestats.(flyname).phaseN(1,:)';
N2 = bodestats.(flyname).phaseN(2,:)';
pval = nan(size(freq));
for fidx = 1:length(freq)
    c = bodestats.(flyname).phasevals{1}(:,fidx);
    c1 = c(~isnan(c));

    c = bodestats.(flyname).phasevals{2}(:,fidx);
    c2 = c(~isnan(c));

    % implement stats for phase vals
    %[pval, table] = circ_wwtest([c1;c2],[ones(size(c1));2*ones(size(c2))])
%     [h mu ul ll] = circ_mtest(c2, c1mean(fidx), alpha);
    pval(fidx) = ranksum(c1,c2,'tail','right');
end
sig = pval<alpha;
phaseTable = table(flynames,freq,pval,sig,intact,haltereless,N1,N2)
if statsWrite
writetable(phaseTable,['../plots/bode_phase_stats.xls'],"Range",flyrange,"AutoFitWidth",true)
end