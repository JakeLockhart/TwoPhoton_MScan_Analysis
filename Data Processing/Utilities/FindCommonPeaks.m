function [PeakLocations, PeakWidths] = FindCommonPeaks(VectorArray, TimeAxis, MinProminence)
    % <Documentation>
        % FindCommonPeaks()
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

    arguments
        VectorArray
        TimeAxis
        MinProminence (1,1) double {mustBeNumeric, mustBePositive} = 0.2
    end

    AverageDataSet = mean(VectorArray, 2);
    [~, PeakLocations, PeakWidths] = findpeaks(AverageDataSet, TimeAxis, ...
                               "MinPeakProminence", MinProminence, ...
                               "WidthReference", "halfheight" ...
                              );
    PeakWidths = PeakWidths*2;

end