function [FWHM, Edge1, Edge2] = CalculateFWHM(x, y)
    % <Documentation>
        % CalculateFWHM()
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