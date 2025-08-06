# TwoPhoton_MScan_Analysis
MDF file loading, pre/post processing, and data analysis. MDF files created from MScan software associated with resonant/galvanometric two photon microscopes. 

- **Read MDF File**
    - This folder contains functions that collect the file information about the .MDF file and allow for access to the 'MCS Data Analysis Package'. This includes 'Notes', 'MetaData', and 'AnalogData'.  
        - 'Notes' contains imaging parameters such as when the recording occured, laser power (Not applicable if using ETL/EOM Controller), total frames, objective position, etc.
        - 'ImagingChannel' is found within 'MetaData' and provides the available imaging channels that were active while scanning. This also defines which channel should be accessed to collect the imaging frames.
        - 'AnalogChannel' is found within 'MetaData' and provides the analog acquisition frequency and total analog samples collected. This also provides which channels were active and the raw analog data associated with that channel. 
- **Pre-Process MDF File**
    - This folder loads the frames from the MDF file into an int16 numeric array