function worm_pos = ComputeWormSpeed_ByCentroid(Folder,frame_seq)

img_format = '.tiff';
p = 10;

img_seq = GetImageSeq(Folder,img_format);
image_time = img_seq.image_time;
prefix = img_seq.image_name_prefix;

worm_pos = zeros(length(frame_seq),2);
for i=1:length(frame_seq)
    index = frame_seq(i);
    img_name = [Folder prefix num2str(image_time(index)) img_format];
    img = imread(img_name);
    
    crop_region = CalculateCropRegion(img,p);
    worm_pos(i,:) = CalculateWormCentroid(img, crop_region);
end

end