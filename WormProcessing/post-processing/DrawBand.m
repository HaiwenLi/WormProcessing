function DrawBand(x,top_y,bottom_y,color,alpha_ratio)
% Draw band with color
% Input:
% x,top_y,bottom_y: array (1XN or Nx1)
% background_color
% alpha_ratio: degree of transparant

clc;
close all;
figure;
fill([x,fliplr(x)],[top_y,fliplr(bottom_y)],color,...
    'EdgeColor','none','AmbientStrength',0.3,'FaceLighting','gouraud');
alpha(alpha_ratio);

end