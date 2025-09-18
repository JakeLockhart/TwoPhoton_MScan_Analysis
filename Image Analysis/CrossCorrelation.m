function [CorrelationCoefficient, Lag] = CrossCorrelation(ReferenceSignal, TargetSignal, Range)
    % <Documentation>
        % CrossCorrelation()
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
        ReferenceSignal
        TargetSignal
        Range (1,2) double {mustBeNumeric}
    end

    ReferenceROI = ReferenceSignal(Range(1):Range(2));
    TargetROI = TargetSignal(Range(1):Range(2));

    [CorrelationCoefficient, Lag] = xcorr(TargetROI, ReferenceROI, 'coeff');



end