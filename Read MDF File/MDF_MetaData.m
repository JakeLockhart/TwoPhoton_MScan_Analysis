function MetaData = MDF_MetaData(MCS)
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
