function stack = StackIn(stack,node)
% Add node into stack

global used_flag;
stack.nodes((stack.layer_num+1)) = node;
used_flag(node.extracted_index) = 1;
stack.layer_num = stack.layer_num+1;
end