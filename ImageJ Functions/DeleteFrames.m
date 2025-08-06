function Stack = DeleteFrames(Stack, FrameIndexToDelete)
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
        fprintf('Frames deleted. New frame count: %d\n', size(Stack, 3))
    end
end