function Plot_VesselDiameters(TimeAxis, VesselDiameter)
    % <Documentation>
        % Plot_VesselDiameters()
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

    figure
    Tiles = tiledlayout("vertical", "TileSpacing", "tight", "Padding", "compact");
    title(Tiles, "Vessel Diameter across ROIs")
    xlabel(Tiles, "Time [s]")
    ylabel(Tiles, "Vessel Diameter [μm]")

    for i = 1:size(VesselDiameter.FWHM, 2)        
        nexttile(i)
        hold on

        plot(TimeAxis, VesselDiameter.Normalized(:,i), "Color", [0.7, 0.7, 0.7], "DisplayName", "Normalized Diameter (ΔD/D̄)");
        plot(TimeAxis, VesselDiameter.NormalizedFiltered(:,i), "Color", "b", "LineWidth", 1, "DisplayName", "Median Filtered Diameter");
        
        axis tight
        title(sprintf("ROI %g", i))
    end

    legend show

end