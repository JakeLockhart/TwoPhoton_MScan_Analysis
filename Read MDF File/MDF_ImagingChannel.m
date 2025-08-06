function MetaData = MDF_ImagingChannel(MCS, MetaData)
    fprintf('Collecting MDF imaging channels...  ')
    IC_Name = strings(1,4); IC_InputRange = strings(1,4);
    for i = 1:4
        IC_Name(i) = string(MCS.ReadParameter(sprintf('Scanning Ch %d Name',i-1)));
        IC_InputRange(i) = string(MCS.ReadParameter(sprintf('Scanning Ch %d Input Range',i-1)));
    end
    MetaData.ImagingChannel.Channels = [IC_Name', IC_InputRange'];
    MetaData.ImagingChannel.TotalImagingChannels = sum(MetaData.ImagingChannel.Channels(:,1)~="");
    if MetaData.ImagingChannel.TotalImagingChannels == 1
        MetaData.ImagingChannel.ActiveImagingChannel = find(MetaData.ImagingChannel.Channels(:,1) ~="");
    else
        fprintf('Multiple imaging channels detected, choose active channel.')
        MetaData.ImagingChannel.ActiveImagingChannel = listdlg("PromptString", "Choose active channel...", "SelectionMode", "single", "ListString", MetaData.ImagingChannel.Channels(:,1));
    end
    fprintf('MDF file imaging channels collected ✓\n')
end