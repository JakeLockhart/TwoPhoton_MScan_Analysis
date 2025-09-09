function ROIProfile = AdjustedImprofile(Image, LineEndPoints, LineWidth)
    % <Documentation>
        % AdjustedImprofile()
        %   
        %   Created by: jsl5865
        %   
        % Syntax:
        %   
        % Description:
        %   
        % Input:
        %   
        % Output:
        %   
    % <End Documentation>

    x = LineEndPoints(:,1);
    y = LineEndPoints(:,2);

    ROI_HalfWidth = round(LineWidth);
    SamplesOnROI = 1000;

    [X, Y, ~] = improfile(Image, x, y, SamplesOnROI);
    if isempty(X)
        ROIProfile = NaN(SamplesOnROI, 1);
        return
    end

    Theta = atan2(Y(end) - Y(1), X(end) - X(1));
    UnitVectorX = -sin(Theta);
    UnitVectorY = cos(Theta);

    Offsets = -ROI_HalfWidth:ROI_HalfWidth;
    OffsetX = X + UnitVectorX * Offsets;
    OffsetY = Y + UnitVectorY * Offsets;

    Values = interp2(double(Image), OffsetX, OffsetY, "linear", 0);

    ROIProfile = mean(Values, 2, 'omitnan');

end