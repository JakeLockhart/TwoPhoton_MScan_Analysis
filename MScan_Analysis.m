classdef MScan_Analysis
    properties
        File struct = struct()
    end

    %% Constructor
    methods
        function obj = MScan_Analysis()
            obj.File = MScan_Analysis.Load_MDF_File;
        end
    end

    %% Callable Functions
    methods

    end

    %% Initialization Functions
    methods(Static, Access=private)
        function File = Load_MDF_File
            zap
            ClassPath = fileparts(which("MScan_Analysis"));
            addpath(genpath(ClassPath));

            File.DirectoryInfo = FileLookup("mdf", "TroubleShoot", "G:\Data - Imaging\Practice Mice\241119_JSL000_Practice6\JSL000_6_241119_003.MDF");
            [File.MCS, File.MetaData, File.AnalogData] = ReadMDF(File.DirectoryInfo);
        end
    end
end