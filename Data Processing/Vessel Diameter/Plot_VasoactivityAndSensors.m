function Plot_VasoactivityAndSensors(VesselDiameter, MDF)
    % <Documentation>
        % Plot_VasoactivityAndSensors()
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
    Tiles = tiledlayout("vertical", "TileSpacing", "compact", "Padding", "compact");
    ColorMap = jet(size(VesselDiameter, 2));

    Threshold = graythresh(WhiskerStim);
    WhiskerStimulation = imbinarize(WhiskerStim, Threshold);

    nexttile(1)
    for i = 1:size(VesselDiameter, 2)
        plot(TimeAxis, VesselDiameter(:,i), "Color", ColorMap(:,i))
        Name(i) = sprintf("ROI %g", i);
        hold on
    end
    legend(Name, "Location", "best");

    nexttile(2)
    plot(AnalogAxis, )

    


end