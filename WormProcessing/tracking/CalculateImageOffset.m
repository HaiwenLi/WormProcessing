function offset = CalculateImageOffset(green_img, red_img, motion_dir)
% Use correlation to calculate image offset
% Hint: red_img is the reference image

Green_Background = 300; % green image
Red_Background = 200; % red image
fsize = [5,5];
margin = 5;

green_img = double(medfilt2(green_img,fsize));
red_img = double(medfilt2(red_img,fsize));

% remove backgroud and crop region
green_img = green_img .* (green_img > Green_Background);
red_img = red_img .* (red_img > Red_Background);
green_region = CalculateCropRegion(green_img, Green_Background);
red_region = CalculateCropRegion(red_img, Red_Background);
crop_region = [min([green_region(1) red_region(1)]) max([green_region(2) red_region(2)])...
               min([green_region(3) red_region(3)]) max([green_region(4) red_region(4)])];

crop_green_img = green_img(crop_region(1):crop_region(2), crop_region(3):crop_region(4));
crop_red_img = red_img(crop_region(1):crop_region(2), crop_region(3):crop_region(4));

% calculate correlation
X_Search_Interval = ceil(abs(motion_dir(1))) + margin;
Y_Search_Interval = ceil(abs(motion_dir(2))) + margin;
corr_matrix = zeros(2*X_Search_Interval+1, 2*Y_Search_Interval+1);

pad_img = padarray(crop_green_img, [Y_Search_Interval, X_Search_Interval]);
[height, width] = size(crop_red_img);
for col = 1:2*X_Search_Interval+1
	for row = 1:2*Y_Search_Interval+1
		img = pad_img(row:row+height-1, col:col+width-1);
		corr_matrix(row, col) = corr2(img, crop_red_img);
	end
end

max_corr = max(corr_matrix(:));
[max_y, max_x] = find(corr_matrix == max_corr, 1);
offset = [max_x-X_Search_Interval-1, max_y-Y_Search_Interval-1];

end