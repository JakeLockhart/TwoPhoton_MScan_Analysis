function ax = MeanProjection(Stack)
    % <Documentation>
        % MeanProjection()
        %   Average all frames of an image stack into a single frame, similarly to ImageJ(FIJI).
        %   Created by: jsl5865
        %
        % Syntax:
        %   ax = MeanProjection(Stack)
        %
        % Description:
        %   This fucntion creates a mean projection of a 3D image stack by averageing the pixel
        %       values across the third dimension (frame). 
        %   Once an averaged 2D image frame has been created, a grayscale image is created in a 
        %       figure window.
        %   
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions 
        %           Rows x Columns x Frames.
        %
        % Output:
        %   ax - Returns the handles for the figure's axis object
        %
    % <End Documentation>
    
    figure('Name', 'Draw ROI(s)')
    imagesc(mean(Stack, 3));

    axis image;
    colormap gray;
    xlabel('Pixels');
    ylabel('Pixels');
    
    ax = gca;
end
