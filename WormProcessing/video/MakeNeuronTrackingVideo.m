function MakeNeuronTrackingVideo(Folder, frame_seq, NeuronPos_File, Neuron_Num, map_range, frame_rate, channel, video_name)
% Make fluorescence video with tracked neurons in GCaMP/RFP images
% 
% Input parameters: 
% Folder:      The folder containg GCaMP and RFP images
% frame_seq:   image sequence needed to be made into video, default is 1:N
% NeuronPos_File, Neuron_Num
% map_range: data range when mapping 16-bit image into 8-bit image
% channel:    image channel, taking value from {'r','g'}
% video_name: output name of the fluorescent video

image_format = '.tiff';
Src_Folder = 'K:\FluoImages\';
Deconved_Folder = 'K:\Deconved\';

if channel == 'r'
    channel = 1;
    Image_Folder = [Src_Folder Folder 'RFP\'];
    Map_Folder = [Src_Folder Folder 'RFP_Mapped'];
elseif channel == 'g'
    channel = 2;
    Image_Folder = [Src_Folder Folder 'GCaMP\'];
    Map_Folder = [Src_Folder Folder 'GCaMP_Mapped']
else
    disp('Invalid channel, only taking from {r,g}');
    return;
end

if exist(Map_Folder, 'dir')
    need_map = 0;
else
    mkdir(Map_Folder);
    need_map = 1;
end
Map_Folder = [Map_Folder '\'];

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

Images_Seq = GetImageSeq(Image_Folder,image_format);
image_time = Images_Seq.image_time;
image_name_prefix = Images_Seq.image_name_prefix;

% Load neuron positions from the file
Neuron_Pos = load(NeuronPos_File);
disp('Load GCaMP neuron positions, starting to generate neuron tracking video');

% Start to make the video
writerObj = VideoWriter([video_name '.avi']);
writerObj.FrameRate = frame_rate;
writerObj.Quality = 90;
open(writerObj);

total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    image_index = frame_seq(i);
    if need_map
        Image = imread([Image_Folder image_name_prefix num2str(image_time(image_index)) image_format]);
        mapped_image = MapImageTo8Bit(Image,map_range);

        % Save mapped_image into Map Folder
        imwrite(mapped_image, [Map_Folder image_name_prefix num2str(image_time(image_index)) image_format]);
    else
        mapped_image = imread([Map_Folder image_name_prefix num2str(image_time(image_index)) image_format]);
    end
    
    % Post-processing of original image
    % Draw the tracked neurons in GCaMP and RFP images, respectively
    % Draw neuron in image
    color = 'white'; % Now color only can be white, red, green, blue.
    neuron_radius = 4;
    intensity_ratio = 0.25;
    rgb_map_image(:,:,channel) = mapped_image;
    
    % Add neuron labels in image
    neuron_pos = Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:);
    %neuron_pos = UpdateNeuronPosByCentroid(Image,neuron_pos,neuron_radius,intensity_ratio);
    rgb_map_image = DrawNeuronsInRGBImage(rgb_map_image,neuron_pos,neuron_radius,color);
    
    % write data into video
    writeVideo(writerObj,rgb_map_image); 
end
close(writerObj);

% Convert AVI video into MP4
ConvertAVIToMP4([[video_name '.avi']]);
end
