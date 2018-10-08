function e = ExtractBoundaryInRFP(img)
% Extract verntral boundary from RFP image

% Use otsu method to find the global threshold
% background = 140;
% g_threshold = 25;
% 
% original_img = medfilt2(img);
% original_img = medfilt2(original_img,[5,5]);
% % original_img = medfilt2(original_img);
% original_img = double(original_img);
% 
% % Calculate gradient of image
% h = CreateGaborFilter(3,0);
% f1 = imfilter(original_img,h,'replicate');
% f2 = imfilter(original_img,h','replicate');
% g = (f1.^2 + f2.^2).^0.5;
% binary_image = (g>=g_threshold) & (original_img>background);
% 
% % Filtering the small connected componnets
% small_dots = 5;
% binary_image = bwareaopen(binary_image,small_dots,8);
% e = binary_image;

% % Using Gauusian filter to smooth the image
% sigma = 3;
% hsize = 7;
% h = fspecial('gaussian',hsize,sigma);
% g = imfilter(original_img,h,'replicate');
% binary_image = g > background;

% Curve searching
binary_image = img > 0;
hsize = 5;
se = strel('disk',hsize);
e = imdilate(binary_image,se);
b = imresize(e,[128,128]);
imagesc(50*b);axis image;

% imagesc(50*e);axis image;colormap(gray);

% Determine gross worm head position
% e = DetermineWormHead(e);

% lap_threshdold = -0.5;
% dist_matrix = bwdist(double(~e));
% lap_matrix = del2(dist_matrix);
% boundary_im = dist_matrix <= hsize+1;
% lap_matrix = lap_matrix + medfilt2(lap_matrix);
% lap_matrix = lap_matrix.*(~boundary_im);
% edge_im = lap_matrix <= lap_threshdold;
% 
% % Using skeletonization to search boundary points
% [px,py] = find(edge_im>0);
% Candidate_Points = [px,py];
% CONST_VALUE = Const_Set();
% [graph, pruned_graph] = Skeletonize_And_Graph_Prune(Candidate_Points, CONST_VALUE);
% Boundary = Root_Search(pruned_graph, CONST_VALUE);
% Boundary_Points = zeros(length(Boundary),2);
% for i = 1:length(Boundary)
%     Boundary_Points(i,:) = pruned_graph{Boundary(i)}.center;
% end
% % boundary = Boundary_Smooth(Boundary_Points(2:end,:),3);
% boundary = Boundary_Points;
% 
% % Draw the boundary
% imagesc(80*edge_im + 50*e);axis image;colormap('gray');hold on;
% plot(boundary(:,2),boundary(:,1),'r.-');
% hold off;
end

function filtered_worm = DetermineWormHead(bw)
% Determine the gross worm head position in binary image
% Since the fluorescene arae is the largest region in worm, then we can
% calculate worm head position by finding the local maximum vaerage area

dist_ratio = 0.6;
head_size = 150;
border_size = 10;

% Calculate the dist and extract head region
dist = bwdist(~bw);
max_dist = max(max(dist));
[head_y, head_x] = find(dist == max_dist);

min_y = max(1,head_y-head_size);
min_x = max(1,head_x-head_size);
max_y = min(size(bw,1), head_y+head_size);
max_x = min(size(bw,2), head_x+head_size);
head_region = dist(min_y:max_y,min_x:max_x);

% Clear border in distance matrix
% head_region_height = size(head_region,1);
% head_region_width = size(head_region,2);
% head_region(1:border_size,:) = 0;
% head_region(:,1:border_size) = 0;
% head_region(head_region_height-border_size+1:end,:) = 0;
% head_region(:,head_region_width-border_size+1:end) = 0;

% Calculate the conncted components in the head region
cc = bwconncomp(head_region);
S = regionprops(cc,'Centroid');
centroids = S.Centroid;
centroids = centroids + repmat([min_y,min_x],size(centroids,1),1);

min_y = max(1,head_y-head_size);
min_x = max(1,head_x-head_size);
max_y = min(size(bw,1), head_y+head_size);
max_x = min(size(bw,2), head_x+head_size);
head_region = dist(min_y:max_y,min_x:max_x) >= dist_ratio*max_dist;

se = strel('disk',3);

head_region_height = size(head_region,1);
head_region_width = size(head_region,2);
head_region(1:border_size,:) = 0;
head_region(:,1:border_size) = 0;
head_region(head_region_height-border_size+1:end,:) = 0;
head_region(:,head_region_width-border_size+1:end) = 0;

filtered_worm = bw;
filtered_worm(min_y:max_y,min_x:max_x) = imclose(head_region,se);

% imagesc(filtered_worm);axis image;
end