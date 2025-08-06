function RawStack = LoadRawStack(obj)
    fprintf('Creating raw stack...  \n')
    MCS = obj.File.MCS;
    MetaData = obj.File.MetaData;

    StackClock = tic;
    Batch = 1000;
    TotalFrames = MetaData.Notes.FrameCount;
    Indicies = 1:TotalFrames;
    TotalBatches = ceil(TotalFrames/Batch);
    RawStack = cell(1, TotalBatches);
    
    for i = 1:TotalBatches
        BatchClock = tic;
        BatchStart = (i-1) * Batch + 1;
        BatchEnd = min(i*Batch, TotalFrames);
        BatchIndex = Indicies(BatchStart:BatchEnd);
        RawStack{i} = LoadBatchStack(MCS, MetaData, BatchIndex);
        fprintf('\tBatch %d of %d Created (%.3fs)\n', i, TotalBatches, toc(BatchClock));
    end
    
    RawStack = cat(3, RawStack{:});
    fprintf('Raw stack created (%.3fs) ✓\n', toc(StackClock));

    function RawBatchStack = LoadBatchStack(MCS, MetaData, BatchIndex)
        Demo = class(MCS.ReadFrame(MetaData.ImagingChannel.ActiveImagingChannel, BatchIndex(1)));
        BatchFrames = numel(BatchIndex);
        RawBatchStack = zeros(MetaData.Notes.FrameHeight, MetaData.Notes.FrameWidth, BatchFrames, Demo);
        for j = 1:BatchFrames
            FrameIndex = BatchIndex(j);
            RawBatchStack(:,:,j) = MCS.ReadFrame(MetaData.ImagingChannel.ActiveImagingChannel, FrameIndex)';
        end
    end
end
