function [binary_whole,worm_area] = WormSeg_Contour(img, worm_area, sensitivity)
% Segment worm by active contour (matlab function)

% Paramters
hole_p = 0.01;
% sensitivity = 0.53; % sensitivity used in adaptive thresholding
IterNum = 18;       % iteration for active contour

% Worm segmentation
image = double(img);
T = adaptthresh(img, sensitivity);
binary_whole_img = imbinarize(img,T);
binary_whole_img = bwareaopen(binary_whole_img, 100);

[binary_part_img,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = image(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img);axis image;
% figure;imagesc(binary_part_img);axis image;

% use active contour to segment worm region
se = strel('disk',3);
mask = imdilate(binary_part_img,se);
binary_img = activecontour(part_img,mask,IterNum,'edge');

se = strel('disk',3);
binary_img = imclose(binary_img,se);
hole_area = worm_area*hole_p;
filled_binary_img = ~bwareaopen(~binary_img,ceil(hole_area));
% figure;imagesc(filled_binary_img);axis image;

binary_whole = false(size(image));
binary_whole(region_range(1):region_range(2),region_range(3):region_range(4))=...
   filled_binary_img;
end
