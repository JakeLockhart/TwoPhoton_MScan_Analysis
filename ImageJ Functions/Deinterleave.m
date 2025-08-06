function DeinterleavedStack = Deinterleave(Stack, Channels)
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
end
