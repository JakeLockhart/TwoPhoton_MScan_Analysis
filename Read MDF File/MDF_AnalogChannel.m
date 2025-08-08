function [MetaData, AnalogData] = MDF_AnalogChannel(MCS, MetaData)
    % <Documentation>
        % MDF_AnalogChannel()
        %   Extract metadata from .MDF file using the MCS interface.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   [MetaData, AnalogData] = MDF_AnalogChannel(MCS, MetaData)
        %
        % Description:
        %   This function reads the analog acquisition information and data
        %       from a .MDF file through the MCS interface actxserver().
        %   These recording parameters are saved under a structure 'MetaData.AnalogData'
        %       and the actual data is saved under AnalogData.
        %
        % Input:
        %   obj - Object containing:
        %           obj.File.MCS      : actxserver() necessary to read .MDF file frames.
        %           obj.File.MetaData : File metadata necessary to preallocate array dimensions.
        %
        % Output:
        %   MetaData    - Struct containing metadata fields grouped under `MetaData.AnalogData`
        %   AnalogData  - Struct containing values from each active analog input channel
        %
    % <End Documentation>

    fprintf('Collecting MDF analog channels...  \n')
    switch MetaData.Notes.ScanMode
        case "XY Movie"
            MetaData.AnalogChannel.Frequency = MCS.ReadParameter('Analog Acquisition Frequency (Hz)');
            MetaData.AnalogChannel.SampleCount = str2double(MCS.ReadParameter('Analog Sample Count'));
            MetaData.AnalogChannel.Resolution = MCS.ReadParameter('Analog Resolution');
            
            AC_Channel = string(7); AC_Name = string(7); AC_InputRange = string(7);
            for i = string(0:7)
                FieldName = MCS.ReadParameter(sprintf('Analog Ch %s Name', i));
                if strcmpi(FieldName, '')
                    fprintf('\tAnalog channel %s not detected\n', i)
                else
                    I = str2double(i);
                    AC_Channel(I+1) = I;
                    AC_Name(I+1) = string(FieldName);
                    AC_InputRange(I+1) = string((MCS.ReadParameter(sprintf('Analog Ch %s Input Range', i))));
                    fprintf('\tAnalog Channel %s Detected \n\t\tChannel, Range = (%s, %s)\n', i, FieldName, AC_InputRange(I+1));
                    AnalogData.(['Raw_', FieldName]) = double(MCS.ReadAnalog(I+1, MetaData.AnalogChannel.SampleCount,0));
                end
            end
            MetaData.AnalogChannel.Channels = [AC_Channel', AC_Name', AC_InputRange'];
        otherwise
            error("Scan mode not currently supported.")
    end
    fprintf('MDF file analog channels collected ✓\n')
end