function [ROIInfo, VesselDiameter] = VesselDiameterAnalysis_FWHM(Stack, FPS, MicronsPerPixel)
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

    fprintf('Determining the vessel diameter\n\tFull-Width at Half Maximum Technique\n\tDraw multiple line ROIs along a vessel\n\n');

    [ROIs, LineEndPoints, LineWidth] = TileStack_DrawROI({Stack});
    ROIInfo = struct("ROIs", ROIs, ...
                     "LineEndPoints", LineEndPoints, ...
                     "LineWidth", LineWidth ...            
                    );
    [FWHM, Edge1, Edge2, ROIProfile] = VesselDiameter_FWHM(Stack, LineEndPoints{1}, LineWidth{1}, MicronsPerPixel);
    VesselDiameter = struct("FWHM", FWHM, ...
                            "Edge1", Edge1, ...
                            "Edge2", Edge2, ...
                            "ROIProfile", ROIProfile ...
                           );

    figure
    t = tiledlayout("vertical");
    for i = 1:size(FWHM, 2)
        nexttile(i)
        TimeAxis = (0:size(FWHM, 1) - 1) / FPS;
        plot(TimeAxis, FWHM(:,i));
        ylabel(sprintf('ROI %g', i));
        axis tight;
    end
    title(t, "FWHM ROI Diameter");
    xlabel(t, "Time [s]")
    ylabel(t, "Vessel Diameter [μs]")

end