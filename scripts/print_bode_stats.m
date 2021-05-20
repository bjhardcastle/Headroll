
disp(flyname)
statsWrite = 1;
freq = bodestats.(flyname).freqs(1,:)';
alpha = 0.05;
alpha_corr = alpha/sum(~isnan(freq));
flynames = cellstr(repmat(flyname,length(freq),1));

% Gain
intact = bodestats.(flyname).gainmean(1,:)';
haltereless = bodestats.(flyname).gainmean(2,:)';
deg1 = 30-intact*30;
deg2 = 30-haltereless*30; 
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
sig95 = logical(pval<alpha);
sig_corr = logical(pval<alpha_corr);
gainTable = table(flynames,freq,pval,sig95,sig_corr,intact,haltereless,N1,N2,deg1,deg2)
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
sig95 = pval<alpha;
sig_corr = logical(pval<alpha_corr);
phaseTable = table(flynames,freq,pval,sig95,sig_corr,intact,haltereless,N1,N2)
if statsWrite
writetable(phaseTable,['../plots/bode_phase_stats.xls'],"Range",flyrange,"AutoFitWidth",true)
end