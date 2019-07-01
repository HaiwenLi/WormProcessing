function GetSyncBehaFluoImages(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,Fluo_CaliTime_Folder,...
    GCaMP_map_range,RFP_map_range,frame_seq,OutFolder)
% Make synchronous behavior and fluorescence video

Theta = -89.7738;

% Sync behavior and fluorescene images
image_format = '.tiff';
GCaMP_Folder = [Fluo_Folder 'GCaMP\'];
RFP_Folder = [Fluo_Folder 'RFP\'];
Fluo_Behavior_Sync = GetSyncBehaFluoStruc(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,Fluo_CaliTime_Folder);

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(Fluo_Sync);
end

for i=1:length(frame_seq)
    image_index = frame_seq(i);

    disp(['Processing: ' num2str(i) '/' num2str(length(frame_seq))]);
    
    % Load GCaMP and RFP images
    GCaMp_name = [GCaMP_Folder char(Fluo_Sync{image_index,1})];
    GCaMP_image = imread(GCaMp_name);
%     GCaMP_image = MapImageTo8Bit(GCaMP_image, GCaMP_map_range);

    RFP_name = [RFP_Folder char(Fluo_Sync{image_index,2})];
    RFP_image = imread(RFP_name);
%     RFP_image = MapImageTo8Bit(RFP_image, RFP_map_range);

    % Load behavior images
    Beha_name = [Beha_Folder char(Fluo_Behavior_Sync{image_index,2})];
    Beha_image = imread(Beha_name);
    Beha_image = imrotate(Beha_image, Theta, 'bicubic', 'crop');
    
    folder = [OutFolder 'Frame-'  num2str(image_index)];
    if ~exist(folder,'dir')
        mkdir([OutFolder 'Frame-' num2str(image_index)]);
    end
    folder = [folder '\'];
    imwrite(RFP_image,[folder 'red.tiff'],'resolution',300);
    imwrite(GCaMP_image,[folder 'green.tiff'],'resolution',300);
    imwrite(Beha_image,[folder 'behavior.tiff'],'resolution',300);
end

end