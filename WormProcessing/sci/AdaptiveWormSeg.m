function [binary_whole,worm_area,region_range] = AdaptiveWormSeg(img, worm_area)
% Segment worm by substracting background, finding outside edge and filling worm region
% http://www.iacl.ece.jhu.edu/static/gvf/
% 

close all;

% Parameters
Binary_Threshold = 29;
hole_p = 0.05;
sensitivity = 0.5;

% Worm segmentation
% Binary_Threshold = AdaptiveThrshold(image,worm_area);
binary_whole_img = img > Binary_Threshold;
[binary_part_img,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = img(region_range(1):region_range(2),region_range(3):region_range(4));

T = adaptthresh(img,sensitivity);
BW = imbinarize(img,T);
binary_part_img = BW(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img);axis image;
% figure;imagesc(binary_part_img);axis image;

se = strel('disk',3);
binary_part_img = imclose(binary_part_img,se);
binary_part_img = bwareaopen(binary_part_img, floor(0.1*worm_area));
binary_part_img = imclose(binary_part_img,se);
mask = imdilate(binary_part_img, se);

binary_img = activecontour(part_img.*uint8(binary_part_img), mask, 30,'edge','SmoothFactor',3);
hole_area = worm_area*hole_p;
filled_binary_img = ~bwareaopen(~binary_img,ceil(hole_area));
% figure;imagesc(filled_binary_img);axis image;

binary_whole = false(size(image));
binary_whole(region_range(1):region_range(2),region_range(3):region_range(4))=filled_binary_img;
end