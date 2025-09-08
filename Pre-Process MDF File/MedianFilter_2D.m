function MedianFilteredStack = MedianFilter_2D(Stack, PixelNeighborhood)
    % <Documentation>
        % MedianFilter()
        %   Applies a 2D median filter to each frame of an image stack to reduce noise.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   MedianFilteredStack = MedianFilter_2D(Stack, PixelNeighborhood)
        %   
        % Description:
        %   This function processes an image stack by applying a median filter to each 
        %       individual 2D frame. The filter replaces each pixel's value with the median
        %       of its neighboring pixels as defined by the PixelNeighborhood input.
        %   This works for single images as well. 
        %   Created as a spatial filter
        %   
        % Input:
        %   Stack             - A cell array representing an image stack, with dimensions 
        %                       Rows x Columns x Frames. 
        %   PixelNeighborhood - A two-element vector [Rows, Columns] specifying the size 
        %                       of the neighborhood over which to compute the median.
        %
        % Output:
        %   MedianFilteredStack - The filtered image stack with reduced noise, same size 
        %                         as input.
        %   
    % <End Documentation>

    arguments
        Stack
        PixelNeighborhood(1,3) {mustBeNumeric, mustBeInteger, mustBePositive} = [1,1,1]
    end

    Rows = PixelNeighborhood(1,1);
    Columns = PixelNeighborhood(1,2);
    Frames = PixelNeighborhood(1,3);
    MedianFilteredStack = zeros(size(Stack), "like", Stack);
    
    if PixelNeighborhood(1,3) == 1
        for k = 1:size(Stack,3)
            MedianFilteredStack(:,:,k) = medfilt2(Stack(:,:,k), [Rows, Columns, Frames]);
        end
    else
        for k = 1:size(Stack, 3)
            MedianFilteredStack(:,:,k) = medfilt3(Stack(:,:,k), [Rows, Columns, Frames]);
        end
    end
    
end