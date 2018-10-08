function MoveDirectory(Src, Target)
% Move source directory to target directory
% This function cannot support moving subfolders in folder

if ~exist(Src,'dir')
	disp('Source folder doesn\'t exist');
	return;
end
if ~exist(Target, 'dir')
	disp('Target folder doesn\'t exist');
	return;
end

filenames = dir([Src '*.*']);
for i=1:length(filenames)
	movefile([Src filenames(i).name], [Target filenames(i).name]);
end

end