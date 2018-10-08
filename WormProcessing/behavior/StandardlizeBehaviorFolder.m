function StandardlizeBehaviorFolder(Folder, index)

Image_Folder = '';
Res_Folder = '';

if exist([Folder 'behavior-tiff' num2str(index)], 'dir')
	Image_Folder = [Folder 'behavior-tiff' num2str(index) '\'];
elseif exist([Folder 'behavior-Tiff' num2str(index)], 'dir')
	Image_Folder = [Folder 'behavior-Tiff' num2str(index) '\'];
elseif exist[Folder 'Behavior-tiff' num2str(index)], 'dir')
	Image_Folder = [Folder 'Behavior-tiff' num2str(index) '\'];
elseif exist[Folder 'Behavior-Tiff' num2str(index)], 'dir')
	Image_Folder = [Folder 'Behavior-Tiff' num2str(index) '\'];
else
	disp('No behavior image folder');
	return;
end

if exist([Folder 'Res-' num2str(index)], 'dir')
	Res_Folder = [Folder 'Res-' num2str(index) '\'];
elseif exist([Folder 'res-' num2str(index)], 'dir')
	Res_Folder = [Folder 'res-' num2str(index) '\'];
else
	disp('No res folder');
end

if ~exist([Folder 'B' num2str(index)], 'dir')
	mkdir([Folder 'B' num2str(index)]);
	Folder = [Folder 'B' num2str(index) '\'];

	% make Image and Res folder
	if ~isempty(Image_Folder)
		mkdir([Folder 'Image']);
		MoveDirectory(Image_Folder, [Folder 'Image\']);
	end
	if ~isempty(Res_Folder)
		mkdir([Folder 'Res']);
		MoveDirectory(Res_Folder, [Folder 'Res\']);
	end
end
end