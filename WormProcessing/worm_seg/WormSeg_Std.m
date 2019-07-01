function [binary_image,worm_area,worm_region] = WormSeg_Std(img, worm_area, thres, worm_region)
% Segment worm by gradient method

% Paramters
Grad_Threshold_1 = 10; % worm body threshold
Grad_Threshold_2 = 5; % background threshold
hole_portition = 0.05; 

% Calculate candidate worm reggion
[img_height, img_width] = size(img);
margin = 80;
min_row = max(1,worm_region(1)-margin);
max_row = min(img_height, worm_region(2)+margin);
min_col = max(1, worm_region(3)-margin);
max_col = min(img_width, worm_region(4)+margin);

% Worm segmentation
Binary_Threshold = thres;
image = double(img(min_row:max_row, min_col:max_col));
binary_whole_img = image > Binary_Threshold; % worm is daker than backgroud

[~,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = image(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img);axis image;
% figure;imagesc(binary_part_img);axis image;

% Calculate the gradient of image
sobel_h = fspecial('sobel'); 
grad = (imfilter(part_img,sobel_h,'replicate').^2 + ...
    imfilter(part_img,sobel_h','replicate').^2).^0.5;
grad(grad < Grad_Threshold_2) = 0; %抑制非线虫区域
% figure;imagesc(grad);axis image;

nhood = ones(5,5);
local_std = stdfilt(grad,nhood);
% figure;imagesc(local_std);axis image;

% Calculate worm binary region
hole_area = worm_area*hole_portition;
binary_image = local_std >= Grad_Threshold_1;
binary_image = bwareaopen(binary_image, floor(worm_area * 0.1)); % remove points outside the worm
binary_image = ~bwareaopen(~binary_image, floor(hole_area)); % fill some hodes in worm body

se = strel('disk',4);
binary_image = imerode(binary_image, se);% erode worm body
binary_image = imclose(binary_image, se);% make boundary be smooth
worm_area = sum(binary_image(:)); % update worm area
worm_region = [min_row + region_range(1), min_row + region_range(2),...
               min_col + region_range(3), min_col + region_range(4)];

% 如上计算的线虫区域基本可以。若需要更准确的边缘，还需要active contour收敛至真实边缘
% 可以通过局部阈值进行边缘像素处理

end
