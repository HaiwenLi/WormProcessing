function [graph_before_prune, graph_after_prune] = Skeletonize_And_Graph_Prune(Cline_point, CONST_VALUE)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Connect_Node(node_1,node_2)
        graph{node_1}.degree = graph{node_1}.degree + 1;
        graph{node_2}.degree = graph{node_2}.degree + 1;
        graph{node_1}.adjacent(graph{node_1}.degree) = node_2;
        graph{node_2}.adjacent(graph{node_2}.degree) = node_1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Add_Node(zi_node, point_in_node, fu_node)
        node_include_point(point_in_node) = zi_node;
        current_item = Cline_point(point_in_node,:);
        graph{zi_node}.center = sum(current_item, 1) / length(point_in_node);
        node_in_subgraph(zi_node) = subgraph_num;
        subgraph_node_count(subgraph_num) = subgraph_node_count(subgraph_num) + 1;
        if fu_node > 0
            graph{zi_node}.degree = graph{zi_node}.degree + 1;
            graph{fu_node}.degree = graph{fu_node}.degree + 1;
            graph{zi_node}.adjacent(graph{zi_node}.degree) = fu_node;
            graph{fu_node}.adjacent(graph{fu_node}.degree) = zi_node;
        end
        node_num = node_num + 1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function point_find = Search_Furthur_Point(base_node, ignore_point)
        point_find = [];
        if graph{base_node}.degree ~= 1
            return;
        end
        last_node = graph{base_node}.adjacent(1);
        % 计算邻居结点到该结点的方向角
        base = graph{base_node}.center;
        last = graph{last_node}.center;
        direction = atan2(base(1)-last(1), base(2)-last(2));
        % 评价所有符合要求的点的合适程度
        metrics = zeros(POINT_NUM, 1) * nan;
        for i = 1:POINT_NUM
            if ignore_point(i) == 0 && node_include_point(i) ~= base_node
                angle_diff = atan2(Cline_point(i,1)-base(1), Cline_point(i,2)-base(2)) - direction;
                angle_diff = min(mod(angle_diff, 2*pi), mod(-angle_diff, 2*pi));
                if angle_diff <= CONST_VALUE.ANGLE_THRESHOLD_NAN
                    % 注意！！！！！！！！此处不可用norm，否则会严重影响速度！
                    dist = (Cline_point(i,1) - base(1))^2 + (Cline_point(i,2) - base(2))^2;
                    metrics(i) = sqrt(dist)*(1 + CONST_VALUE.ALPHA * tan(angle_diff));
                end
            end
        end
        if min(metrics) <= CONST_VALUE.METRICS_MAX % 此处已一并处理全为NaN时的情况
            point_find = find(metrics == min(metrics), 1);
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

POINT_NUM = size(Cline_point, 1);
node_in_subgraph = zeros(POINT_NUM, 1);
subgraph_node_count = zeros(POINT_NUM, 1);
subgraph_num = 1;
graph = cell(POINT_NUM, 1);
for num = 1:POINT_NUM
    graph{num} = struct('degree', 0, 'adjacent', zeros(CONST_VALUE.DEGREE_MAX,1), 'center', [0,0]);
end
node_num = 0;
node_include_point = zeros(POINT_NUM, 1);
bifurcate_stack = cell(CONST_VALUE.STORAGE_MAX , 1);
stack_top = 1;
%-------------------------------对中心线候选点骨架化------------------------
Add_Node(1,1,0);
current_item = Cline_point(1,:);
while true
    point_index = Catch_Nearby_Point(current_item, Cline_point, node_include_point, CONST_VALUE.NEARBY_DIST);
    if isempty(point_index)
        point_index = Search_Furthur_Point(node_num, node_include_point);
    end
    if ~isempty(point_index)
        branch_index = Branch_Determine(Cline_point(point_index, :), CONST_VALUE.NEARBY_DIST);
        branch_num = max(branch_index);
        if branch_num > 1
            for branch_select = 2:branch_num
                in_stack_branch = point_index(branch_index == branch_select);
                bifurcate_stack{stack_top} = struct('parent', node_num, 'index', in_stack_branch);
                stack_top = stack_top + 1;
            end
            point_index = point_index(branch_index == 1);
        end
        Add_Node(node_num+1, point_index, node_num);
        continue
    end
    node_found_in_stack = 0;
    while stack_top > 1
        stack_top = stack_top - 1;
        parent = bifurcate_stack{stack_top}.parent;
        point_index = bifurcate_stack{stack_top}.index;
        if max(node_include_point(point_index)) == 0 % 若栈中点未被使用过，则选择它为下一结点
            Add_Node(node_num+1, point_index, parent);
            node_found_in_stack = 1;
            break;
        elseif min(node_include_point(point_index)) > 0 % 若栈中点已经被使用过，则选择一结点与母节点相连
            Connect_Node(min(node_include_point(point_index)), parent);
        else
            error('bifurcate stack error!');
        end
    end
    if node_found_in_stack == 0
        if isempty(find(node_include_point == 0, 1))
            break;
        end
        subgraph_num = subgraph_num + 1;
        point_index = find(node_include_point == 0, 1);
        Add_Node(node_num+1, point_index, 0);
    end
end

% 尝试将所有端点结点联结到其它结点上
for num = 1:node_num
    end_node = num;
    while graph{end_node}.degree == 1 % 不断延长直到不是端点为止
        point_index = Search_Furthur_Point(end_node, zeros(1,POINT_NUM));
        if ~isempty(point_index)
            contact_node = node_include_point(point_index);
            Connect_Node(contact_node, end_node);
            subgraph_1 = node_in_subgraph(contact_node);
            subgraph_2 = node_in_subgraph(end_node);
            if subgraph_1 ~= subgraph_2
                node_in_subgraph(node_in_subgraph == subgraph_2) = subgraph_1;
                subgraph_node_count(subgraph_1) = subgraph_node_count(subgraph_1) + subgraph_node_count(subgraph_2);
                subgraph_node_count(subgraph_2) = 0;
            end
            end_node = contact_node;
            continue
        end
        break;
    end
end

% 连接未连接的端点
[end_nodes,end_nodes_index] = FindEndNodes(graph,node_in_subgraph,CONST_VALUE);
line_num = length(end_nodes_index);
max_line_num = 1;
while line_num > max_line_num
    % 每次只连接两条路径
    end_node1 = end_nodes(1,1:end_nodes_index(1));
    end_node2 = end_nodes(2,1:end_nodes_index(2));
    node_dist = zeros(end_nodes_index(1),end_nodes_index(2));
    for s=1:end_nodes_index(1)
        for t=1:end_nodes_index(2)
            node_dist(s,t) = sum((graph{end_node1(s)}.center - graph{end_node2(t)}.center).^2);
        end
    end
    min_dist = min(node_dist(:));
    % 连接端点
    [min_s,min_t] = find(node_dist == min_dist);
    node1 = end_node1(min_s(1));
    node2 = end_node2(min_t(1));
    Connect_Node(node1, node2);
    subgraph_1 = node_in_subgraph(node1);
    subgraph_2 = node_in_subgraph(node2);
    if subgraph_1 ~= subgraph_2
        node_in_subgraph(node_in_subgraph == subgraph_2) = subgraph_1;
        subgraph_node_count(subgraph_1) = subgraph_node_count(subgraph_1) + subgraph_node_count(subgraph_2);
        subgraph_node_count(subgraph_2) = 0;
    end
    % 重新计算图中的线段
    [end_nodes,end_nodes_index] = FindEndNodes(graph,node_in_subgraph,CONST_VALUE);
    line_num = length(end_nodes_index);
end

graph = graph(1:node_num);
graph_before_prune = graph;
%  选择最大的连通分支
node_in_subgraph = node_in_subgraph(1:node_num);
node_saved = zeros(node_num, 1);
[temp, largest_subgraph] = max(subgraph_node_count);
node_saved(node_in_subgraph ~= largest_subgraph) = -1;
node_saved(node_in_subgraph == largest_subgraph) = 0;
% 删去长度为1的分叉
for num = 1:node_num
    adjacent = graph{num}.adjacent(1);
    if node_saved(num) == 0 && graph{num}.degree == 1 && graph{adjacent}.degree ~= 2
        node_saved(num) = -1;
        graph{num}.degree = 0;
        adjacent_degree = graph{adjacent}.degree;
        for i = 1:adjacent_degree - 1
            if graph{adjacent}.adjacent(i) == num
                graph{adjacent}.adjacent(i) = graph{adjacent}.adjacent(adjacent_degree);
            end
        end
        graph{adjacent}.degree = adjacent_degree - 1;
    end
end
graph_after_prune = Inner_Point_Delete(graph, node_saved, CONST_VALUE);
end