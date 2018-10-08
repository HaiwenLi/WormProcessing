function out = DrawNeuronsInRGBImage(rgb_image,centers,neuron_radius,color)
% Draw neurons in the image

Neuron_Num = size(centers,1);
if strcmp(color,'white') == 1
    rgb_color = [255, 255, 255];
elseif strcmp(color,'red') == 1
    rgb_color = [255, 0, 0];
elseif strcmp(color,'green') == 1
    rgb_color = [0, 255, 0];
elseif strcmp(color,'blue') == 1
     rgb_color = [0, 0, 255];
else
    dsip('Wrong color specification. Only be white, red, gree, and blue');
    return;
end

out = rgb_image;
height = size(rgb_image,1);
width = size(rgb_image,2);

% For label width 1
for k=1:Neuron_Num
    for theta = 0:pi/30:2*pi
        x=int32(centers(k,1) + (neuron_radius+1)*cos(theta));
        y=int32(centers(k,2) + (neuron_radius+1)*sin(theta));
        x = max(1,min(x,width));
        y = max(1,min(y,height));
        out(y,x,1) = rgb_color(1);
        out(y,x,2) = rgb_color(2);
        out(y,x,3) = rgb_color(3);
    end
end

% For label width 2
for k=1:Neuron_Num
    for theta = 0:pi/50:2*pi
        x=int32(centers(k,1) + (neuron_radius+2)*cos(theta));
        y=int32(centers(k,2) + (neuron_radius+2)*sin(theta));
        x = max(1,min(x,width));
        y = max(1,min(y,height));
        out(y,x,1) = rgb_color(1);
        out(y,x,2) = rgb_color(2);
        out(y,x,3) = rgb_color(3);
    end
end
end