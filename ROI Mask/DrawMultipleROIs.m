function ROI = DrawMultipleROIs(ax, ROI_Shape, SaveFigure)
    arguments
        ax
        ROI_Shape char {mustBeMember(ROI_Shape, {'Rectangle', 'Circle', 'Line', 'Polygon', 'Freehand'})} = 'Rectangle'
        SaveFigure char = ''
    end
    fprintf('Draw %s ROIs one by one. Double-click region or press enter to confrim and draw another ROI.\nPress Esc to finish...  \n', ROI_Shape)

    ROI = {};
    Index = 0;

    Image = ancestor(ax, 'figure');
    set(Image, 'KeyPressFcn', @EscListener)
    FinishedDrawingROIs = false;

    while isvalid(Image) && ~FinishedDrawingROIs
        try
            Index = Index + 1;
            TempROI = DrawROI(ax, ROI_Shape);
            if isvalid(TempROI) && ~isempty(TempROI.Position)
                TempROI.Label = sprintf('ROI %d', Index);
                ROI{end+1} = TempROI;
            else
                delete(TempROI)
                break;
            end
        catch
            break;
        end
    end

    if isvalid(Image) && ~isempty(ROI)
        TotalROIs = length(ROI);
        ColorMap = colorcube(TotalROIs);

        for i = 1:TotalROIs
            try
                ROI{i}.Color = ColorMap(i,:);
                ROI{i}.LineWidth = 1;

                if isprop(ROI{i}, 'InteractionsAllowed')
                    ROI{i}.InteractionsAllowed = 'none';
                end
                if isprop(ROI{i}, 'FaceAlpha')
                    ROI{i}.FaceAlpha = 0;
                end
            catch
                % Some draw_() ROIs may not support these properties
            end
        end


        drawnow;

        if ~isempty(SaveFigure)
            SaveFigureWithROIs(SaveFigure);
        end
    end

    fprintf('Finished drawing ROIs ✓\n')

    function EscListener
        if strcmp(event.Key, 'escape')
            FinishedDrawingROIs = true;
        end
    end

    function SaveFigureWithROIs(SaveFigure)
        [~, ~, ext] = fileparts(SaveFigure);
        switch ext
            case '.fig'
                savefig(Image, SaveFigure);
            otherwise
                saveas(Image, SaveFigure);
        end
        fprintf('Figure saved as a %s\n', ext)
    end
end