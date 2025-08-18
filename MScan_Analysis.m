classdef MScan_Analysis
    properties
        File struct = struct()
        Stack struct = struct()
        ROI
    end

    %% Constructor
    methods
        function obj = MScan_Analysis()
            format short; format compact;
            obj.File = MScan_Analysis.Load_MDF_File;
            obj.Stack = MScan_Analysis.Pre_Process_MDF_File(obj);
        end
    end

    %% Callable Functions
    methods (Access = public)
        function [obj, PixelIntensity] = CalculateMeanPixelIntensity(obj)
            [obj, PixelIntensity] = InterleavedPixelIntensity(obj);
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

        function Stack = Pre_Process_MDF_File(obj)
            Stack.Raw = LoadRawStack(obj);
            Stack.Raw = structfun(@(Stack) RemovePadding(Stack), ...
                                  Stack.Raw, ...
                                  "UniformOutput", false);
            Stack.Raw = structfun(@(Stack) 32*uint16(max(Stack, 0))-1, ...
                                  Stack.Raw, ...
                                  "UniformOutput", false);
        end
    end
end