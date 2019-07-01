function CopyFluoImages(Folder,OutFolder,frame_seq)
% frame_seq is defined by GCaMP image index

GCaMP_Channel = 1;
RFP_Channel = 2;

Interval = 1;
CopyFolders = {'GCaMP','RFP','GCaMP_Map','RFP_Map'};
sync_struc_data = load([Folder 'sync_struc.mat']);
sync_names = sync_struc_data.sync_struc.sync_names;

for fi = 1:length(CopyFolders)
    if ~isempty(findstr(char(CopyFolders(fi)),'GCaMP'))
        channel = GCaMP_Channel;
    elseif ~isempty(findstr(char(CopyFolders(fi)),'RFP'))
        channel = RFP_Channel;
    end
  
    src_folder = [Folder char(CopyFolders(fi)) '\'];
    target_folder = [OutFolder char(CopyFolders(fi))]; 
    if ~exist(target_folder,'dir')
        mkdir(target_folder);
    end
    target_folder = [target_folder '\'];
    
    % copy files
    if nargin == 2
        frame_seq = 1:length(sync_names);
    end
    disp(['Copying ' src_folder ' to ' target_folder]);
    
    if channel == GCaMP_Channel
        for i = 1:Interval:length(frame_seq)
            image_name = char(sync_names(frame_seq(i),1));
            src_filename = [src_folder image_name];
            target_filename = [target_folder image_name];
            copyfile(src_filename,target_filename);
        end
    elseif channel == RFP_Channel
        for i = 1:Interval:length(frame_seq)
            image_name = char(sync_names(frame_seq(i),2));
            src_filename = [src_folder image_name];
            target_filename = [target_folder image_name];
            copyfile(src_filename,target_filename);
        end
    end
end
end