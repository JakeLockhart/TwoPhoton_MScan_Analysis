function PShiftStack = PixelShiftCorrection(Stack, Shift, Scope, FrameIndex)
    % <Documentation>
        % PixelShiftCorrection()
        %   Applies a pixel shift correction to an image stack by offsetting alternate rows.
        %   Created by: jsl5865 / hql5715
        %   
        % Syntax:
        %   PShiftStack = PixelShiftCorrection(Stack, Shift)
        %   
        % Description:
        %       This function corrects pixel misalignment in an image stack by shifting every other 
        %           row horizontally by a specified number of pixels. Positive Shift values move 
        %           pixels to the right, negative values are handled by adjusting the starting row. 
        %           The resulting stack is trimmed to maintain consistent dimensions.
        %
        % Input:
        %   Stack - A cell array representing an image stack, with dimensions Rows x Columns x Frames. 
        %
        %   Shift - An integer specifying the number of pixels to shift alternating rows of an image 
        %           stack along the x-axis. The sign of this integer dictates whether odd/even rows
        %           are shifted.
        %   
        % Output:
        %   PShiftStack - The pixel-shift corrected image stack, with the same number of
        %                 rows and frames, but potentially fewer columns due to trimming.
        %   
    % <End Documentation>

    arguments
        Stack
        Shift
        Scope {mustBeMember(Scope, {'SingleFrame', 'WholeStack'})} = 'WholeStack'
        FrameIndex (1,1) {mustBePositive, mustBeInteger} = 1
    end

    PShiftStack = Stack;
    [Rows, ~, Frames] = size(Stack);
    if Shift == 0
        return
    end

    if Shift > 0
        ShiftingRows = 1:2:Rows;
    elseif Shift < 0
        ShiftingRows = 2:2:Rows;
    end

    Shift = abs(Shift);    

    switch Scope
        case 'WholeStack'
            PShiftStack(ShiftingRows, 1+Shift:end, :) = Stack(ShiftingRows, 1:end-Shift, :);
            PShiftStack = PShiftStack(:, 1:end-Shift, :);

        case 'SingleFrame'
            if FrameIndex > Frames
                error('Frame index exceeds total frames in image stack')
            end

            PShiftStack(ShiftingRows, 1+Shift:end, FrameIndex) = Stack(ShiftingRows, 1:end-Shift, FrameIndex);
            PShiftStack(:, 1:end-Shift, FrameIndex) = PShiftStack(:, 1:end-Shift, FrameIndex);

    end

end