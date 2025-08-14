function RawStack = LoadRawStack(obj)
    % <Documentation>
        % LoadTempStack()
        %   Load .MDF file into workspace as a 3D numerical array (int16) in batches to improve memory performance.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   TempStack = LoadTempStack(obj)
        %
        % Description:
        %   This function reads a .MDF file's multi-frame image stack using batch processing to improve efficiency
        %       and reduce memory load. 
        %   File metadata is used to preallocated numerical array dimensions. 
        %   Batch loading segments the .MDF file into sections of 1000 frames. These sections are stored as cells 
        %       and eventually concatentated into a single 3D numerical array once all image frames have been 
        %       read and saved. The time to load each batch is displayed.
        %   Interal helper function ('LoadBatchStack()') handles batch processing.
        %   Supports MDF files that contain multiple imaging channels by looping through each channel to load the 
        %       file. Each channel is concatentated into a structure (RawStack) with an element name in the form
        %       of '(colour)_channel'.
        %   Processing 'bottleneck':
        %       MCS.ReadFrame() appears to be the rate limiting step of this process. If reading the frames from
        %       the .MDF file can be done faster, this function will run more efficiently.
        %
        % Input:
        %   obj - Object containing:
        %           obj.File.MCS      : actxserver() necessary to read .MDF file frames.
        %           obj.File.MetaData : File metadata necessary to preallocate array dimensions.
        %
        % Output:
        %   RawStack    - Structure containing numerical 3D array(s) (Rows x Columns x Frames) containing all frames 
        %                 from the MCS file, read in sequential order. 
        %
    % <End Documentation>

    MCS = obj.File.MCS;
    MetaData = obj.File.MetaData;

    for Channel = 1:MetaData.ImagingChannel.TotalImagingChannels
        ActiveChannel = MetaData.ImagingChannel.ActiveImagingChannel(Channel);
        ChannelName = MetaData.ImagingChannel.Channels(ActiveChannel,1);

        fprintf('Creating raw stack (%s channel) ...  \n', ChannelName)

        StackClock = tic;
        Batch = 1000;
        TotalFrames = MetaData.Notes.FrameCount;
        Indicies = 1:TotalFrames;
        TotalBatches = ceil(TotalFrames/Batch);
        TempStack = cell(1, TotalBatches);
        
        for i = 1:TotalBatches
            BatchClock = tic;
            BatchStart = (i-1) * Batch + 1;
            BatchEnd = min(i*Batch, TotalFrames);
            BatchIndex = Indicies(BatchStart:BatchEnd);
            TempStack{i} = LoadBatchStack(MCS, MetaData, ActiveChannel, BatchIndex);
            fprintf('\tBatch %d of %d Created (%.3fs)\n', i, TotalBatches, toc(BatchClock));
        end
        
        RawStack.(sprintf('%s_channel', ChannelName)) = cat(3, TempStack{:});
        fprintf('Raw stack created (%.3fs) ✓\n', toc(StackClock));
    end

    function RawBatchStack = LoadBatchStack(MCS, MetaData, ActiveChannel, BatchIndex)
        Demo = class(MCS.ReadFrame(ActiveChannel, BatchIndex(1)));
        BatchFrames = numel(BatchIndex);
        RawBatchStack = zeros(MetaData.Notes.FrameHeight, MetaData.Notes.FrameWidth, BatchFrames, Demo);
        for j = 1:BatchFrames
            FrameIndex = BatchIndex(j);
            RawBatchStack(:,:,j) = MCS.ReadFrame(ActiveChannel, FrameIndex)';
        end
    end
end
