function DeinterleavedStack = Deinterleave(Stack, Channels)
    % <Documentation>
        % Deinterleave()
        %   Deinterleave an image stack into a user defined number of channels, similarly to ImageJ(FIJI).
        %   Created by: jsl5865
        %   
        % Syntax:
        %   DeinterleavedStack = Deinterleave(Stack, Channels)
        %
        % Description:
        %   This function splits a multi-frame image stack into separate stacks, based on the number of 
        %       channels specified. The input stack is expected to have frames interleaved. If the total
        %       number of frames is not divisible by the number of channels, the excess frames at the end
        %       of the original stack are discarded.
        %   Assumed that frames are interleaved based on channel. I.E.:
        %       Channels: 2
        %       Frame 1 = Channel 1 , Frame 2 = Channel 2, Frame 3 = Channel 1 ...
        %   
        % Input:
        %   Stack       - A numerical 3D array representing an image stack, with dimensions 
        %                 Rows x Columns x Frames. 
        %   Channels    - Integer specifying the total number of channels to separate the stack into.
        %   
        % Output:
        %   DeinterleavedStack  - A struct with fields 'Channel_1', 'Channel_2', ..., 'Channel_N', each 
        %                         containing a 3D array of the deinterleaved frames for that channel.
    % <End Documentation>
    
    fprintf('Deinterleaving MDF file into %d channels...  \n', Channels)
    [~, ~, TotalFrames] = size(Stack);
    ExcessFrames = mod(TotalFrames, Channels); 
    if ExcessFrames ~= 0
        fprintf('Total MDF frames (%d) is not evenly divisable by user defined channels (%d). Removing trailing frames (%d)...', TotalFrames, Channels, ExcessFrames)
        Stack = DeleteFrames(Stack, TotalFrames-ExcessFrames+1:TotalFrames);
    end
    
    for i = 1:Channels
        DeinterleavedStack.(sprintf('Channel_%d', i)) = Stack(:,:,i:Channels:end);
    end
    fprintf('Finished deinterleaving file ✓\n')
end