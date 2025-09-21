function MedianFilteredStack = MedianFilter(Stack, PixelNeighborhood)
    % <Documentation>
        % MedianFilter()
        %   Applies a median filter to a dataset (signal or image stack) to reduce noise.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   MedianFilteredStack = MedianFilter(Stack, PixelNeighborhood)
        %   
        % Description:
        %   This function applies a median filter to the input data depending on 
        %       the length of PixelNeighborhood:
        %       - 1D filtering: medfilt1 with window size W
        %       - 2D filtering: medfilt2 with neighborhood [Rows, Columns]
        %       - 3D filtering: medfilt3 with neighborhood [Rows, Columns, Frames]
        %
        %   For 2D filtering, if the input is a stack (3D array), the filter is 
        %       applied to each 2D slice individually.
        %   
        % Input:
        %   Stack             - Input dataset:
        %                       - 1D array (signal)
        %                       - 2D array (single image)
        %                       - 3D array (stack of 2D images or a 3D volume)
        %   PixelNeighborhood - Vector specifying filter window size:
        %                       - [W] → 1D median filter
        %                       - [Rows, Columns] → 2D median filter
        %                       - [Rows, Columns, Frames] → 3D median filter
        %
        % Output:
        %   MedianFilteredStack - Filtered dataset of the same size as the input
        %   
    % <End Documentation>

    arguments
        Stack
        PixelNeighborhood(1,:) {mustBeNumeric, mustBeInteger, mustBePositive}
    end

    Dimensions = numel(PixelNeighborhood);

    switch Dimensions
        case 1  % 1D Signals 
            MedianFilteredStack = medfilt1(Stack, PixelNeighborhood);

        case 2 % 2D images or image stacks
            MedianFilteredStack = zeros(size(Stack), "like", Stack);
            if ndims(Stack) == 2
                MedianFilteredStack = medfilt2(Stack, PixelNeighborhood);
            elseif ndims(Stack) == 3
                for k = 1:size(Stack, 3)
                    MedianFilteredStack(:,:,k) = medfilt2(Stack(:,:,k), PixelNeighborhood);
                end
            else
                error("2D median filtering only supports 2D or 3D input arrays. PixelNeighborhood may not match Stack dimensions")
            end

        case 3 % 3D volumes or 2D image stacks
            MedianFilteredStack = medfilt3(Stack, PixelNeighborhood);

        otherwise
                error("PixelNeighborhood must be of length 1, 2, or 3.")
    end
    
end