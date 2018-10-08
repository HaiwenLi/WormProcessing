function ReadRes(Folder,OutFolder)
% Read res files in Folder and convert to mat files

res_seq = GetImageSeq(Folder, '.res');
res_prefix = res_seq.image_name_prefix;
res_time = res_seq.image_time;

for i=1:length(res_time)
    res_filename = [Folder res_prefix num2str(res_time(i)) '.res'];
    res = Read_ResFile(res_filename);
    save([OutFolder res_prefix num2str(res_time(i)) '.mat'], 'res');
end

end