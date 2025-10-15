function VesselDiameter = ProcessVesselDiameter(VesselDiameter, FPS)
    % <Documentation>
        % ProcessVesselDiameter()
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

    FWHM = mat2cell(VesselDiameter.FWHM, size(VesselDiameter.FWHM, 1), ones(1, size(VesselDiameter.FWHM, 2)));
    VesselDiameter_Mean = cellfun(@mean, FWHM, "UniformOutput", false);
    VesselDiameter_Normalized = cellfun(@Normalization_Mean, FWHM, "UniformOutput", false);
    VesselDiameter_NormalizedFiltered = cellfun(@(Signal) medfilt1(Signal, 20), VesselDiameter_Normalized, "UniformOutput", false);

    WindowSize = round(20*FPS);
    TotalWindows = length(VesselDiameter.FWHM(:,1)) - WindowSize + 1;
    TotalROIs = size(VesselDiameter.FWHM, 2);
    
    MaxCC = zeros(TotalROIs, TotalWindows);
    MaxLag = zeros(TotalROIs, TotalWindows);
    for i = 1:TotalROIs
        ReferenceSignal = VesselDiameter_NormalizedFiltered{1};
        TargetSignal = VesselDiameter_NormalizedFiltered{i};
        [CorrelationMatrix{i}, Lag] = SlidingCrossCorrelation(ReferenceSignal, TargetSignal, WindowSize);
        for j = 1:TotalWindows
            [MaxCC(i,j), Index] = max(abs(CorrelationMatrix{i}(:,j)));
            MaxLag(i,j) = Lag(Index);
            MaxCC(i,j) = CorrelationMatrix{i}(Index, j);
        end
    end
    FrameAxis = (1:TotalWindows) + (WindowSize - 1) / 2;

    VesselDiameter.Mean = cell2mat(VesselDiameter_Mean);
    VesselDiameter.Normalized = cell2mat(VesselDiameter_Normalized);
    VesselDiameter.NormalizedFiltered = cell2mat(VesselDiameter_NormalizedFiltered);
    VesselDiameter.XCorr.CorrelationMatrix = CorrelationMatrix;
    VesselDiameter.XCorr.Lag = Lag;  
    VesselDiameter.XCorr.FrameAxis = FrameAxis;
    VesselDiameter.XCorr.MaxCCPerWindow = MaxCC;
    VesselDiameter.XCorr.MaxLagPerWindow = MaxLag;
    VesselDiameter.XCorr.FrameAxis = FrameAxis;

end