function ConvertBackboneToMat(Folder)
% Read backbone data and convert to centerline

image_names = dir([Folder, 'backbone\*.bin']);
Start_Index = 1;
End_Index = length(image_names);

for i=Start_Index:End_Index
	backbone_name = [Folder 'backbone\backbone_' num2str(i) '.bin'];
	backbone = LoadCenterlineResults(backbone_name);

	if ~backbone.length_error
		centerline = backbone.current_backbone;
    else
        centerline = backbone.last_backbone;
		disp(['Error backbone ' num2str(i)]);
    end
    centerline_name = [Folder 'centerline\' num2str(i) '.mat'];
    res.centerline = centerline;
    res.error = length_error;
    save(centerline_name, 'res');
end

end