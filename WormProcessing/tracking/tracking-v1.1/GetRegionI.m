function [neuron_I,I_ratio] = GetRegionI(img,neuron_pos,neuron_radius,intensity_ratio)
% Neuorn Pos: [x,y]

neuron_pos = int32(neuron_pos);
[height,width] = size(img);

I = zeros(1,ceil(neuron_radius^2));
count = 0;
for x = (neuron_pos(1)-neuron_radius):(neuron_pos(1)+neuron_radius)
    for y = (neuron_pos(2)-neuron_radius):(neuron_pos(2)+neuron_radius)
            % check x
            if (x <= 0)
                nx = 1;
            elseif (x > width) 
                nx = width;
            else
                nx = x;
            end
            
            % check y
            if (y <= 0)
               ny = 1;
            elseif (y > height)
               ny = height;
            else
               ny = y;
            end
            count = count+1;
            I(count) = img(ny,nx);
    end
end
I = I(1:count);

sort_I = sort(I,'descend');
p = int32(count*intensity_ratio);
neuron_I = mean(sort_I(1:p));% intensity threshold for extracting anchor neuron
non_neuron_I = mean(sort_I(end-p+1:end));
I_ratio = neuron_I/non_neuron_I;

end