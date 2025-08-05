classdef MScan_Analysis
    properties
        File struct = struct()

    end

    %% Constructor
    methods
        function obj = MScan_Analysis()
            addpath(genpath(which("MScan_Analysis")))
            zap
            obj.File.DirectoryInfo = FileLookup("mdf", "TroubleShoot", "G:\Data - Imaging\ETL and EOM Power Modulation\20250723_PowerModulation_MScanVsArduino\Arduino\250723_ArduinoPower_(0_20).MDF");
        end
    end

    %% Callable Functions
    methods

    end
end