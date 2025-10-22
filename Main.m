MDF = MScan_Analysis;
[ROIInfo, VesselDiameter, TimeAxis] = VesselDiameterAnalysis_FWHM(MDF.Stack.Raw.Green_channel, MDF.File.MetaData.Notes.FrameRate, MDF.File.MetaData.Notes.MicronsPerPixel);
