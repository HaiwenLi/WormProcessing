function root_find = Root_Search(graph, CONST_VALUE)

POINT_NUM = size(graph, 1);
end_node = zeros(POINT_NUM, 1);
end_num = 0;
root_stack = zeros(POINT_NUM, CONST_VALUE.STORAGE_MAX);
stack_top = 1;
root_length_max = 0;
for num = 1:POINT_NUM
    if graph{num}.degree == 1
        end_num = end_num + 1;
        end_node(end_num) = num;
    end
end
if end_num == 0
    %error('Circle Error!');
    root_find = [];
    return;
end
for num = 1:end_num
    current_root = zeros(POINT_NUM, 1);
    node_in_root = zeros(POINT_NUM, 1);
    current_node = end_node(num);	% ��ʼ����ǰ�ڵ�
    % �洢��ʼ״̬��������·������
    current_root(1) = current_node;
    root_length = 1;
    node_in_root(current_node) = 1;
    while true
        % ���쵱ǰ��û��·�������ڵ㣬����һ������·����
        next_node = graph{current_node}.adjacent;
        next_node = next_node(1:graph{current_node}.degree);
        next_node = next_node(node_in_root(next_node) == 0);
        switch (length(next_node))
            case 1
                % ��ֻ��һ��·��ѡ�������
                root_length = root_length + 1;
                current_node = next_node;
                current_root(root_length) = current_node;
                node_in_root(current_node) = 1;
            case 0
                % ���Ѿ���·���ߣ���·����������ʱ��·���߹��ĵ�����ﵽ����������Ϊ·����Ч���洢·��
                if graph{current_node}.degree > 1
                    root_length = root_length - 2;
                end
                if root_length > root_length_max
                    root_length_max = root_length;
                    root_find = current_root(1:root_length);
                end
                if stack_top <= 1
                    break;
                else
                    stack_top = stack_top - 1;
                    current_root = root_stack(:, stack_top);
                    root_stack(:,stack_top) = zeros(POINT_NUM, 1);
                    % ��ʼ����ǰ״̬
                    root_length = sum(current_root > 0);
                    current_node = current_root(root_length);
                    node_in_root = zeros(POINT_NUM, 1);
                    node_in_root(current_root(1:root_length)) = 1;
                end
            otherwise
                % ����ǰ��·��������֧���Ƚ�����·��ѡ����ջ
                for i = 2:length(next_node)
                    root_stack(:, stack_top) = current_root;
                    root_stack(root_length + 1, stack_top) = next_node(i);
                    stack_top = stack_top + 1;
                end
                % Ȼ��ӵ�һ��·��������ǰ��
                root_length = root_length + 1;
                current_node = next_node(1);
                current_root(root_length) = current_node;
                node_in_root(current_node) = 1;
        end
    end
end
end

