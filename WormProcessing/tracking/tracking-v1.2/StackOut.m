function stack = StackOut(stack)
% remove the top node in the stack

global used_flag;
if stack.layer_num > 0 % stack is not empty
    top = stack.nodes(end);
    used_flag(top.extracted_index) = 0;
    stack.layer_num = stack.layer_num - 1;
    stack.nodes = stack.nodes(1:end-1);
end
end