plotname = 'chirpTimeseries';
savename = [plotnames.(plotname) '_' flyname ];

fps = cond(condSelect).framerates;

figure('Position',  [100 150 500 150]);
hold on

errbar = 0;

tVec = linspace(10/length(refstim),10,length(refstim));
plot(tVec,refstim,'Color',midGreyCol,'LineWidth',defaultLineWidth )

if length( cond(condSelect).mean ) ~= length(refstim)
    tVec = linspace(10/length(cond(condSelect).mean),10,length(cond(condSelect).mean));
end

if errbar == 1
    %error bar on:
    lineprops.col = {color_mat{1}};
    lineprops.linewidth = defaultLineWidth;
    mseb(tVec, cond(condSelect).mean, nanstd(cond(condSelect).flymeans,[],1)./sqrt(size(cond(condSelect).flymeans,1)), lineprops, 1 );
else
    plot(tVec, cond(condSelect).mean,'Color',color_mat{condSelect},'LineWidth',defaultLineWidth )
end

ylim([-30 30])
ylim([-32 40])

set(gca,'ytick',[-30,0,30])
% set(gca,'yticklabel',{[num2str(-30) '\circ'],[],[num2str(30) '\circ']})
set(gca,'yticklabel',{[num2str(-30)],[],[num2str(30)]})
ylabel('Roll angle (\circ)')
xlabel('Time (s)')

offsetAxes(gca);
setHRaxes(gca,[],6)
tightfig(gcf)
% addExportFigToolbar
if ~isempty(cond(condSelect).flies)
    suffix = ['_N=' num2str(length(cond(condSelect).flies))];
end

if bodeprintflag
printHR
end
