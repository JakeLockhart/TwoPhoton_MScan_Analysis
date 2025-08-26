function AdjustROIThickness(ROI, ax)
    % <Documentation>
        % AdjustROIThickness()
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

    Step = 0.5;

    if isprop(ROI, 'LineWidth')
        ROI.LineWidth = 2;
    end

    Window = ancestor(ax, 'figure');
    Window.WindowScrollWheelFcn = @(~, event) AdjustLineWidth(event, ROI);

    function AdjustLineWidth(event, ROI)
        if isvalid(ROI) && isprop(ROI, 'LineWidth')
            AdjustedWidth = ROI.LineWidth + Step * sign(event.VerticalScrollCount);

            ROI.LineWidth = max(0.5, min(AdjustedWidth, 10));
        end
    end
end