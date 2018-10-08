function [binary_whole,worm_area] = WormSeg_OutEdge(img, worm_area)
% Segment worm by find outter edge and filling worm region

% Paramters
Strong_Binary_Threshold = 34;%50
Binary_Threshold = 32;
% Grad_Threshold_2 = 5;
hole_p = 0.01;

% Worm segmentation
image = double(img);
% Binary_Threshold = AdaptiveThrshold(image,worm_area);
binary_whole_img = image > Binary_Threshold;
[binary_part_img,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = image(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img);axis image;
% figure;imagesc(binary_part_img);axis image;

strong_binary_part_img = part_img > Strong_Binary_Threshold;
% figure;imagesc(strong_binary_part_img);axis image;

se = strel('disk',3);
binary_part_img = imclose(binary_part_img,se);

% sobel_h = fspecial('sobel');
% grad = (imfilter(part_img,sobel_h,'replicate').^2 + ...
%     imfilter(part_img,sobel_h','replicate').^2).^0.5;
% gaussian_h = fspecial('gaussian',[3,3],1);
% grad_smooth = imfilter(grad,gaussian_h,'replicate');
% grad_smooth(~binary_part_img) = 0;
% figure;imagesc(grad_smooth);axis image;

% se = strel('disk',2);
% binary_img1 = imclose(strong_binary_part_img,se);
% binary_img2 = grad_smooth > Grad_Threshold_2;
% grad_diff = binary_img2 - binary_img1;
% figure;imagesc(grad_diff);axis image;

lap_img = del2(double(part_img));
lap_img = lap_img .* binary_part_img;
% figure;imagesc(lap_img);axis image;

se = strel('disk',1);
binary_lap_img = lap_img < -1;
binary_lap_img = bwareaopen(binary_lap_img, 100);
binary_lap_img = imclose(binary_lap_img,se);
% figure;imagesc(binary_lap_img);axis image;

binary_img = binary_lap_img | strong_binary_part_img;
binary_img = bwareaopen(binary_img, 100);
% figure;imagesc(binary_img);axis image;

se = strel('disk',3);
binary_img = imclose(binary_img,se);
hole_area = worm_area*hole_p;
filled_binary_img = ~bwareaopen(~binary_img,ceil(hole_area));
% figure;imagesc(filled_binary_img);axis image;

binary_whole = false(size(image));
binary_whole(region_range(1):region_range(2),region_range(3):region_range(4))=...
   filled_binary_img;
end
