function [stack,layer_num]= StackIn(stack,nodes,layer_num)

stack(layer_num+2).node = nodes;
nodes.layer_index = layer_num+1;
layer_num = layer_num + 1;

end