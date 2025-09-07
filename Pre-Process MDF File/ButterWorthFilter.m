function ButterworthFilteredStack = ButterWorthFilter(Stack, FilterOrder, CutoffFrequency, SamplingFrequency, FilterType)
    % <Documentation>
        % ButterWorthFilter()
        %   Applies a Butterworth temporal filter to a 3D image stack
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ButterworthFilteredStack = ButterWorthFilter(Stack, FilterOrder, CutoffFrequency, SamplingFrequency, FilterType)
        %
        % Description:
        %   This function applies a temporal filter to an image stack by applying a Butterworth filter to each frame of the 
        %       image stack. Each pixel is treated as an independent siganl over time.
        %   The first frame is subtracted from the image stack prior to filtering to center the pixel values around zero. This
        %       frame's pixel values are then added back after filtering to preserve the absolute intensity of the image stack.
        %   The default sampling frequency is set to 30.90 fps. This is the frame rate of the Drew Lab's Resonant 2 Photon 
        %       microscope recording a 512x512 pixel field of view.
        %   
        % Input:
        %   Stack             - A cell array representing an image stack, with dimensions Rows x Columns x Frames
        %   FilterOrder       - Integer specifying the order of the Butterworth filter (default: 2).
        %   CutoffFrequency   - Normalized cutoff frequency (0 to 1, default: 1).
        %   SamplingFrequency - Sampling frequency of the frames (Hz, default: 30.9).
        %   FilterType        - Type of filter: 'low' or 'high' (default: 'low').
        %   
        % Output:
        %   ButterworthFilteredStack - Temporally filtered image stack with the same size and class as the input stack.
        %
    % <End Documentation>

    arguments
        Stack
        FilterOrder (1,1) {mustBeInteger, mustBePositive, mustBeLessThanOrEqual(FilterOrder, 500)} = 2;
        CutoffFrequency (1,1) {mustBeNumeric, mustBeGreaterThanOrEqual(CutoffFrequency, 0), mustBeLessThanOrEqual(CutoffFrequency, 1)} = 1;
        SamplingFrequency (1,1) {mustBeNumeric, mustBePositive} = 30.9;
        FilterType char {mustBeMember(FilterType, {'low', 'high'})} = 'low'
    end

    NyquistFrequency = SamplingFrequency / 2;                   % Calculate the nyquist frequency for the dataset to avoid aliasing
    NormalizedCutoff = CutoffFrequency / NyquistFrequency;      % Normalize the cutoff freuqency by the nyquist frequency
    [b,a] = butter(FilterOrder, NormalizedCutoff, FilterType);  % Design the filter; 'a' and 'b' are the coefficients of the filter transfer function

    StackClass = class(Stack);  % Record the data type of the input image stack
    Stack = double(Stack);      % Convert stack to double(); Required for filtfilt()
    
    BaselineFrame = Stack(:,:,1);                   % Use the first frame as a reference
    Stack = Stack - BaselineFrame;                  % This reduces the pixel intensity average to 0 which helps the frequency filter
    [Rows, Columns, Frames] = size(Stack);          % Record the image stack dimensions
    ReshapedStack_2D = reshape(Stack, [], Frames);  % Convert the 3D image stack to 2D; to vectorize filtfilt() and avoid a iterating frames

    FilteredStack = filtfilt(b, a, ReshapedStack_2D')';                         % Apply butterworth filter to reshaped image stack
    ButterworthFilteredStack = reshape(FilteredStack, Rows, Columns, Frames);   % Convert the 2D filtered stack to 3D filtered stack
    
    ButterworthFilteredStack = ButterworthFilteredStack + BaselineFrame;    % Return the pixel intensity values from the reference frame
    ButterworthFilteredStack = cast(ButterworthFilteredStack, StackClass);  % Convert the filtered stack to the original image stack type

end