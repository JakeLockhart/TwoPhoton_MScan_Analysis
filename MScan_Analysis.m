classdef MScan_Analysis
    properties
        File struct = struct()
        Stack struct = struct()
    end

    %% Constructor
    methods
        function obj = MScan_Analysis()
            obj.File = MScan_Analysis.Load_MDF_File;
        end
    end

    %% Callable Functions
    methods (Access = public)
        function Stack = Pre_Process_MDF_File(obj)
            Stack.Raw = LoadRawStack(obj);
            Stack.Raw = RemovePadding(Stack.Raw);
            Stack.Raw = uint16(max(Stack.Raw,0));
        end

        function [ROIs, obj] = MultiChannelDemo(obj)
            sliceViewer(obj.Stack.Raw)
            a = input('First frame to delete = ');
            b = input('Last frame to delete = ');
            c = input('Total channels = ');

            obj.Stack.Fixed = DeleteFrames(obj.Stack.Raw, [1:a, b:length(obj.Stack.Raw)]);
            obj.Stack.Deinterleaved = Deinterleave(obj.Stack.Fixed, c);

            ROIs = TileStack_DrawROI(struct2cell(obj.Stack.Deinterleaved));

            figure;
            tiledlayout("flow");
            Channels = fieldnames(obj.Stack.Deinterleaved);
            for i = 1:length(ROIs)
                obj.Stack.(sprintf('Cropped_CH%d', i)) = CropStackToMask(obj.Stack.Deinterleaved.(Channels{i}), ROIs{length(ROIs)}{1});
                nexttile
                imshow(mean(obj.Stack.(sprintf('Cropped_CH%d', i)), 3), []);
            end

            numChannels = length(ROIs); % or however many channels you have
            figure; hold on;

            for i = 1:numChannels
                stackName = sprintf('Cropped_CH%d', i); % Capital 'C'
                if isfield(obj.Stack, stackName)
                    stack = obj.Stack.(stackName);
                    % Compute mean intensity per frame, omitting NaNs
                    meanVals = squeeze(mean(mean(stack, 1, 'omitnan'), 2, 'omitnan'));
                    plot(meanVals, 'DisplayName', stackName);
                end
            end

            xlabel('Frame');
            ylabel('Mean Intensity');
            legend('show');
            title('Mean Intensity per Frame for Each Cropped Channel');
            hold off;

        end
    end

    %% Initialization Functions
    methods(Static, Access = private)
        function File = Load_MDF_File
            ClassPath = fileparts(which("MScan_Analysis"));
            addpath(genpath(ClassPath));
            zap
            
            File.DirectoryInfo = FileLookup("mdf", "SingleFile");
            [File.MCS, File.MetaData, File.AnalogData] = ReadMDF(File.DirectoryInfo);
            
        end
    end
end