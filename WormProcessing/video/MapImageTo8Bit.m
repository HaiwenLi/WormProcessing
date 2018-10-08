function map_image = MapImageTo8Bit(image,map_range)
% Map image into 8-bit
% 
% Input parameters:
% image:     original image
% map_range: data range when making video. If the type of data is UINT8,
%            this value will be [0,255], and if the type of data is UINT16,
%            this value is needed to be set by image, such as [min_v, max_v]

min_value = map_range(1);
max_value = map_range(2);
map_image = double(image);
map_image(map_image>max_value) = max_value;
map_image(map_image<min_value) = min_value;
map_image = uint8((map_image-min_value)*255/(max_value-min_value));
end