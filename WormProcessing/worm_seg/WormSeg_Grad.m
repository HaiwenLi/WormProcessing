function [binary_whole,worm_area] = WormSeg_Grad(img, worm_area)
% Segment worm by gradient methods

% Paramters
Grad_Threshold_1 = 40;
Grad_Threshold_2 = 5;
hole_p = 0.04;
Binary_Threshold = 32;

% Worm segmentation
image = double(img);
% Binary_Threshold = AdaptiveThrshold(image,worm_area);
binary_whole_img = image > Binary_Threshold;
[binary_part_img,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = image(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img);axis image;
% figure;imagesc(binary_part_img);axis image;

se = strel('disk',3);
binary_part_img = imclose(binary_part_img,se);

sobel_h = fspecial('sobel');
grad = (imfilter(part_img,sobel_h,'replicate').^2 + ...
    imfilter(part_img,sobel_h','replicate').^2).^0.5;
gaussian_h = fspecial('gaussian',[3,3],1);
grad_smooth = imfilter(grad,gaussian_h,'replicate');
grad_smooth(~binary_part_img) = 0;
% figure;imagesc(grad_smooth);axis image;

se = strel('disk',2);
grad_binary_img1 = grad_smooth > Grad_Threshold_1;
grad_binary_img1 = imclose(grad_binary_img1,se);
grad_binary_img2 = grad_smooth > Grad_Threshold_2;
grad_diff = grad_binary_img2 - grad_binary_img1;
% figure;imagesc(grad_diff);axis image;

dist_matrix = bwdist(~grad_binary_img2);
boundary_img = dist_matrix <= 2;
fill_part = grad_diff & ~boundary_img;
fill_part = bwareaopen(fill_part, 15);
% figure;imagesc(fill_part);axis image;

se = strel('disk',3);
fill_part = imclose(fill_part,se);
% figure;imagesc(fill_part);axis image;

binary_img = grad_binary_img1 | fill_part;
% se = strel('disk',2);
% binary_img = imclose(binary_img,se);
hole_area = worm_area*hole_p;
binary_img = ~bwareaopen(~binary_img, floor(hole_area));
%     se = strel('disk',2);
%     binary_img = imdilate(binary_img,se);

% binary_img = xor(binary_part_img,grad_binary_img)| grad_binary_img;
% binary_img = binary_part_img;
% se = strel('disk',3, 8);
%     grad_binary_img = imclose(grad_binary_img,se);
%     grad_binary_img = imfill(grad_binary_img,'holes');
%     binary_img = grad_binary_img;
% figure;imagesc(binary_img);axis image;

% lap_img = del2(part_img);
% %lap_img = medfilt2(lap_img);
% figure;imagesc(lap_img);axis image;
% 
% binary_lap = (lap_img < Lap_Threshold).*binary_part_img;
% binary_lap = medfilt2(binary_lap);
% % remove less than 16 objects
% figure;imagesc(lap_img.*binary_lap);axis image;
% 
% dist_matrix = bwdist(~binary_part_img);
% figure;imagesc(dist_matrix);axis image;
% 
% dist_boundary = dist_matrix(logical(binary_lap));
% % %     figure;imagesc(dist_matrix.*binary_lap);axis image;
% shrunk_edge = max(median(dist_boundary)-2,3)
% 
% %     shrunk_edge = sqrt(2);
% shrunk_binary_img = dist_matrix > shrunk_edge;
% figure;imagesc(shrunk_binary_img);axis image;
   
se = strel('disk',2);
binary_whole = false(size(image));
binary_whole(region_range(1):region_range(2),region_range(3):region_range(4))=...
   binary_img; 
binary_whole = imclose(binary_whole,se);
binary_whole = imerode(binary_whole,strel('disk',1));
binary_whole = imopen(binary_whole,se);
binary_img = binary_whole(region_range(1):region_range(2),region_range(3):region_range(4));
% figure;imagesc(part_img - binary_img.*part_img);axis image;
% figure;imagesc(image - binary_whole.*image);axis image;colormap(gray);

end
