function WormBinarize(Image_Folder,OutFolder)

% Read all images and res files in Folder
res_seq = GetImageSeq(Image_Folder, '.tiff');
prefix = res_seq.image_name_prefix;
time = res_seq.image_time;

worm_area = 1400;
sensitivity = 0.5;

for i=1:length(time)
    image_name = [prefix num2str(time(i)) '.tiff'];
    disp(image_name);
    
    img = imread([Image_Folder  image_name]);
    
    [binary_whole,worm_area] = WormSeg_Contour(img, worm_area, sensitivity);
    imwrite(uint8(binary_whole*255),[OutFolder image_name]);
end
end