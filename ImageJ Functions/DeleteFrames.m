function Stack = DeleteFrames(Stack, FrameIndexToDelete)
    % <Documentation>
        % DeleteFrames()
        %   Delete a set of frames from an image stack, similarly to ImageJ(FIJI).
        %   Created by: jsl5865
        %   
        % Syntax:
        %   Stack = DeleteFrames(Stack, FrameIndexToDelete)
        %
        % Description:
        %   This function removes user dictated frames from a multi-frame image stack.
        %       The input stack is expected to be a 3D numerical array where the third 
        %       dimension represents the image frame index. The frames to be deleted 
        %       are defined by the index of the frame within the multi-frame image stack.
        %   If the user defines a frame index that is not valid (index is larger than 
        %       total frames or is less than 1) will throw an error and no frames will 
        %       be deleted.
        %   Only unique frame indices will be deleted. This prevents the user from accidentally 
        %       removing the an undesired frame during a typo.
        %
        % Input:
        %   Stack              - A numerical 3D array representing an image stack, with 
        %                        dimensions Rows x Columns x Frames. 
        %   FrameIndexToDelete - Numerical array of integers that represent frame indices to be deleted.
        %
        % Output:
        %   Stack              - The modified image stack with the specified frames removed.
    % <End Documentation>

    fprintf('Deleting frames...  \n')
    [~, ~, TotalFrames] = size(Stack);
    FrameIndexToDelete = unique(FrameIndexToDelete);

    if any(FrameIndexToDelete < 1) || any(FrameIndexToDelete > TotalFrames)
        fprintf('Invalid frame index. Indices must be between 1 and the total number of frames (%d)\n', TotalFrames);
        error('No frames deleted')
    else
        KeptFrames = true(1,TotalFrames);
        KeptFrames(FrameIndexToDelete) = false;

        Stack = Stack(:,:,KeptFrames);
        fprintf('Frames deleted ✓. New frame count: %d\n', size(Stack, 3))
    end
end