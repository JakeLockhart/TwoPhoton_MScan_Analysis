# TwoPhoton_MScan_Analysis
MDF file loading, pre/post processing, and data analysis. MDF files created from MScan software associated with resonant/galvanometric two photon microscopes. 

- **Read MDF File**
    - This folder contains functions that collect the file information about the .MDF file and allow for access to the 'MCS Data Analysis Package'. This includes 'Notes', 'MetaData', and 'AnalogData'.  
        - 'Notes' contains imaging parameters such as when the recording occured, laser power (Not applicable if using ETL/EOM Controller), total frames, objective position, etc.
        - 'ImagingChannel' is found within 'MetaData' and provides the available imaging channels that were active while scanning. This also defines which channel should be accessed to collect the imaging frames.
        - 'AnalogChannel' is found within 'MetaData' and provides the analog acquisition frequency and total analog samples collected. This also provides which channels were active and the raw analog data associated with that channel. 
- **Pre-Process MDF File**
    - This folder loads the frames from the MDF file into an int16 numeric array
        - LoadRawStack: Reads the .MDF file frames and creates a 3D numerical array of the image stack.
        - RemovePadding: Removes black borders along the left and right edge of the image stack.
- **ImageJ Functions**
    - This folder contains functions that exist in ImageJ(FIJI) which are useful in image processing and analysis for microscopy results. 
        - Deinterleave: Separate a large image stack into multiple substacks based on a user defined number of channels.
        - DeleteFrames: Remove a set of frames from an image stack.
        - MeanProjection: Display a mean projection of a 3D image stack into a 2D image.
- **ROI Mask**
    - This folder contains functions to create regions of interest (ROIs) on image stacks. These functions can be used to create 'masks' which can be used to analyze sections of an image for processing.
        - DrawROI: Base function to draw different shaped ROIs
        - DrawMultipleROIs: Draw multiple ROIs on a single image. 'Enter' and 'Double-Click' define an ROI, 'Esc' saves all ROIs
        - TileStack_DrawROI: Tile layout to display multiple image stacks simultaneously. Multiple ROI can be drawn and saved to each image stack. Individual ROI masks can be used on other image stacks.
        - CropStackToMask: Take an image stack and create a smaller 3D array based on the defined ROI mask.