function MakeFluoVideo(Folder,channel,frame_seq,map_range,frame_rate,video_name)
% Make fluorescence video for single channel
% 
% Input parameters: 
% Folder: image folder which contains fluorescent images
% frame_seq: image sequence needed to be made into video, default is 1:N
% map_range: data range when making video. If the type of data is UINT8,
%            this value will be [0,255], and if the type of data is UINT16,
%            this value is needed to be set by image, such as [min_v, max_v]
% channel:   image channel, taking value from {'r','g'}
% video_name: output name of the fluorescent video

image_format = '.tiff';
save_mappedimage = 1;   %whether save the mapped image, default is true

if channel == 'r'
    channel = 1;
    Image_Folder = [Folder 'RFP\'];
    Map_Folder = [Folder 'RFP_Mapped'];
elseif channel == 'g'
    channel = 2;
    Image_Folder = [Folder 'GCaMP\'];
    Map_Folder = [Folder 'GCaMP_Mapped'];
else
    disp('Invalid channel, only taking from {r,g}');
    return;
end

% Create mappped folder
if ~exist(Map_Folder,'dir')
    mkdir(Map_Folder);
end
Map_Folder = [Map_Folder '\'];

% Get imagename sequences in image folder
Images_Seq = GetImageSeq(Image_Folder,image_format);
image_time = Images_Seq.image_time;
image_name_prefix = Images_Seq.image_name_prefix;

% Start to produce the video
writerObj = VideoWriter([video_name '.avi']);
writerObj.FrameRate = frame_rate;
% writerObj.Quality = 90;
open(writerObj);

total_num = length(frame_seq);
for i=1:length(frame_seq)
     % Read image directly from the file
    image_name = [Image_Folder image_name_prefix num2str(image_time(image_index)) image_format];
    original_image = imread(image_name);

    % Post-processing of original image
    % TODO

    if (i==1)
        image_height = size(original_image,1);
        image_width = size(original_image,2);
        rgb_map_image = uint8(image_height,image_width,3);
    end
    mapped_image = MapImageTo8Bit(original_image, map_range);
    rgb_map_image(:,:,channel) = mapped_image;

    if (save_mappedimage)
        imwrite(mapped_image, [Map_Folder image_name_prefix num2str(image_time(image_index)) image_format]);
    end
    
    % write data into video
    writeVideo(writerObj,rgb_map_image); 
end
close(writerObj);

% % Convert AVI video into MP4
% ConvertAVIToMP4([[video_name '.avi']]);
end
