function [binary_image, worm_xy_range, worm_area] =...
    Denoise_And_Worm_Locate(binary_image_whole, worm_area)

% ����λ����Ϣ�ж�

hole_portition = 0.015;
hole_area = worm_area*hole_portition;

% ---------------------ѡ���߳����򣬲�ȥ��ͼ���ӵ�-------------------
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

% ---------------------��ȡ�߳渽������Ķ�ֵͼ��-----------------------
% ���߳�����������һά����õ�ÿ�������������
worm = cc.PixelIdxList{worm_index};
worm_row = mod(worm, height);
worm_column = ceil(worm / height);

% �����߳������������ĩ���Լ���ĩ��
row_min = max(min(worm_row) - 4, 1);
row_max = min(max(worm_row) + 4, height);
column_min = max(min(worm_column) - 4, 1);
column_max = min(max(worm_column) + 4, height);

% ��ȡ�߳��������򣬲����������귶Χ
binary_image = binary_image_whole(row_min:row_max,column_min:column_max);
worm_xy_range = [row_min, row_max, column_min, column_max];
% binary_image = binary_image_whole;
% worm_xy_range= [1,height,1,width];

% ----------------------����߳������ڲ��Ŀհ��ӵ�-----------------------
% binary_image = ~bwareaopen(~binary_image, CONST_VALUE.AREA_THRESHOLD_2);
binary_image = ~bwareaopen(~binary_image, floor(hole_area));
worm_area = length(find(binary_image == 1));
end