function RenameImage_WithNumber(Folder,OutFolder)

seq = GetImageSeq(Folder, '.tiff');
prefix = seq.image_name_prefix;
time = seq.image_time;

for i=1:length(time)
    filename = [Folder prefix num2str(time(i)) '.tiff'];
    copyfile(filename,[OutFolder num2str(i) '.tiff']);
end

end