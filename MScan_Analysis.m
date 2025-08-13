classdef MScan_Analysis
    properties
        File struct = struct()
        Stack struct = struct()
        ROI
    end

    %% Constructor
    methods
        function obj = MScan_Analysis()
            format short
            format compact
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

        function [obj, PixelIntensity] = PixelIntensity_InterleavedStack(obj)
            fprintf('Deinterleaving image stack...\n')

            sliceViewer(obj.Stack.Raw);
        
            fprintf('Removing the startup frames: 1-_')
            FirstDeleteIndex = input('');
            fprintf('Removing the ending frames: _-end')
            SecondDeleteIndex = input('');
            fprintf('How many channels to deinterleave?')
            Channels = input('');

            obj.Stack.Fixed = DeleteFrames(obj.Stack.Raw, [1:FirstDeleteIndex, SecondDeleteIndex:length(obj.Stack.Raw)]);
            obj.Stack.Deinterleaved = Deinterleave(obj.Stack.Fixed, Channels);

            obj.ROI = TileStack_DrawROI(struct2cell(obj.Stack.Deinterleaved));
            CommonMask = ~cellfun(@isempty, obj.ROI);
            CommonROI = obj.ROI{CommonMask}{1};

            obj.Stack.CroppedChannel = structfun(@(Stack) CropStackToMask(Stack, CommonROI), ...
                                                 obj.Stack.Deinterleaved, ...
                                                 "UniformOutput", false ...
                                                );

            PixelIntensity = PlotZAxisProfile(obj.Stack.CroppedChannel);
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