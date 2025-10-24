function Plot_CompareDiameters(VesselDiameter)
    % <Documentation>
        % Plot_CompareDiameters()
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
    Tiles1 = tiledlayout("flow", "TileSpacing", "compact", "Padding", "compact");
    title(Tiles1, "Vessel Diameter vs Diameter across ROIs")
    xlabel(Tiles1, "Reference Normalized Diameter (ROI 1)")
    ylabel(Tiles1, "Target Normalized Diameter")

    TotalROIs = size(VesselDiameter, 2);
    for i = 1:TotalROIs + 1
        nexttile(i)
        hold on
        if i <= TotalROIs
            Name = {sprintf("ROI1 vs ROI%g", i)};
            ylabel(sprintf("ROI%g", i))
            plot(VesselDiameter(:,1), VesselDiameter(:,i))
        else
            plot(VesselDiameter(:,1), VesselDiameter(:,:));
            for j = 1:TotalROIs
                Name{j} = sprintf("ROI1 vs ROI%g", j);
            end
        end

        xlim(max(xlim, ylim))
        ylim(max(xlim, ylim))
        plot(xlim, ylim, '--k', 'HandleVisibility', 'off')
        xline(0, '--r', 'HandleVisibility', 'off')
        yline(0, '--r', 'HandleVisibility', 'off')
        
        legend(Name, "Location", "best")
    end


    figure
    Tiles2 = tiledlayout("flow", "TileSpacing", "compact", "Padding", "compact");
    title(Tiles2, "Vessel Diameter vs Diameter across ROIs")
    xlabel(Tiles2, "Reference Normalized Diameter (ROI 1)")
    ylabel(Tiles2, "Target Normalized Diameter")
    
    Frames = size(VesselDiameter, 1);
    ColorMap = turbo(Frames);

    for i = 1:TotalROIs + 1
        nexttile(i)
        hold on
        if i <= TotalROIs
            Name = {sprintf("ROI1 vs ROI%g", i)};
            ylabel(sprintf("ROI%g", i))
            scatter(VesselDiameter(:,1), VesselDiameter(:,i), 8, ColorMap, "filled")
        else
            for j = 1:TotalROIs
                scatter(VesselDiameter(:,1), VesselDiameter(:,j), 8, ColorMap, "filled");
                Name{j} = sprintf("ROI1 vs ROI%g", j);
            end

            cb = colorbar;
            cb.Label.String = 'Time →';
            cb.Ticks = [0, 1];
            cb.TickLabels = {'Start', 'End'};
            colormap(turbo);
        end

        xlim(max(xlim, ylim))
        ylim(max(xlim, ylim))
        plot(xlim, ylim, '--k', 'HandleVisibility', 'off')
        xline(0, '--r', 'HandleVisibility', 'off')
        yline(0, '--r', 'HandleVisibility', 'off')
        
        legend(Name, "Location", "best")

    end



end