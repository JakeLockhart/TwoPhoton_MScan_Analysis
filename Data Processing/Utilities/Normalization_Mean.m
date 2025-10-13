function NormalizedSignal = Normalization_Mean(Signal)
    % <Documentation>
        % Normalization_Mean()
        %   Normalize a signal relative to its mean.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   NormalizedSignal = Normalization_Mean(Signal)
        %   
        % Description:
        %   This function computes the mean of the given signal and applies a mean-based normalization.
        %       Each value is shifted by subtracting the mean and scaled by dividing the result by the
        %       mean. This produces a signal where values represent the how far the signal deviates from
        %       the dataset's mean.
        %   
        % Input:
        %   Signal - Numeric array (1D)
        %   
        % Output:
        %   NormalizedSignal = Mean normalized signal (1D)
        %   
    % <End Documentation>

    AverageSignal = mean(Signal, 1);
    NormalizedSignal = (Signal - AverageSignal) ./ AverageSignal;

end