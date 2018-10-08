function new_graph = Inner_Point_Delete(graph, node_saved, CONST_VALUE)

POINT_NUM = length(graph);
new_graph = cell(POINT_NUM, 1);
adjacent_angle = zeros(CONST_VALUE.DEGREE_MAX, 1);
bifurcate_stack = zeros(CONST_VALUE.STORAGE_MAX, 2);
stack_top = 1;
for num = 1:POINT_NUM
    new_graph{num} = struct('degree', 0, 'adjacent', zeros(CONST_VALUE.DEGREE_MAX,1), 'center', [0,0]);
end
% 选择位置最上方的一个点，因它必然不是图的内点，计算初始角度与初始元素
minimum = [Inf, 0];
for num = 1:POINT_NUM
    if graph{num}.center(1) < minimum(1) && node_saved(num) == 0
        minimum = [graph{num}.center(1), num];
    end
end
start_node = minimum(2);
% 选择顺时针方向的下一个外部结点start_next
p_from = graph{start_node}.center;
degree = graph{start_node}.degree;
adjacent = graph{start_node}.adjacent;
for i = 1:degree
    p_to = graph{adjacent(i)}.center;
    adjacent_angle(i) = atan2(p_to(1) - p_from(1), p_to(2) - p_from(2));
end
[temp, next_index] = min(adjacent_angle(1:degree));
next_node = adjacent(next_index);
% 初始化，从start_next结点开始运算
if graph{start_node}.degree == 2
    stack_top = 2;
    bifurcate_stack(1,:) = [start_node, next_node];
end
node_saved(start_node) = 1;
node_saved(next_node) = 2;
new_graph{1} = graph{start_node};
new_graph{2} = graph{next_node};
new_graph{1}.degree = 1;
new_graph{2}.degree = 1;
new_graph{1}.adjacent(1) = 2; 
new_graph{2}.adjacent(1) = 1; 
last_node = start_node;
current_node = next_node;
node_num = 2;
while true
    adjacent = graph{current_node}.adjacent;
    degree = graph{current_node}.degree;
    switch graph{current_node}.degree
        case 0
            error('Error Degree');
        case 1
            stack_top = stack_top - 1;
            if stack_top < 1            
                new_graph = new_graph(1:node_num);
                return;
            end
            current_node = bifurcate_stack(stack_top, 1);
            last_node = bifurcate_stack(stack_top, 2);
            continue;
        case 2
            next_node = adjacent(1);
            if next_node == last_node
                next_node = adjacent(2);
            end
        otherwise
            p_from = graph{current_node}.center;
            for i = 1:degree
                p_to = graph{adjacent(i)}.center;
                adjacent_angle(i) = atan2(p_to(1) - p_from(1), p_to(2) - p_from(2));
                if adjacent(i) == last_node
                    current_angle = adjacent_angle(i);
                end
            end
            angle_diff = adjacent_angle(1:degree) - current_angle - CONST_VALUE.ANGLE_ERROR;
            angle_diff = angle_diff - 2*pi*floor(angle_diff /(2*pi));
            [temp, next_index] = min(angle_diff);
            next_node = adjacent(next_index);
            bifurcate_stack(stack_top, :) = [current_node, next_node];
            stack_top = stack_top + 1;
    end
    new_index_1 = node_saved(current_node);
    new_index_2 = node_saved(next_node);
    % 若下一点已经使用过，则回溯到它之前的分叉点
    if new_index_2 == 0
        node_num = node_num + 1;
        new_graph{node_num}.center = graph{next_node}.center;
        new_graph{node_num}.degree = 1;
        new_graph{node_num}.adjacent(1) = new_index_1;
        new_graph{new_index_1}.degree = new_graph{new_index_1}.degree + 1;
        new_graph{new_index_1}.adjacent(new_graph{new_index_1}.degree) = node_num;
        node_saved(next_node) = node_num;
        last_node = current_node;
        current_node = next_node;
    else
        if isempty(find(new_graph{new_index_1}.adjacent(1:new_graph{new_index_1}.degree) == new_index_2, 1))
            new_graph{new_index_1}.degree = new_graph{new_index_1}.degree + 1;
            new_graph{new_index_1}.adjacent(new_graph{new_index_1}.degree) = new_index_2;
            new_graph{new_index_2}.degree = new_graph{new_index_2}.degree + 1;
            new_graph{new_index_2}.adjacent(new_graph{new_index_2}.degree) = new_index_1;
        end
        while true
            stack_top = stack_top - 1;
            if stack_top < 1
                new_graph = new_graph(1:node_num);
                return;
            end
            if new_index_2 > node_saved(bifurcate_stack(stack_top, 1))
                current_node = bifurcate_stack(stack_top, 1);
                last_node = bifurcate_stack(stack_top, 2);
                break;
            end
        end
    end
end
end
