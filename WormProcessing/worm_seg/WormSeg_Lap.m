function [binary_whole, worm_area] = WormSeg_Lap(img, worm_area)
% Segment worm by laplace transform

% Parameters
Lap_Threshold = 0;
Small_Object_Threshold = 16;
Min_Shrunk_Threshold = 3;
Shrunk_Reduce_Threshold = 2;

% Worm segmentation
Binary_Threshold = AdaptiveThrshold(img,worm_area);
binary_whole_img = img > Binary_Threshold;
[binary_part_img,region_range,worm_area] =...
    Denoise_And_Worm_Locate(binary_whole_img, worm_area);
part_img = image(region_range(1):region_range(2),region_range(3):region_range(4));

% Compute laplacian matrix
lap_img = del2(part_img);
% figure;imagesc(lap_img);axis image;

binary_lap = (lap_img < Lap_Threshold).*binary_part_img;
% binary_lap = medfilt2(binary_lap);
binary_lap = bwareaopen(binary_lap, Small_Object_Threshold);
% imagesc(lap_img.*binary_lap);axis image;

dist_matrix = bwdist(~binary_part_img);
%     figure;imagesc(dist_matrix);axis image;

dist_boundary = dist_matrix(logical(binary_lap));
%    figure;imagesc(dist_matrix.*binary_lap);axis image;
shrunk_edge = max(median(dist_boundary)-Shrunk_Reduce_Threshold ,...
    Min_Shrunk_Threshold);

shrunk_binary_img = dist_matrix > shrunk_edge;
binary_whole = false(size(image));
binary_whole(region_range(1):region_range(2),region_range(3):region_range(4))=...
   shrunk_binary_img; 

% imagesc(binary_whole);axis image;

end
