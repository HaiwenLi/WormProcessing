function Fluo_Behavior_Sync = GetSyncBehaFluoStruc(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,...
    Fluo_Cali_TimeFolder,frame_seq)
% Get the sync stuct of fluorescence and behavior images

% Sync behavior and fluorescene images
image_format = '.tiff';
GCaMP_Folder = [Fluo_Folder 'GCaMP\'];

% step 0: load fluorescence and behavior images
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
Beha_Images_Seq = GetImageSeq(Beha_Folder,image_format);

% steps 1: load CaliTime files
Fluo_CaliTime = GetImageSeq(Fluo_Cali_TimeFolder,image_format);
Beha_CaliTime = GetImageSeq(Beha_CaliTime_Folder,'.bin');

% steps 2: generate synchronous results
Fluo_Behavior_Sync_Tmp = SyncFluoBehaviorImages(GCaMP_Images_Seq,Fluo_CaliTime,Beha_Images_Seq,Beha_CaliTime);

Fluo_Behavior_Sync.beha_index = Fluo_Behavior_Sync_Tmp.index(frame_seq);
Fluo_Behavior_Sync.fluo_time = Fluo_Behavior_Sync_Tmp.fluo_time(frame_seq);
Fluo_Behavior_Sync.beha_time = Fluo_Behavior_Sync_Tmp.beha_time(frame_seq);

end