function Fluo_Behavior_Sync = GetSyncBehaFluoStruc(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,Fluo_Cali_TimeFolder,...
    frame_seq)
% Get synchronous behavior and fluorescence structure

% Sync behavior and fluorescene images
image_format = '.tiff';
GCaMP_Folder = [Fluo_Folder 'GCaMP\'];
RFP_Folder = [Fluo_Folder 'RFP\'];

GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
Beha_Images_Seq = GetImageSeq(Beha_Folder,image_format);

% steps: load CaliTime files
Fluo_CaliTime = GetImageSeq(Fluo_Cali_TimeFolder,image_format);
Beha_CaliTime = GetImageSeq(Beha_CaliTime_Folder,'.bin');

% steps: generate synchronous results
Fluo_Sync = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
Fluo_Sync = Fluo_Sync.sync_names;
Fluo_Behavior_Sync = SyncFluoBehaviorImages(GCaMP_Images_Seq,Fluo_CaliTime,Beha_Images_Seq,Beha_CaliTime);

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(Fluo_Sync);
end

end