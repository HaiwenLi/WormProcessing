function MapImages(Folder, map_range)

Src_Folder = [Folder 'RFP\'];
Out_Folder = [Folder 'RFP_Map\'];
image_format = '.tiff';

src_seq = GetImageSeq(Src_Folder, image_format);
out_seq = GetImageSeq(Out_Folder, image_format);

if length(src_seq.image_time) ~= length(out_seq.image_time)
    disp(Src_Folder);
    for i=1:length(src_seq.image_time)
        index = src_seq.image_time(i);
        if isempty(find(out_seq.image_time == index,1))
            img_name = [src_seq.image_name_prefix num2str(index) image_format];
            disp(['Map ' img_name]);
            src_img = imread([Src_Folder img_name]);
            imwrite(MapImageTo8Bit(src_img,map_range),[Out_Folder img_name]);
        end
    end
end
end

