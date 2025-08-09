function ROI = DrawROI(ax, ROI_Shape)
    arguments
        ax (1,1) matlab.graphics.axis.Axes
        ROI_Shape char {mustBeMember(ROI_Shape, {'Rectangle', 'Circle', 'Line', 'Polygon', 'Freehand'})} = 'Rectangle'
    end

    title(ax, sprintf('Draw a ROI\n(%s)', ROI_Shape));

    switch ROI_Shape
        case 'Rectangle'
            ROI = drawrectangle(ax);
        case 'Circle'
            ROI = drawcircle(ax);
        case 'Line'
            ROI = drawline(ax);
        case 'Polygon'
            ROI = drawpolygon(ax);
        case 'Freehand'
            ROI = drawfreehand(ax);
        otherwise
            error('ROI shape not available')
    end

    wait(ROI);
end
