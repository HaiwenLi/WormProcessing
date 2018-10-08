function [neuron_binary,boundary,crop_region,success] = ExtractBoundaryInRFP_V2(deconved_img)
% Extract verntral boundary from RFP image

% Paramaters
Neuron_Threshold = 450;
Background_Threshold = 150;
small_dots = 10;

%%% Crop the fluorescent image
% original_img = medfilt2(src_img);
% original_img = medfilt2(original_img,[5,5]);
deconved_img = medfilt2(deconved_img);
deconved_img = medfilt2(deconved_img,[5,5]);
crop_region = CalculateCropRegion(deconved_img,Background_Threshold);% default: original_img
crop_img = double(deconved_img(crop_region(1):crop_region(2),crop_region(3):crop_region(4)));

%%% Neuron binary image
neuron_binary = crop_img > Neuron_Threshold;
neuron_binary = bwareaopen(neuron_binary,small_dots,8);

%%% Use skeletonization to extract boundary\
hsize = 5;
se = strel('disk',hsize);
neuron_binary = imdilate(neuron_binary,se);
small_img = imresize(neuron_binary,1/8);% scale data 8X

% % re-dialate the image
% small_hsize = 2;
% se = strel('disk',small_hsize);
% small_img = imdilate(small_img,se);

% Blind smooth curve fitting on image space
[curve_y, curve_x] = find(small_img>0);
boundary_points = blind_curve_fit(curve_x',curve_y');

% Return to the original scale
points_num = size(boundary_points,1);
boundary_points = (boundary_points - repmat(size(small_img)/2,points_num,1))*8 + repmat(size(crop_img)/2,points_num,1);

% Re-search the boundary points in the original image
boundary = zeros(size(boundary_points));
search_radius = 8;
intensity_ratio = 0.3;
for i=1:points_num
    % Firstly search
    boundary(i,:) = UpdateNeuronPosByCentroid(crop_img,boundary_points(i,:),...
        search_radius,intensity_ratio);
    % Secondly search
    boundary(i,:) = UpdateNeuronPosByCentroid(crop_img,boundary(i,:),...
        search_radius/2,intensity_ratio);
end
boundary = Boundary_Smooth(boundary_points,20);
success = 1;

% Draw the boundary
% imagesc(50*e);axis image;colormap('gray');hold on;
% plot(boundary(:,2),boundary(:,1),'r.-');
% hold off;
end