function [MCS, MetaData, AnalogData] = ReadMDF(Directory)
    % <Documentation>
        % ReadMDF()
        %   Extract metadata from .MDF file using the MCS interface.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   [MCS, MetaData, AnalogData] = ReadMDF(Directory)
        %
        % Description:
        %   This function concatentates metadata and analog data from a .MDF file.
        %
        % Input:
        %   Directory - The path to the .MDF file
        %
        % Output:
        %   MCS         - actxserver() necessary to interface with .MDF files
        %   MetaData    - Struct containing metadata fields grouped under 
        %                   MetaData.Notes
        %                   MetaData.ImagingChannel
        %                   MetaData.AnalogChannel
        %   AnalogData  - Struct containing values from each active analog input channel
        %
    % <End Documentation>

    % Details on reading mdf files with MView via script can be found in MView Manual
    MCS = actxserver('MCSX.Data');
    MCS.invoke('OpenMCSFile', Directory.Path);
    
    % File Notes
    MetaData = MDF_MetaData(MCS);

    % Imaging channels (IC)
    MetaData = MDF_ImagingChannel(MCS, MetaData);

    % Analog channels (AC)
    [MetaData, AnalogData] = MDF_AnalogChannel(MCS, MetaData);
end