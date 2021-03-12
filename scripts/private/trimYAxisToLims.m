
function trimYAxisToLims(ax)
% thanks to Pierre Morel, undocumented Matlab
% and https://stackoverflow.com/questions/38255048/separating-axes-from-plot-area-in-matlab
%
% by Anne Urai, 2016

if ~exist('ax', 'var'), ax = gca; end


% only set offset axes once per axes
% if ~event.hasListener(ax, 'MarkedClean')
    
    addlistener (ax, 'MarkedClean', @(obj,event)resetVertex(ax));
% end

end

function resetVertex ( ax )
warning('off','MATLAB:callback:error')

% ax.XLim(2) = round(ax.XLim(2), -floor( log10( ax.XTick(2) - ax.XTick(1) ) ) );

% extract the x axis vertext data
% X, Y and Z row of the start and end of the individual axle.
% ax.XRuler.Axle.VertexData(1,1) = min(get(ax, 'Xtick'));
% ax.XRuler.Axle.VertexData(1,2) = max(get(ax, 'Xtick'));

% if strcmp(xoff, 'xoff')
%     ax.XRuler.Axle.VertexData(1:3,1) = 0;
%     ax.XRuler.Axle.VertexData(1:3,2) = 0;
% end

% % repeat for Y (set 2nd row)
ax.YRuler.Axle.VertexData(2,1) = min(get(ax, 'Ytick'));
ax.YRuler.Axle.VertexData(2,2) = max(get(ax, 'Ytick'));
warning('on','MATLAB:callback:error')
end
