function [MetaData, AnalogData] = MDF_AnalogChannel(MCS, MetaData)
    fprintf('Collecting MDF analog channels...  \n')
    switch MetaData.Notes.ScanMode
        case "XY Movie"
            MetaData.AnalogChannel.Frequency = MCS.ReadParameter('Analog Acquisition Frequency (Hz)');
            MetaData.AnalogChannel.SampleCount = str2double(MCS.ReadParameter('Analog Sample Count'));
            MetaData.AnalogChannel.Resolution = MCS.ReadParameter('Analog Resolution');
            
            AC_Channel = zeros(7); AC_Name = zeros(7); AC_InputRange = zeros(7);
            for i = string(0:7)
                FieldName = MCS.ReadParameter(sprintf('Analog Ch %s Name', i));
                if strcmpi(FieldName, '')
                    fprintf('\tAnalog channel %s not detected\n', i)
                else
                    I = str2double(i);
                    AC_Channel(I+1) = I;
                    AC_Name(I+1) = string(FieldName);
                    AC_InputRange(I+1) = string(MCS.ReadParameter(sprintf('Analog Ch %s Input Range', i)));
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