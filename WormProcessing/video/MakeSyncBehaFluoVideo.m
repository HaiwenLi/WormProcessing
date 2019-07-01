function MakeSyncBehaFluoVideo(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,Fluo_CaliTime_Folder,...
    GCaMP_map_range,RFP_map_range,frame_seq,frame_rate,video_name)
% Make synchronous behavior and fluorescence video

Desired_Size = [512, 512];
Theta = -89.7738;

% Sync behavior and fluorescene images
image_format = '.tiff';
GCaMP_Folder = [Fluo_Folder 'GCaMP\'];
RFP_Folder = [Fluo_Folder 'RFP\'];
[Fluo_Behavior_Sync,Fluo_Sync] = GetSyncBehaFluoStruc(Beha_Folder,Fluo_Folder,Beha_CaliTime_Folder,Fluo_CaliTime_Folder);

Fluo_Sync = Fluo_Sync.sync_names;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(Fluo_Sync);
end

% Open writer
writerObj = VideoWriter(video_name);
writerObj.FrameRate = frame_rate;
% writerObj.Quality = 90;
open(writerObj);

output_image = uint8(zeros(512,512*3,3));
for i=1:length(frame_seq)
    image_index = frame_seq(i);

    disp(['Processing: ' num2str(i) '/' num2str(length(frame_seq))]);
    
    % Load GCaMP and RFP images
    GCaMp_name = [GCaMP_Folder char(Fluo_Sync{image_index,1})];
    GCaMP_image = imread(GCaMp_name);
    GCaMP_image = MapImageTo8Bit(GCaMP_image, GCaMP_map_range);
    GCaMP_image = imresize(GCaMP_image, Desired_Size);
    
    RFP_name = [RFP_Folder char(Fluo_Sync{image_index,2})];
    RFP_image = imread(RFP_name);
    RFP_image = MapImageTo8Bit(RFP_image, RFP_map_range);
    RFP_image = imresize(RFP_image, Desired_Size);
    
    % Load behavior images
    Beha_name = [Beha_Folder char(Fluo_Behavior_Sync.sync_name{image_index,2})];
    Beha_image = imread(Beha_name);
    Beha_image = imrotate(Beha_image, Theta, 'bicubic', 'crop');
    
    % Write images into video
    output_image(:,1:512,:) = Beha_image;
    output_image(:,513:1024,1) = RFP_image;
    output_image(:,1025:512*3,2) = GCaMP_image;
    
    % add scale bar
    bar_width = 30; % 50/(0.42*4)
    bar_height = 3;
    bar_x = 1465;
    bar_y = floor(0.937*512);
    output_image(bar_y:(bar_y+bar_height-1), bar_x:(bar_x+bar_width-1), :) = 255;
    
    writeVideo(writerObj, output_image);
end
close(writerObj);

end