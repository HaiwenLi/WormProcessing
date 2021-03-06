function [binary_image, worm_xy_range, worm_area] =...
    Denoise_And_Worm_Locate(binary_image_whole, worm_area)

% 加入位置信息判断

hole_portition = 0.015;
hole_area = worm_area*hole_portition;

% ---------------------选择线虫区域，并去除图中杂点-------------------
[height,width] = size(binary_image_whole);
cc = bwconncomp(binary_image_whole);
worm_index = 1;
if cc.NumObjects > 1
    area_diff = zeros(cc.NumObjects, 1);
    for num = 1:cc.NumObjects
        area_diff(num) = abs(length(cc.PixelIdxList{num}) - worm_area);
    end
    worm_index = find(area_diff == min(area_diff), 1);
    for num = 1:cc.NumObjects
        if num ~= worm_index
             binary_image_whole(cc.PixelIdxList{num}) = 0;
        end
    end
end

% ---------------------截取线虫附近区域的二值图像-----------------------
% 从线虫所在区域点的一维坐标得到每个点的行列坐标
worm = cc.PixelIdxList{worm_index};
worm_row = mod(worm, height);
worm_column = ceil(worm / height);

% 计算线虫所在区域的首末行以及首末列
row_min = max(min(worm_row) - 4, 1);
row_max = min(max(worm_row) + 4, height);
column_min = max(min(worm_column) - 4, 1);
column_max = min(max(worm_column) + 4, height);

% 截取线虫所在区域，并保存其坐标范围
binary_image = binary_image_whole(row_min:row_max,column_min:column_max);
worm_xy_range = [row_min, row_max, column_min, column_max];
% binary_image = binary_image_whole;
% worm_xy_range= [1,height,1,width];

% ----------------------填充线虫区域内部的空白杂点-----------------------
% binary_image = ~bwareaopen(~binary_image, CONST_VALUE.AREA_THRESHOLD_2);
binary_image = ~bwareaopen(~binary_image, floor(hole_area));
worm_area = length(find(binary_image == 1));
end