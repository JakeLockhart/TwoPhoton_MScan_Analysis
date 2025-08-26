function ROI = DrawROI(ax, ROI_Shape)
    arguments
        ax (1,1) matlab.graphics.axis.Axes
        ROI_Shape char {mustBeMember(ROI_Shape, {'Rectangle', 'Circle', 'Line', 'Spline', 'Polygon', 'Freehand'})} = 'Rectangle'
    end

    switch ROI_Shape
        case 'Rectangle'
            ROI = drawrectangle(ax);
        case 'Circle'
            ROI = drawcircle(ax);
        case 'Line'
            ROI = drawline(ax);
        case 'Spline'
            ROI = drawfreehand(ax, "Closed", false, "FaceAlpha", 0);
        case 'Polygon'
            ROI = drawpolygon(ax);
        case 'Freehand'
            ROI = drawfreehand(ax);
        otherwise
            error('ROI shape not available')
    end

    AdjustROIThickness(ROI, ax);
    wait(ROI);
end
