function PShiftStack = PixelShiftCorrection(Stack, Shift)
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

    PShiftStack = Stack;
    if Shift == 0
        return        
    elseif Shift > 0
        StartingRow = 1;
    elseif Shift < 0
        StartingRow = 2;
    end

    Shift = abs(Shift);
    PShiftStack(StartingRow:2:end, 1+Shift:end, :) = Stack(StartingRow:2:end, 1:end-Shift, :);
    PShiftStack = PShiftStack(:, 1+Shift:end, :);




end