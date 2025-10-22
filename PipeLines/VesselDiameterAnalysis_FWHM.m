function [ROIInfo, VesselDiameter, TimeAxis] = VesselDiameterAnalysis_FWHM(Stack, FPS, MicronsPerPixel)
    % <Documentation>
        % VesselDiameterAnalysis_FWHM()
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
        %   [obj, ProcessedStack, VesselDiameter]
    % <End Documentation>

    arguments
        Stack
        FPS (1,1) double {mustBeNonnegative} = 30.9;
        MicronsPerPixel (1,1) double {mustBeNonnegative} = 0.570; 
    end

    fprintf('Determining the vessel diameter\n\tFull-Width at Half Maximum Technique\n\tDraw multiple line ROIs along a vessel\n');
    [ROIs, Line] = TileStack_DrawROI({Stack});
    ROIInfo = struct("ROIs", ROIs, ...
                     "LineEndPoints", Line.LineEndPoints, ...
                     "LineCenterPoints", Line.LineCenterPoints, ...
                     "LineWidth", Line.LineWidth ...            
                    );
    [FWHM, Edge1, Edge2, ROIProfile] = VesselDiameter_FWHM(Stack, Line.LineEndPoints{1}, Line.LineWidth{1}, MicronsPerPixel);
    VesselDiameter = struct("FWHM", FWHM, ...
                            "Edge1", Edge1, ...
                            "Edge2", Edge2, ...
                            "ROIProfile", ROIProfile ...
                           );
    TimeAxis = (0:size(FWHM, 1) - 1) / FPS;
    fprintf('Vessel diameter across ROIs calculated ✓\n')

    fprintf('Processing vasoactivity...\n')
    VesselDiameter = ProcessVesselDiameter(VesselDiameter, FPS);
    
    fprintf('Plotting vasoactivity\n')
    Plot_VesselDiameters(TimeAxis, VesselDiameter)
    figure
    Tiles = tiledlayout("vertical");
    title(Tiles, "Sliding Cross Correlation of Vessel Diameter across ROIs")
    for i = 1:size(VesselDiameter.FWHM, 2) 
        nexttile(i)
        Plot_SlidingCrossCorrelation(VesselDiameter, VesselDiameter.XCorr.CorrelationMatrix{i}, FPS);
        plot(VesselDiameter.XCorr.FrameAxis/FPS, VesselDiameter.XCorr.MaxLagPerWindow(i,:)/FPS, 'k-', 'LineWidth', 3);
    end
    
end