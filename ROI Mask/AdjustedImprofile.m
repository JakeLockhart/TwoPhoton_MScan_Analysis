function ROIProfile = AdjustedImprofile(Image, LineEndPoints, LineWidth)
    % <Documentation>
        % AdjustedImprofile()
        %   Samples the pixel intensity values along a user-defined line with adjustable thickness.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ROIProfile = AdjustedImprofile(Image, LineEndPoints, LineWidth)
        %   
        % Description:
        %   This function calculates an intensity profile along a line segment in an image. This is 
        %       an extention of MatLab's improfile() by allowing the profile to have a 'thickness' 
        %       which allows for averaging across the line's width to produce a smoothed intensity 
        %       profile. This allows for more robust intensity measurements when the profile is meant 
        %       to represent a 'band' rather than a single-pixel width line.
        %   The number of samples across the profile is fixed to 1000 samples.
        %   Larger line width values produce smoother profiles by averaging over a wider range.
        %
        % Input:
        %   Image         - 2D image (2D numerical array) to extract the pixel intensity 
        %   LineEndPoints - 2x2 matrix specifying the [x,y] coordinates of the line endpoints:
        %                   [x1 y1; x2 y2]
        %   LineWidth     - Scalar specifying the half-width (in pixels) of the band perpendicular to
        %                   the line profile. 
        %   
        % Output:
        %   ROIProfile - Column vector containing the averaged intensity values along the line profile.
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