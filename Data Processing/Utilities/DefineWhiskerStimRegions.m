function StimulationEdges = DefineWhiskerStimRegions(WhiskerStimulationSignal, SamplingRate)
    % <Documentation>
        % DefineWhiskerStimRegions()
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

    Threshold = 0.1*max(WhiskerStimulationSignal);
    BinarySignal = WhiskerStimulationSignal > Threshold;

    MinPulseGap = 0.5 * SamplingRate;
    GapArray = ones(1, MinPulseGap);
    
    StimulationBlock = imclose(BinarySignal, GapArray);

    RisingEdge = find(diff([0, StimulationBlock]) == 1);
    FallingEdge = find(diff([StimulationBlock, 0]) == -1);

    StimulationEdges = [RisingEdge(:), FallingEdge(:)]/1000;

end