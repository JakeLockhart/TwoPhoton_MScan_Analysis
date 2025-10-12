function [CorrelationMatrix, Lag] = SlidingCrossCorrelation(ReferenceSignal, TargetSignal, WindowSize)
    % <Documentation>
        % SlidingCrossCorrelation()
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

    TotalIndices = length(ReferenceSignal);
    TotalWindows = TotalIndices - WindowSize + 1;
    
    [DemoCC, Lag] = CrossCorrelation(DemoReference, DemoTarget, [1, WindowSize]);
    CorrelationMatrix = zeros(length(DemoCC), TotalWindows);

    for i = 1:TotalWindows
        Range = [i, i + WindowSize - 1];
        [CC, ~] = CrossCorrelation(ReferenceSignal, TargetSignal, Range);
        CorrelationMatrix(:,i) = CC;
    end

end