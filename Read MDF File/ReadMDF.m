function [MCS, MetaData, AnalogData] = ReadMDF(Directory)
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