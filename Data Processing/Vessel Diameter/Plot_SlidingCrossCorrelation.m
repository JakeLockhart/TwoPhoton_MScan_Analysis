function Plot_SlidingCrossCorrelation(VesselDiameter, CorrelationMatrix, FPS)
    % <Documentation>
        % Plot_SlidingCrossCorrelation()
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

    Lag = VesselDiameter.XCorr.Lag / FPS;
    FrameAxis = VesselDiameter.XCorr.FrameAxis / FPS;

    imagesc(FrameAxis, Lag, CorrelationMatrix);
    
    title('Sliding Cross Correlation of Vasoactivity')
    xlabel('Time [s]')
    ylabel('Lag [s]')
    axis xy
    colormap turbo

    cb = colorbar;
    cb.Label.String = 'Correlation Coefficient';
    clim([-1, 1]);

    hold on
    
end