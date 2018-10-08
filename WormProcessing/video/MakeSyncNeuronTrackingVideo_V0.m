function MakeSyncNeuronTrackingVideo(Img_Folder, Neuoron_Pos_Folder, Neuron_Num, GCaMP_map_range,...
    RFP_map_range, frame_seq, frame_rate, video_name)
% Make sycnchronous fluorescence video (including GCaMP and RFP images)
% 
% Input parameters: 
% Folder: The folder containg GCaMP and RFP images
% GCaMP_map_range: data range when mapping 16-bit image into 8-bit image
% RFP_map_range: data range when mapping 16-bit image into 8-bit image
% frame_seq: image sequence needed to be made into video, default is 1:N
% video_name: output name of the fluorescent video
% tracking_neuron:  whether the image data is packed

image_format = '.tiff';
Deconved_Folder = 'K:\Deconved\';

GCaMP_Folder = [Img_Folder 'GCaMP\'];
RFP_Folder = [Img_Folder 'RFP\'];
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
GCaMP_Neuron_Pos = load([Neuoron_Pos_Folder 'green.txt']);
RFP_Neuron_Pos = load([Neuoron_Pos_Folder 'red.txt']);
disp('Load GCaMP and RFP neuron positions, starting to generate neuron tracking video');

% Set GCaMP/RFP Map Folder
% GCaMP_Map_Folder = [Img_Folder 'GCaMP_Map'];
% if ~exist(GCaMP_Map_Folder,'dir')
%     need_map_gcamp = 1;
%     mkdir(GCaMP_Map_Folder);
% else
%     need_map_gcamp = 0;
% end
% GCaMP_Map_Folder = [GCaMP_Map_Folder '\'];
% 
% RFP_Map_Folder =  [Img_Folder 'RFP_Map'];
% if ~exist(RFP_Map_Folder,'dir')
%     need_map_rfp = 1;
%     mkdir(RFP_Map_Folder);
% else
%     need_map_rfp = 0;
% end
% RFP_Map_Folder = [RFP_Map_Folder '\'];

% Start to produce the video
writerObj = VideoWriter([video_name '.avi']);
writerObj.FrameRate = frame_rate;
writerObj.Quality = 90;
open(writerObj);

total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    % Map GCaMP/RFP image
    image_index = frame_seq(i);
   if i==1
%         gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        gcamp_name = [GCaMP_Folder char(sync_names(image_index,1))];
        GCaMP_img = imread(gcamp_name);
        gcamp_mapimage = MapImageTo8Bit(GCaMP_img, GCaMP_map_range);
%         gcamp_mapimage = GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
    else
%         current_gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        current_gcamp_name = [GCaMP_Folder char(sync_names(image_index,1))];
        if strcmp(gcamp_name, current_gcamp_name) ~= 1
            gcamp_name = current_gcamp_name;
%             gcamp_name = [GCaMP_Folder char(sync_names(image_index,1))];
            GCaMP_img = imread(gcamp_name);
            gcamp_mapimage = MapImageTo8Bit(GCaMP_img, GCaMP_map_range);
%             gcamp_mapimage = GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
        end
    end

     if i==1
%         rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        rfp_name = [RFP_Folder char(sync_names(image_index,2))];
        RFP_img = imread(rfp_name);
        rfp_mapimage = MapImageTo8Bit(RFP_img, RFP_map_range);
%         rfp_mapimage = GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
     else
%         current_rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        current_rfp_name = [RFP_Folder char(sync_names(image_index,2))];
        if strcmp(rfp_name, current_rfp_name) ~= 1
            rfp_name = current_rfp_name;
%             rfp_name = [RFP_Folder char(sync_names(image_index,2))];
            RFP_img = imread(rfp_name);
            rfp_mapimage = MapImageTo8Bit(RFP_img, RFP_map_range);
%             rfp_mapimage = GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
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

    % Post-processing of original image
    % Draw the tracked neurons in GCaMP and RFP images, respectively
    % Draw neuron in image
    color = 'white'; % Now color only can be white, red, green, blue.
    neuron_radius = 4;
    intensity_ratio = 0.25;
    
    rgb_map_image(1:RFP_Image_Height,1:RFP_Image_Width,1) = rfp_mapimage;
    rgb_map_image(1:GCaMP_Image_Height,RFP_Image_Width+1:image_width,2) = gcamp_mapimage;
    
    % Add neuron labels in GCaMP image
    neuron_pos = GCaMP_Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:);
    %neuron_pos = UpdateNeuronPosByCentroid(GCaMP_Image,neuron_pos,neuron_radius,intensity_ratio);
    neuron_pos = neuron_pos + repmat([RFP_Image_Width 0],Neuron_Num,1);
    rgb_map_image = DrawNeuronsInRGBImage(rgb_map_image,neuron_pos,neuron_radius,color);
    
    % Add neuron labels in RFP image
    rfp_index = match_index(image_index) - match_index(frame_seq(1)) + 1;
    neuron_pos = RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+1:rfp_index*Neuron_Num,:);
    %neuron_pos = UpdateNeuronPosByCentroid(RFP_Image,neuron_pos,neuron_radius,intensity_ratio);
    rgb_map_image = DrawNeuronsInRGBImage(rgb_map_image,neuron_pos,neuron_radius,color);
    
    % write data into video
    writeVideo(writerObj,rgb_map_image); 
end
close(writerObj);

% Convert the video into mp4 format
disp('Start to convert avi format video into MP4 format');
ConvertAVIToMP4([video_name '.avi']);

end
