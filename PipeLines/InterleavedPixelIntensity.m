function [obj, PixelIntensity] = InterleavedPixelIntensity(obj)
    % <Documentation>
        % InterleavedPixelIntensity()
        %   Calculates the mean pixel intensity of an ROI from an interleaved image stack.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   [obj, PixelIntensity] = InterleavedPixelIntensity(obj)
        %
        % Description:
        %   This function processes interleaved image stacks contained within an object, applies 
        %       pre-processing parameters, deletes unwanted frames, deinterleaves channels, and 
        %       allows the user to draw a region of interest (ROI) on the final deinterleaved 
        %       stack. The stacks are then cropped to the ROI, and mean pixel intensities along 
        %       the Z-axis are computed for each stack.
        %
        % Input:
        %   obj - MScan_Analysis object containing raw image stack from a .MDF file
        %
        % Output:
        %   obj             - Updated MScan_Analysis object contianing 'Fixed' and 'Deinterleaved' 
        %                     image stacks along with ROI masks.
        %   PixelIntensity  - A structure containing fields from each imaging channel with numerical
        %                     arrays containing the mean pixel intensity of an ROI across an image 
        %                     stack's frames
        %   
    % <End Documentation>

    fprintf('Determining the pixel intensity of an ROI from an interleaved image stack\nDraw an ROI on the final deinterleaved stack.\n\n')

    Fields = fieldnames(obj.Stack.Raw);
    Parameters = structfun(@(Stack) PreProcessingConsole(Stack), ...
                           obj.Stack.Raw, ...
                           "UniformOutput", false ...
                          );

    for i = 1:length(Fields)
        obj.Stack.Fixed.(Fields{i}) = DeleteFrames(obj.Stack.Raw.(Fields{i}), Parameters.(Fields{i}).FramesToDelete);
        obj.Stack.Deinterleaved.(Fields{i}) = Deinterleave(obj.Stack.Fixed.(Fields{i}), Parameters.(Fields{i}).InterleavedChannels);
        obj.ROI = TileStack_DrawROI(struct2cell(obj.Stack.Deinterleaved.(Fields{i})));
        CommonMask = ~cellfun(@isempty, obj.ROI);
        CommonROI = obj.ROI{CommonMask}{1};

        obj.Stack.CroppedChannel.(Fields{i}) = structfun(@(Stack) CropStackToMask(Stack, CommonROI), obj.Stack.Deinterleaved.(Fields{i}), "UniformOutput", false );
    end   
    
    PixelIntensity = structfun(@(Stack) PlotZAxisProfile(Stack), obj.Stack.CroppedChannel, "UniformOutput", false);
end