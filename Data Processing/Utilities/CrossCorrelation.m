function [CorrelationCoefficient, Lag] = CrossCorrelation(ReferenceSignal, TargetSignal, Range)
    % <Documentation>
        % CrossCorrelation()
        %   Computes the normalzied cross-correlation between a reference signal and target signal within a defined range.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   [CorrelationCoefficient, Lag] = CrossCorrelation(ReferenceSignal, TargetSignal, Range)
        %   
        % Description:
        %   This function applies a cross correlation between a reference signal and the target signal. The cross correlation
        %       is applied across the 'Range' defined by the user. 
        %   Maximum correlation between two curves has a coefficient of 1 and completely out of phase signals have a 
        %       coefficient of 0. The lag is a measure the shows how the target signal precedes or follows the reference 
        %       signal.  
        %   
        % Input:
        %   ReferenceSignal - Numeric vector (1D) representing the reference signal.
        %   TargetSignal    - Numeric vector (1D) representing the signal which will be compared to the reference signal.
        %   Range           - Two element array [Start Index, End Index], dictating which region of the signals to compare.
        %
        % Output:
        %   CorrelationCoefficient - Vector of normalized correlation values between the target and refrence signals.
        %   Lag                    - Vector of lag indices corresponding to each correlation coefficinet value.
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