classdef MScan_Analysis
    properties
        File struct = struct()
        Stack
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
            Stack = LoadRawStack(obj);
        end
    end

    %% Initialization Functions
    methods(Static, Access = private)
        function File = Load_MDF_File
            ClassPath = fileparts(which("MScan_Analysis"));
            addpath(genpath(ClassPath));
            zap
            
            File.DirectoryInfo = FileLookup("mdf", "TroubleShoot", "G:\Data - Imaging\ETL and EOM Power Modulation\20250723_PowerModulation_MScanVsArduino\Arduino\250723_ArduinoPower_(0_5_10_15_20).MDF");
            [File.MCS, File.MetaData, File.AnalogData] = ReadMDF(File.DirectoryInfo);
            
        end
    end
end