function MapImages(Folder, OutFolder, channel, map_range)

channel = lower(channel);
if strcmp(channel,'g')==1 || strcmp(channel,'green')==1
    Src_Folder = [Folder 'GCaMP\'];
    Map_Folder = [Folder 'GCaMP_Map\'];
    OutFolder = [OutFolder 'GCaMP_Map\'];
elseif strcmp(channel,'r')==1 || strcmp(channel,'red')==1
    Src_Folder = [Folder 'RFP\'];
    Map_Folder = [Folder 'RFP_Map\'];
    OutFolder = [OutFolder 'RFP_Map\'];
end

% check whether the output folder exists
image_format = '.tiff';

src_seq = GetImageSeq(Src_Folder, image_format);
out_seq = GetImageSeq(Map_Folder, image_format);

if length(src_seq.image_time) ~= length(out_seq.image_time)
    disp(Src_Folder);
    for i=1:length(src_seq.image_time)
        index = src_seq.image_time(i);
        if isempty(find(out_seq.image_time == index,1))
            if ~exist(OutFolder,'dir')
                mkdir(OutFolder);
            end
            
            img_name = [src_seq.image_name_prefix num2str(index) image_format];
            disp(['Map ' img_name]);
            src_img = imread([Src_Folder img_name]);
            %imwrite(MapImageTo8Bit(src_img,map_range),[Map_Folder img_name]);
            imwrite(MapImageTo8Bit(src_img,map_range),[OutFolder img_name]);
        end
    end
end
end

