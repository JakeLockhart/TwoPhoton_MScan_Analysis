function MetaData = MDF_ImagingChannel(MCS, MetaData)
    % <Documentation>
        % MDF_ImagingChannel()
        %   Extract imaging channel information from .MDF file using the MCS interface.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   MetaData = MDF_ImagingChannel(MCS, MetaData)
        %
        % Description:
        %   This function collects all the channels from the .MDF file (Green channel, 
        %       Red channel, etc). It counts the total imaging channels that were 
        %       recorded during an image session and loads all active imaging channels.
        %
        % Input:
        %   obj - Object containing:
        %           obj.File.MCS      : actxserver() necessary to read .MDF file frames.
        %           obj.File.MetaData : File metadata necessary to preallocate array dimensions.
        %
        % Output:
        %   MetaData - Struct containing metadata fields grouped under `MetaData.ImagingChannel`
        %
    % <End Documentation>

    fprintf('Collecting MDF imaging channels...  ')
    IC_Name = strings(1,4); IC_InputRange = strings(1,4);
    for i = 1:4
        IC_Name(i) = string(MCS.ReadParameter(sprintf('Scanning Ch %d Name',i-1)));
        IC_InputRange(i) = string(MCS.ReadParameter(sprintf('Scanning Ch %d Input Range',i-1)));
    end
    MetaData.ImagingChannel.Channels = [IC_Name', IC_InputRange'];
    MetaData.ImagingChannel.TotalImagingChannels = sum(MetaData.ImagingChannel.Channels(:,1) ~= "");
    MetaData.ImagingChannel.ActiveImagingChannel = find(MetaData.ImagingChannel.Channels(:,1) ~= "")';

    fprintf('MDF file imaging channels collected ✓\n')
end