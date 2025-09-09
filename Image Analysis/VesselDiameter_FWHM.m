function [FWHM, Edge1, Edge2, ROIProfile] = VesselDiameter_FWHM(Stack, LineROI, LineWidth, MicronsPerPixel)
    % <Documentation>
        % VesselDiameter_FWHM()
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

    fprintf('Calculating the vessel diameter using the Full-Width at Half-Maximum technique.\n')

    Frames = size(Stack,3);
    ROIs = length(LineROI);
    SamplesOnROI = 1000;
    ROIProfile = NaN(SamplesOnROI, Frames, ROIs);
    
    ROIProfilePosition = linspace(0, SamplesOnROI-1, SamplesOnROI) * MicronsPerPixel;
    FWHM = NaN(Frames,ROIs);
    Edge1 = NaN(Frames,ROIs);
    Edge2 = NaN(Frames,ROIs);
    
    Timer = tic;
    for i = 1:Frames
        for j = 1:ROIs
            ROIProfile(:,i,j) = AdjustedImprofile(Stack(:,:,i), LineROI{j}, LineWidth{j});
            [FWHM(i,j), Edge1(i,j), Edge2(i,j)] = CalculateFWHM(ROIProfilePosition, ROIProfile(:,i,j));
        end
    end
    
    fprintf('Completed calculating FWHM (%.2fs) ✓\n', toc(Timer))

end