function map_img = GetMapImage(need_map, src_imagename, map_range, map_filename)
if need_map
	src_image = imread(src_imagename);
    map_img = MapImageTo8Bit(src_image, map_range);
    if ~isempty(map_filename)
        imwrite(map_img, map_filename);
    end
else
    map_img = imread(map_filename);
end
end