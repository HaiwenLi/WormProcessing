function [end_nodes,end_nodes_index] = FindEndNodes(graph, node_in_subgraph,...
    CONST_VALUE)
% Find end nodes in the graph

end_nodes = zeros(CONST_VALUE.MAX_END_NODE_NUM, CONST_VALUE.DEGREE_MAX);
end_nodes_index = zeros(CONST_VALUE.MAX_END_NODE_NUM,1);
end_node_num = 0;
for num = 1:length(graph)
    end_node = num;
    if graph{num}.degree == 1 && end_node_num == 0
        end_node_num = end_node_num+1;
        end_nodes_index(end_node_num) = end_nodes_index(end_node_num)+1;
        end_nodes(end_node_num,end_nodes_index(end_node_num)) = end_node;
    elseif graph{num}.degree == 1
        has_processed = false;
        for s=1:end_node_num
            for k=1:end_nodes_index(s)
                node = end_nodes(s,k);
                if node_in_subgraph(end_node) == node_in_subgraph(node)
                    end_nodes_index(end_node_num) = end_nodes_index(end_node_num)+1;
                    end_nodes(end_node_num,end_nodes_index(end_node_num)) = end_node;
                    has_processed = true;
                    break;
                end
            end
        end
        if ~has_processed
            end_node_num = end_node_num+1;
            end_nodes_index(end_node_num) = end_nodes_index(end_node_num)+1;
            end_nodes(end_node_num,end_nodes_index(end_node_num)) = end_node;
        end
    end  
end
end_nodes = end_nodes(1:end_node_num,:);
end_nodes_index = end_nodes_index(1:end_node_num);
end