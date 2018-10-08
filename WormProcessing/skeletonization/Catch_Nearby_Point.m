function point_find = Catch_Nearby_Point(base_points, candidate_point, ignore_point, NEARBY_DIST)

POINT_NUM = length(ignore_point);
ITEM_SIZE = size(base_points, 1);
is_nearby = zeros(POINT_NUM, 1);
% Ϊ�˼ӿ��ٶ�����ѡ��һ�����Σ��þ�����ĵ������л�׼��ľ���ض�������ֵ���ɴ�������ȥ�������
minimum = sqrt(NEARBY_DIST);
item_min_x = min(base_points(:,1)) - minimum;
item_min_y = min(base_points(:,2)) - minimum;
item_max_x = max(base_points(:,1)) + minimum;
item_max_y = max(base_points(:,2)) + minimum;
for i = 1:POINT_NUM  % ע�⣡�����������˴���ʹ��for i = find(ignore_point == 0) ��ʹ�ٶ����ر�������������
    if ignore_point(i) == 0 ...
            && candidate_point(i,1) >= item_min_x && candidate_point(i,1) <= item_max_x...
            && candidate_point(i,2) >= item_min_y && candidate_point(i,2) <= item_max_y
        for j = 1:ITEM_SIZE
            if (base_points(j,1) - candidate_point(i,1))^2 + (base_points(j,2) - candidate_point(i,2))^2 <= NEARBY_DIST
                is_nearby(i) = 1; % ע�⣡�����������˴���ʹ��sum�Ⱥ����򻯱��ʽ��ʹ���ٶ����ر�������������
                break;
            end
        end
    end
end
point_find = find(is_nearby == 1);
end