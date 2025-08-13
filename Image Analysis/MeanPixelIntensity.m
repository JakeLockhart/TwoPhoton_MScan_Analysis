function PixelIntensity = MeanPixelIntensity(Stack)
    % <Documentation>
        % PixelIntensity()
        %   Compute the mean pixel intensity of a 2D or 3D image stack
        %   Created by: jsl5865
        %   
        % Syntax:
        %   PixelIntensity = MeanPixelIntensity(Stack)
        %   
        % Description:
        %   This function calculates the mean pixel intensity of an image stack. For 
        %       3D stacks, it averages across columns then across the remaining row, 
        %       and finally returns a vector of mean intensities.
        %   NaN values ignored for averaging.   
        %
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions 
        %           Rows x Columns x Frames. 
        %   
        % Output:
        %   Pixel Intensity - Numerical array representing the mean pixel intensity of
        %                     the input stack.
        %   
    % <End Documentation>

    PixelIntensity = mean(Stack, 1, 'omitnan');             % Average pixel intensity across columns
    PixelIntensity = mean(PixelIntensity, 2, 'omitnan');    % Average the remaining pixels
    PixelIntensity = squeeze(PixelIntensity);               % Remove singleton dimensions

end