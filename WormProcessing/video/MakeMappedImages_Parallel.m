function MakeMappedImages_Parallel(Folder,GCaMP_map_range,RFP_map_range,data_range)
% Make Mapped Images (including GCaMP and RFP images) by using parallel for
% loops of MATLAB
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

if strcmp(data_range,'all') == 1
    data_range = [1, length(sync_names)];
end

GCaMP_Sync_Names = sync_names(:,1);
RFP_Sync_Names = sync_names(:,2);
parfor image_index = data_range(1):data_range(2)
    % Map GCaMP/RFP image
    gcamp_map_name = [GCaMP_Map_Folder char(GCaMP_Sync_Names(image_index))];
    GCaMP_Imagename = [GCaMP_Folder char(GCaMP_Sync_Names(image_index))];
    GetMapImage(need_map_gcamp, GCaMP_Imagename, GCaMP_map_range, gcamp_map_name);
    

    rfp_map_name = [RFP_Map_Folder char(RFP_Sync_Names(image_index))];
    RFP_Imagename = [RFP_Folder char(RFP_Sync_Names(image_index))];
    GetMapImage(need_map_rfp, RFP_Imagename, RFP_map_range, rfp_map_name);
end

end