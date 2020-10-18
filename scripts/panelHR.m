% hide axes/labels before printing
if ~exist('panelflag','var')
    getHRplotParams
end

if panelflag && exist('flyname','var') && exist('plotname','var')
    
    if ismember(flyname,HRpanelOrder)
        pIdx = find(ismember(HRpanelOrder,flyname));
        
        axList = findobj(gcf,'type','Axes');
        
        switch panellayout.(plotname)
            case 'vertical'
                % switch off x-axis label, x-tick labels in all but last
                if pIdx ~= length(HRpanelOrder)
                    for axLIdx = 1:length(axList)
                        axList(axLIdx).XLabel.String = '';
                        axList(axLIdx).XTickLabel = {};
                    end
                end
                
                % switch off title in all but first
                if pIdx ~= 1
                    for axLIdx = 1:length(axList)
                        axList(axLIdx).Title.String = '';
                    end
                end
                
                % switch off y-axis label, y-tick labels in all but center
                if pIdx ~= round(length(HRpanelOrder)/2)
                    for axLIdx = 1:length(axList)
                        axList(axLIdx).YLabel.String = '';
                        %axList(axLIdx).YTickLabel = {};
                    end
                end
                
            case 'horizontal'
                % switch off y-axis label, y-tick labels in all but first
                if pIdx ~= 1
                    for axLIdx = 1:length(axList)
                        axList(axLIdx).YLabel.String = '';
                        axList(axLIdx).YTickLabel = {};
                    end
                end
                
                % switch off x-axis label in all but center
                if pIdx ~= round(length(HRpanelOrder)/2)
                    for axLIdx = 1:length(axList)
                        axList(axLIdx).XLabel.String = '';
                        %axList(axLIdx).XTickLabel = {};
                    end
                end
        end
        
    end
end