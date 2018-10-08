function [sign,stack,layer_num]= StackOut(stack,layer_num,sign) 
    top = topStack(stack,layer_num);
    sign(top.extracted_index) = 0;
    layer_num = layer_num - 1;
    stack = stack(1:layer_num+1);
end