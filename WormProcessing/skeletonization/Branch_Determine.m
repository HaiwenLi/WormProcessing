function branch_index = Branch_Determine(point, NEARBY_DIST)
POINT_NUM = size(point, 1);
% 若只有两个点且之间距离大于阈值，则各为一分支；否则当少于两个点时为单连通分支
if POINT_NUM == 1
    branch_index = 1;
elseif POINT_NUM == 2
    if (point(1,1)-point(2,1))^2 + (point(1,2)-point(2,2))^2 > NEARBY_DIST
        branch_index = [1,2];
    else
        branch_index = [1,1];
    end
else    
    branch_index = zeros(1, POINT_NUM);
    index_stack = zeros(1, 0);
    current_point = 1;
    branch_index(1) = 1;
    branch_num = 1;
    while min(branch_index) == 0
        % 找出相邻点，并做标号
        is_nearby = zeros(1, POINT_NUM);
        for i = 1:POINT_NUM
            is_nearby(i) = branch_index(i) == 0 &&...
                (point(i,1) - point(current_point,1))^2 + (point(i,2) - point(current_point,2))^2  <= NEARBY_DIST;
        end
        nearby_index = find(is_nearby == 1);
        branch_index(nearby_index) = branch_num;
        % 若有相邻点，则选择其中一点，将其余点入栈
        if ~isempty(nearby_index)
            current_point = nearby_index(1);
            index_stack = [index_stack,nearby_index(2:end)];
            continue
        end
        % 若无相邻点，则取出栈顶点
        if ~isempty(index_stack)
            current_point = index_stack(end);
            index_stack(end) = [];
            continue
        end
        % 否则选择一个新的点开始遍历新连通分支
        branch_num = branch_num + 1;
        current_point = find(branch_index==0, 1);
        branch_index(current_point) = branch_num;
    end
end
end