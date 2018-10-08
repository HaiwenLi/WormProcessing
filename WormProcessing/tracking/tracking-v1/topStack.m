function [top] = topStack(stack,layer_num)
    top = stack(layer_num+1).node;
end
