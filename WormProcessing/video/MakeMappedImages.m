function MakeMappedImages(Folder, GCaMP_map_range,RFP_map_range,frame_seq)
% Make Mapped Images (including GCaMP and RFP images)
% 
% Input parameters: 
% Folder: The folder containg GCaMP and RFP images
% GCaMP_map_range: data range when mapping 16-bit image into 8-bit image
% RFP_map_range: data range when mapping 16-bit image into 8-bit image

image_format = '.tiff';
GCaMP_Folder = [Folder 'GCaMP\'];
RFP_Folder = [Folder 'RFP\'];
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
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
need_map_gcamp = 1;
need_map_rfp = 1;

total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    % Map GCaMP/RFP image
    image_index = frame_seq(i);
    if i==1
        gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
        GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
    else
        current_gcamp_map_name = [GCaMP_Map_Folder char(sync_names(image_index,1))];
        if strcmp(gcamp_map_name, current_gcamp_map_name) ~= 1
            gcamp_map_name = current_gcamp_map_name;
            GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
            GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
        end
    end

     if i==1
        rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        RFP_Imagename = [RFP_Folder char(sync_names(image_index,2))];
        GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
     else
        current_rfp_map_name = [RFP_Map_Folder char(sync_names(image_index,2))];
        if strcmp(rfp_map_name, current_rfp_map_name) ~= 1
            rfp_map_name = current_rfp_map_name;
            RFP_Imagename = [RFP_Folder char(sync_names(image_index,2))];
            GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
        end
     end
end

end