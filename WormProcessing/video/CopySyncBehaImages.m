function CopySyncBehaImages(Beha_Folder,Fluo_Behavior_Sync,frame_seq)
% extract and copy synchronous behavior images
% Input:
% frame_seq: frame sequence in green channel

sync_names = Fluo_Behavior_Sync.sync_name;
Beha_ImageFolder = [Beha_Folder 'Image\'];
Sync_Beha_ImageFolder = [Beha_Folder 'Sync_Image\'];

if ~exist(Sync_Beha_ImageFolder,'dir')
    mkdir(Sync_Beha_ImageFolder);
end

last_beha_index = 0;
for i=1:length(frame_seq)
    img_index = frame_seq(i);
    beha_index = Fluo_Behavior_Sync.beha_index(i);
    img_name = char(sync_names(img_index,2));
    disp(['Copying ' num2str(img_index) '/' num2str(frame_seq(end))]);
    
    if i == 1 || last_beha_index ~= beha_index
        last_beha_index = beha_index;
        copyfile([Beha_ImageFolder img_name],[Sync_Beha_ImageFolder img_name]);
    end
end

end