function ReducedStack = SubStack(Stack, Region)
    % <Documentation>
        % SubStack()
        %   Extracts a subset of frames from an image stack, cell array of stacks, or structure of stacks.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ReducedStack = SubStack(Stack, Region)
        %
        % Description:
        %   This function returns a reduced version of the input stack by maintaining the number of rows and
        %       columns from the original stack, but only keeping frames defined within the 'Region' input 
        %       variable. 
        %   The class(Stack) should be handled for most cases. Note that class(ReducedStack) == class(Stack).
        %
        % Input:
        %   Stack  - A numerical 3D array representing an image stack, with dimensions 
        %            Rows x Columns x Frames. 
        %   Region - A numeric array of integers that represent the beginning and end frame number of the 
        %            original stack that will be converted into a new stack.
        %
        % Output:
        %   ReducedStack - Subset of the input stack containing only the frames specified in Region.
        %   
    % <End Documentation>

    arguments
        Stack
        Region {mustBeNumeric, mustBeFinite, mustBePositive} 
    end

    switch class(Stack)
        case 'struct'
            Fields = fieldnames(Stack);
            TotalFrames = size(Stack.(Fields{1}), 3);
        case 'cell'
            TotalFrames = size(Stack{1}, 3);
        otherwise
            TotalFrames = size(Stack, 3);
    end
    
    if any(Region < 1) || any(Region > TotalFrames)
        error('Substack frame region is not contained within original stack')
    end

    switch class(Stack)
        case 'struct'
            ReducedStack = structfun(@(x) x(:, :, Region), Stack, "UniformOutput", false);
        case 'cell'
            ReducedStack = cellfun(@(x) x(:, :, Region),Stack, "UniformOutput", false);
        otherwise
            ReducedStack = Stack(:, :, Region);
    end
end