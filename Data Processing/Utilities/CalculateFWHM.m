function [FWHM, Edge1, Edge2] = CalculateFWHM(x, y)
    % <Documentation>
        % CalculateFWHM()
        %   Computes the Full-Width at Half-Maximum (FWHM) of a signal and returns the detected edges.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   [FWHM, Edge1, Edge2] = CalculateFWHM(x, y)
        %   
        % Description:
        %   This function normalizes the input signal to a [0, 1] scale, determines the half-maximum (0.5), 
        %       and identifies the first and last indice where the signal is above the 0.5 threshold. These 
        %       positions are mapped to the signal's time scale and calculates the FWHM/edge locations.
        %
        % Input:
        %   x - Vector of the x-axis corresponding to the signal (distance along ROI)
        %   y - Vector of the y-axis values representing the signal's intensity at each 'x' 
        %   
        % Output:
        %   FWHM    - Full Width at Half Maximum, (Edge 2 - Edge 1) which represents signal's width
        %   Edge1   - First x-value where the signal crosses the half-maximum threshold
        %   Edge2   - Last x-value where the signal crosses the half-maximum threshold
        %   
    % <End Documentation>

    y = y - min(y);
    y = y / max(y);

    HalfMax = 0.5;

    UpperRegion = y >= HalfMax;
    idx = find(UpperRegion);
    if isempty(idx)
        FWHM = NaN;
        Edge1 = NaN;
        Edge2 = NaN;
        return
    end

    Edge1 = x(idx(1));
    Edge2 = x(idx(end));
    FWHM = Edge2 - Edge1;

end