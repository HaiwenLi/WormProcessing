function [e,boundary,crop_region,success] = ExtractBoundaryInRFP(img)
% Extract verntral boundary from RFP image

% Paramaters
Neuron_Threshold = 50;
Background_Threshold = 150;
Magnitude_Threshold = 120;
Gabor_WaveLength = 4.0;
Local_Region = ones(15,15);
Std_Ratio = 3.5;
Mean_ratio = 1.2;
Border_Width = 10;

%%% Crop the fluorescent image
original_img = medfilt2(img);
original_img = medfilt2(original_img,[5,5]);
crop_region = CalculateCropRegion(original_img,Background_Threshold);
crop_img = double(original_img(crop_region(1):crop_region(2),crop_region(3):crop_region(4)));

%%% Calculate boundary image
% % Local threshold
% local_binary = localthresh(crop_img,Local_Region,Std_Ratio,Mean_ratio);
local_binary = crop_img > Neuron_Threshold;

% Gabor filtering
h = CreateGaborFilter(Gabor_WaveLength,0);
f1 = imfilter(crop_img,h,'replicate');
f2 = imfilter(crop_img,h','replicate');
g = (f1.^2 + f2.^2).^0.5;
binary_image = (g>=Magnitude_Threshold) & local_binary;
% binary_image = local_binary;

% Clear boundary
[image_height,image_width] = size(binary_image);
binary_image(1:Border_Width,:) = 0;
binary_image(image_height-Border_Width+1:end,:) = 0;
binary_image(:,1:Border_Width) = 0;
binary_image(:,image_width-Border_Width+1:end) = 0;

% Filtering the small connected components
small_dots = 5;
binary_image = bwareaopen(binary_image,small_dots,8);

%%% Extract boundary in small scale space
hsize = 10;
se = strel('disk',hsize);
e = imdilate(binary_image,se);
b = imresize(e,128/2048);

% Use skeletonizatio to extract boundary
[y,x] = find(b>0);
Cline_Points = [y,x];
PARAMS = GetSkeletonizationParams;
graph = Skeletonize(Cline_Points, PARAMS);
coarse_boundary = Root_Search(graph, PARAMS);
if isempty(coarse_boundary)
    boundary = [];
    success = 0;
    return;
end
boundary_points = zeros(length(coarse_boundary),2);
for i = 1:length(coarse_boundary)
    boundary_points(i,:) = graph{coarse_boundary(i)}.center;
end

%%% Refine the boundary in original space
% Map boundary points into the orginal image
points_num = size(boundary_points,1);
boundary_points = (boundary_points - repmat(size(b)/2,points_num,1))*16 + repmat(size(crop_img)/2,points_num,1);

% Research the boundary points in the original image
% boundary = zeros(size(boundary_points));
% search_radius = 6;
% intensity_ratio = 0.3;
% for i=1:points_num
%     % Firstly search
%     boundary(i,:) = UpdateNeuronPosByCentroid(crop_img,boundary_points(i,:),...
%         search_radius,intensity_ratio);
%     % Secondly search
%     boundary(i,:) = UpdateNeuronPosByCentroid(crop_img,boundary(i,:),...
%         search_radius/2,intensity_ratio);
% end
boundary = Boundary_Smooth(boundary_points,20);
success = 1;

% Draw the boundary
% imagesc(50*e);axis image;colormap('gray');hold on;
% plot(boundary(:,2),boundary(:,1),'r.-');
% hold off;
end