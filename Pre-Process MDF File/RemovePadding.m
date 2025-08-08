function Stack = RemovePadding(Stack)
    % <Documentation>
        % RemovePadding()
        %   Remove horizontal padding (dark border) from an image stack based on pixel value.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   Stack = RemovePadding(Stack)
        %
        % Description:
        %   Image frames directly retrieved from a .MDF file have solid black columns on the 
        %       left and right border of the frame. These add unecessary data points that 
        %       reduce processing speed and take up memory.
        %   This function removes the horizontal padding from the image stack by detecting
        %       columns that have a mean pixel intensity of -2048 (which represents a pixel
        %       with no luminescence). Then the padded regions are identified and a new image
        %       stack is created without these regions.
        %
        % Input:
        %   Stack - A numerical 3D array representing an image stack, with dimensions 
        %           Rows x Columns x Frames. 
        %
        % Output:
        %   Stack - Modified image stack with horizontal padding columns removed.
    % <End Documentation>

    RowMean = mean(Stack, [1,3]);
    RowActual = find(RowMean ~= -2048);
    FrameWidth_Actual = RowActual(1):RowActual(end);
    Stack = Stack(:, FrameWidth_Actual, :);
end