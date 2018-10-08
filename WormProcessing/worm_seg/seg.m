function seg(Image_Folder,OutputFolder)
% segment worm region

Worm_Area = 2800;
Frame_Skip_Thres = 0.3*Worm_Area;

if ~exist(OutputFolder,'dir')
	mkdir(OutputFolder);
end
OutputFolder = [OutputFolder '\'];
width = 512;
height = 512;

image_format = '.tiff';
image_names = dir([Image_Folder, '*' image_format]);
Start_Index = 1;
End_Index = length(image_names);
Skip_List= zeros(length(image_names),1);
Skip_List_Index = 0;
Init_Worm_Area = Worm_Area;
worm_regions = zeros(length(image_names),4);

for i=Start_Index:End_Index
%     disp(['Processing image ' num2str(i)]);
    disp(['Processing image ' num2str(i) ': ' image_names(i).name]);
	img = imread([Image_Folder image_names(i).name]);

	if i == Start_Index
		[image_height, image_width] = size(img);
		if image_height < height || image_width < width
			disp('Desired height/width is invalid');
			return;
		end
		backgrdound = zeros(height, width);
	end

	% 使用不同的分割作比较
	[binary_worm_region,~,worm_region] = WormSeg_OutEdge(img, Worm_Area);
	% disp(['Area: ' num2str(Worm_Area)]);
	%[binary_worm_region,Worm_Area, worm_region] = WormSeg_OutEdge(uint8(abs(double(img) - backgrdound)), Worm_Area);
	% backgrdound = double(img) - double(binary_worm_region).*double(img);

    if abs(Init_Worm_Area - Worm_Area) > Frame_Skip_Thres
        Skip_List_Index = Skip_List_Index + 1;
        Skip_List(Skip_List_Index) = i;
        Worm_Area = Init_Worm_Area;
    end
    worm_regions(i,:) = worm_region;
    
    % save the binary worm region
	imwrite(binary_worm_region*255, [OutputFolder num2str(i) image_format]);
end

Skip_List = Skip_List(1:Skip_List_Index);

% save worm regions and positions
save([OutputFolder 'binarization_output.mat'],'Skip_List','worm_regions','image_names','Image_Folder');

end