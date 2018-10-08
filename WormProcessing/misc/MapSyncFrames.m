Out = 'C:\Users\LouisTao_Lab\Desktop\Final_Images\';
Src = 'F:\Output\images\';

green_range = [250, 1500];
red_range = [150, 1800];

for i=1789:1798
	F = [Src 'Frame-' num2str(i) '\'];
	O = [Out 'Frame-' num2str(i)];
    if ~exist(O, 'dir')
        mkdir(O);
    end
	O = [O '\'];
    
    beha = imread([F 'behavior.tiff']);
    imwrite(beha, [O 'behavior.tiff'], 'resolution', 300);
    
	green = imread([F 'green.tiff']);
	green_map = MapImageToRGB(green, green_range, 'green');
	imwrite(green_map, [O 'green.tiff'], 'resolution', 300);

	red = imread([F 'red.tiff']);
	red_map = MapImageToRGB(red, red_range, 'red');
	imwrite(red_map, [O 'red.tiff'], 'resolution', 300);
end