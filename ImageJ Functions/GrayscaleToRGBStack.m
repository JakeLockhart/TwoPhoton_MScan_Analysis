function RGBStack = GrayscaleToRGBStack(GrayStack, RGB)
    % <Documentation>
        % GrayscaleToRGBStack()
        %   Converts a grayscale image to an RGB image based on the user defined RGB color vector.   
        %   Created by: jsl5865
        %   
        % Syntax:
        %   RGBStack = GrayscaleToRGBStack(GrayStack, RGB)
        %
        % Description:
        %   This function converts a 3D grayscale image stack into a 4D RGB image stack. Each frame 
        %       of the grayscale stack is mapped to the RGB channels according to the provided RGB 
        %       vector, where the vector defines the relative contribution of red, green, and blue 
        %       components. The resulting stack has dimensions Rows x Columns x 3 x Frames.
        %
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions 
        %           Rows x Columns x Frames.
        %   RGB   - A 1x3 double array defining the RGB colormap for the new image stack. Each value
        %           must be between 0 and 1.
        %
        % Output:
        %   RGBStack - A numerical 4D array (Rows x Columns x RGB(3) x Frames) containing the 
        %              RGB converted version of the input stack. 
        %   
    % <End Documentation>

    arguments
        GrayStack (:,:,:) {mustBeNumeric}
        RGB (1,3) double {mustBeNonnegative, mustBeLessThanOrEqual(RGB,1)} = [0 0 0]
    end

    [rows, columns, frames] = size(GrayStack);
    RGBStack = zeros(rows, columns, 3, frames);

    for k = 1:frames
        RGBStack(:,:,1,k) = GrayStack(:,:,k) * RGB(1);  % Red
        RGBStack(:,:,2,k) = GrayStack(:,:,k) * RGB(2);  % Green
        RGBStack(:,:,3,k) = GrayStack(:,:,k) * RGB(3);  % Blue
    end
end
