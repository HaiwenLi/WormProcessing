function MakeSyncNeuronTracking(Folder, GCaMP_map_range, RFP_map_range, need_map, frame_seq)
% Make sycnchronous fluorescence video (including GCaMP and RFP images) and return neuron acticities
% 
% Input parameters: 
% Folder: The folder containg GCaMP and RFP images
%
% GCaMP_map_range: data range when mapping 16-bit image into 8-bit image,
% [min_value, max_value]
%
% RFP_map_range: data range when mapping 16-bit image into 8-bit image,
% [min_value, max_value]
%
% frame_seq: image sequence needed to be made into video, default is 1:N
% video_name: output name of the fluorescent video
% tracking_neuron:  whether the image data is packed

% image_format = '.tiff';
frame_rate = 24;
need_update_center = 1;

GCaMP_Folder = [Folder 'GCaMP\'];
RFP_Folder = [Folder 'RFP\'];

% GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
% RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
% sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_struc_data = load([Folder 'sync_struc.mat']);
sync_struc = sync_struc_data.sync_struc;
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
GCaMP_Neuron_Pos = load([Folder 'neuron_pos\green.txt']);
RFP_Neuron_Pos = load([Folder 'neuron_pos\red.txt']);
neuron_radius = load([Folder 'neuron_pos\neuron_radius.txt']);
Neuron_Num = length(neuron_radius);
disp('Load GCaMP and RFP neuron positions, starting to generate neuron tracking video');

GCaMP_activities = zeros(Neuron_Num, length(frame_seq));
RFP_activities = zeros(Neuron_Num, length(frame_seq));
neuron_names = ReadNeuronNames([Folder 'neuron_pos\neuron_name.txt'],Neuron_Num);

% Set GCaMP/RFP Map Folder
GCaMP_Map_Folder = [Folder 'GCaMP_Map\'];
if ~exist(GCaMP_Map_Folder,'dir')
    mkdir(GCaMP_Map_Folder);
end
RFP_Map_Folder =  [Folder 'RFP_Map\'];
if ~exist(RFP_Map_Folder,'dir')
    mkdir(RFP_Map_Folder);
end
need_map_rfp = need_map(1);
need_map_gcamp = need_map(2);

% Start to produce the video
writerObj = VideoWriter([Folder 'neuron_pos\NeuronTracking.avi']);
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
        gcamp_name = [GCaMP_Folder char(sync_names(image_index,1))];
        GCaMP_Image = imread(gcamp_name);
%         gcamp_mapimage = MapImageTo8Bit(GCaMP_Image, GCaMP_map_range);
        gcamp_mapimage = GetMapImage(need_map_gcamp, gcamp_name, GCaMP_map_range, gcamp_map_name);
    else
        current_gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        if strcmp(gcamp_map_name, current_gcamp_map_name) ~= 1
            gcamp_map_name = current_gcamp_map_name;
            gcamp_name = [GCaMP_Folder char(sync_names(image_index,1))];
            GCaMP_Image = imread(gcamp_name);
%             gcamp_mapimage = MapImageTo8Bit(GCaMP_Image, GCaMP_map_range);
            gcamp_mapimage = GetMapImage(need_map_gcamp, gcamp_name, GCaMP_map_range, gcamp_map_name);
        end
   end
   
    if i==1
        rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        rfp_name = [RFP_Folder char(sync_names(image_index,2))];
        RFP_Image = imread(rfp_name);
%         rfp_mapimage = MapImageTo8Bit(RFP_Image, RFP_map_range);
        rfp_mapimage = GetMapImage(need_map_rfp, rfp_name, RFP_map_range, rfp_map_name);
     else
        current_rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        if strcmp(rfp_map_name, current_rfp_map_name) ~= 1
            rfp_map_name = current_rfp_map_name;
            rfp_name = [RFP_Folder char(sync_names(image_index,2))];
            RFP_Image = imread(rfp_name);
%             rfp_mapimage = MapImageTo8Bit(RFP_Image, RFP_map_range);
            rfp_mapimage = GetMapImage(need_map_rfp, rfp_name, RFP_map_range, rfp_map_name);
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

     % Calculate neuron activities
     for j=1:Neuron_Num
        rfp_index = match_index(image_index) - match_index(frame_seq(1)) + 1;

        % Extract fluorescence energy and background
        GCaMP_Center = GCaMP_Neuron_Pos((i-1)*Neuron_Num+j,:);
        RFP_Center = RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+j,:);

        if isnan(neuron_radius(j)) || neuron_radius(j) == 0
            GCaMP_activities(j,i) = nan;
            RFP_activities(j,i) = nan;
        else
            % Update neuron position
            if need_update_center == 1
                % update gcamp center
                [GCaMP_x, GCaMP_y] = UpdateNeuronPos(GCaMP_Center(1),GCaMP_Center(2),neuron_radius(j)/2,0.5,GCaMP_Image);
%                 [GCaMP_x, GCaMP_y] = UpdateNeuronPos(GCaMP_x,GCaMP_y,neuron_radius(j)/2,0.5,GCaMP_Image);
                
                % update rfp center
                [RFP_x, RFP_y] = UpdateNeuronPos(RFP_Center(1),RFP_Center(2),neuron_radius(j)/2,0.5,RFP_Image);
%                 [RFP_x, RFP_y] = UpdateNeuronPos(RFP_x,RFP_y,neuron_radius(j)/2,0.5,RFP_Image);
                
                GCaMP_Neuron_Pos((i-1)*Neuron_Num+j,:) = [GCaMP_x, GCaMP_y];
                RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+j,:) = [RFP_x, RFP_y];
            else
                GCaMP_x = GCaMP_Center(1); GCaMP_y = GCaMP_Center(2);
                RFP_x = RFP_Center(1); RFP_y = RFP_Center(2);
            end

            [GCaMP_activities(j,i), ~] = ExtractFluoEnergyAndBackground(GCaMP_Image,[GCaMP_x, GCaMP_y],neuron_radius(j),1.0);
            [RFP_activities(j,i), ~] = ExtractFluoEnergyAndBackground(RFP_Image,[RFP_x, RFP_y],neuron_radius(j),1.0);
        end
    end

    % Post-processing of original image
    % Draw the tracked neurons in GCaMP and RFP images, respectively
    % Draw neuron in image
    color = 'white'; % Now color only can be white, red, green, blue.    
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

%% save neuron activities
FluoData.GCaMP_activities = GCaMP_activities;
FluoData.RFP_activities = RFP_activities;
FluoData.neuron_names = neuron_names;
save([Folder 'neuron_pos\FluoData.mat'],'FluoData');

% save neuron positions
save_neuron_pos(GCaMP_Neuron_Pos, [Folder 'neuron_pos\updated_green.txt']);
save_neuron_pos(RFP_Neuron_Pos, [Folder 'neuron_pos\updated_red.txt']);

%% Convert the video into mp4 format
% disp('Start to convert avi format video into MP4 format');
% ConvertAVIToMP4([video_name '.avi']);

end
