function MakeSyncFluoVideo(Folder, GCaMP_map_range, RFP_map_range, frame_seq, frame_rate, video_name)
% Make sycnchronous fluorescence video (including GCaMP and RFP images)
% 
% Input parameters: 
% Folder: The folder containg GCaMP and RFP images
% GCaMP_map_range: data range when mapping 16-bit image into 8-bit image
% RFP_map_range: data range when mapping 16-bit image into 8-bit image
% frame_seq: image sequence needed to be made into video, default is 1:N
% video_name: output name of the fluorescent video

image_format = '.tiff';
GCaMP_Folder = [Folder 'GCaMP\'];
RFP_Folder = [Folder 'RFP\'];
% GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
% RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
% sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_data = load([Folder 'sync_struc.mat']);

sync_struc = sync_data.sync_struc;
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Set GCaMP/RFP Map Folder
GCaMP_Map_Folder = [Folder 'GCaMP_Map'];
if ~exist(GCaMP_Map_Folder,'dir')
    mkdir(GCaMP_Map_Folder);
end
GCaMP_Map_Folder = [GCaMP_Map_Folder '\'];

RFP_Map_Folder =  [Folder 'RFP_Map'];
if ~exist(RFP_Map_Folder,'dir')
    mkdir(RFP_Map_Folder);
end
RFP_Map_Folder = [RFP_Map_Folder '\'];
need_map_gcamp = 0;
need_map_rfp = 0;

% Start to produce the video
writerObj = VideoWriter([video_name '.avi']);
writerObj.FrameRate = frame_rate;
% writerObj.Quality = 90;
open(writerObj);

total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    % Map GCaMP/RFP image
    image_index = frame_seq(i);
    if i==1
        gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
        gcamp_mapimage = GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
    else
        current_gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        if strcmp(gcamp_map_name, current_gcamp_map_name) ~= 1
            gcamp_map_name = current_gcamp_map_name;
            GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
            gcamp_mapimage = GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
        end
    end

     if i==1
        rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        RFP_Imagename = [RFP_Folder char(sync_names(image_index,2))];
        rfp_mapimage = GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
     else
        current_rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        if strcmp(rfp_map_name, current_rfp_map_name) ~= 1
            rfp_map_name = current_rfp_map_name;
            RFP_Imagename = [RFP_Folder char(sync_names(image_index,2))];
            rfp_mapimage = GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
        end
    end

    if (i==1)
        [GCaMP_Image_Height, GCaMP_Image_Width] = size(gcamp_mapimage);
        [RFP_Image_Height, RFP_Image_Width] = size(rfp_mapimage);
        image_height = max(GCaMP_Image_Height, RFP_Image_Height);
        image_width = GCaMP_Image_Width + RFP_Image_Width;
        rgb_map_image = uint8(zeros(image_height,image_width,3));
    else
        rgb_map_image(:,:,:) = 0;
    end
    
    rgb_map_image(1:RFP_Image_Height,1:RFP_Image_Width,1) = rfp_mapimage;
    rgb_map_image(1:GCaMP_Image_Height,RFP_Image_Width+1:image_width,2) = gcamp_mapimage;
        
    % write data into video
    writeVideo(writerObj,rgb_map_image); 
end
close(writerObj);

% % Convert video into MP4 format
% ConvertAVIToMP4([video_name '.avi']);
end