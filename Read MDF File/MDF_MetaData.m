function MetaData = MDF_MetaData(MCS)
    % <Documentation>
        % MDF_MetaData()
        %   Extract metadata from .MDF file using the MCS interface.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   MetaData = MDF_MetaData(MCS)
        %
        % Description:
        %   This function reads the metadata from a .MDF file through the MCS interface
        %       actxserver().
        %   These values are saved under a structure 'MetaData.Notes'.
        %
        % Input:
        %   obj - Object containing:
        %           obj.File.MCS    : actxserver() necessary to read .MDF file frames.
        %
        % Output:
        %   MetaData - Struct containing metadata fields grouped under `MetaData.Notes`
        %
    % <End Documentation>

    fprintf('Collecting MDF file MetaData...  ')
    MetaData.Notes.Creator                  = MCS.ReadParameter('Created By');
    MetaData.Notes.DateCreated              = MCS.ReadParameter('Created on');
    MetaData.Notes.ScanMode                 = MCS.ReadParameter('Scan Mode');
    MetaData.Notes.PixelClock               = MCS.ReadParameter('Pixel Clock');
    MetaData.Notes.XFrameOffset             = MCS.ReadParameter('X Frame Offset');
    MetaData.Notes.YFrameOffset             = MCS.ReadParameter('Y Frame Offset');
    MetaData.Notes.Rotation                 = MCS.ReadParameter('Rotation');
    MetaData.Notes.Objective                = MCS.ReadParameter('Objective');
    MetaData.Notes.ObjectivePositionX       = MCS.ReadParameter('X Position'); 
    MetaData.Notes.ObjectivePositionY       = MCS.ReadParameter('Z Position');
    MetaData.Notes.ObjectivePositionZ       = MCS.ReadParameter('Y Position'); 
    MetaData.Notes.MicronsPerPixel          = MCS.ReadParameter('Microns per Pixel');
    MetaData.Notes.MicronsPerPixel          = str2double(regexprep(MetaData.Notes.MicronsPerPixel, '[^\d\.\-eE]', ''));
    MetaData.Notes.Magnification            = MCS.ReadParameter('Magnification');
    MetaData.Notes.LaserPower               = MCS.ReadParameter('Laser intensity');
    MetaData.Notes.LaserWavelength          = strcat(MCS.ReadParameter('Laser Wavelength (nm)'),'nm');
    MetaData.Notes.FrameBitDepth            = MCS.ReadParameter('Frame Bit Depth');
    MetaData.Notes.FrameDuration            = MCS.ReadParameter('Frame Duration (s)');
    MetaData.Notes.FrameRate                = 1/str2double(MetaData.Notes.FrameDuration(1:end-1));
    MetaData.Notes.FrameCount               = str2double(MCS.ReadParameter('Frame Count'));
    MetaData.Notes.FrameInterval            = MCS.ReadParameter('Frame Interval (ms)');
    MetaData.Notes.FrameHeight              = str2double(MCS.ReadParameter('Frame Height'));
    MetaData.Notes.FrameWidth               = str2double(MCS.ReadParameter('Frame Width'));
    fprintf('MDF file MetaData collected ✓\n')
end
