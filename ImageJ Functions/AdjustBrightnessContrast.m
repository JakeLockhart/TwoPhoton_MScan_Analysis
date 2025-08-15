function ContrastAlteredStack = AdjustBrightnessContrast(Stack, ColormapLimits)
    % <Documentation>
        % AdjustBrightnessContrast()
        %   Adjust the brightness/contrast of an image stack by applying new colormap limits.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ContrastAlteredStack = AdjustBrightnessContrast(Stack, ColormapLimits)
        %
        % Description:
        %   This function modifies the intensity values of an inpt stack by clamping all pixel values below
        %       the lower color map bound to the lower limit as well as all the pixel values above the upper 
        %       color map bound to the upper limit. This results in an image stack that is scaled linearly 
        %       such that the lower bound maps to 0 and the upper bound maps to 1.
        %   The output image stack is an artificially altered stack and *should not* be used for data analysis.
        %       This function should primarily be used for displaying image stacks and drawing ROIs. All data
        %       analysis should be performed on the original image stack.
        %   Note that unlike clim(), which only changes the display map not the actual pixel values, this 
        %       function changes the pixel values themselves permanently.
        %   Works for both grayscale and RGB images.
        %
        % Input:
        %   Stack          - A numerical 3D array representing an image stack, with dimensions 
        %                    Rows x Columns x Frames.
        %   ColormapLimits - Numerical array containing two numbers, a lower bound and upper bound for the
        %                    color map of the image stack.
        % Output:
        %   ContrastAlteredStack - An image stack of the same class and size of Stack containing brightness
        %                          adjusted values normalized into the range [0,1]
    % <End Documentation>

    arguments
        Stack
        ColormapLimits (1,2) double {mustBeFinite}
    end

    Stack(Stack < ColormapLimits(1)) = ColormapLimits(1);
    Stack(Stack > ColormapLimits(2)) = ColormapLimits(2);

    ContrastAlteredStack = double(Stack - ColormapLimits(1)) / (ColormapLimits(2) - ColormapLimits(1));
end