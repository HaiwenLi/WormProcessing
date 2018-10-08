function res = Read_ResFile(name)

% disp(name);
fid = fopen(name,'rb');
res = struct('imageOffset',[nan,nan],'stageOffset',[nan,nan],...
    'stageStatus','','centerline',zeros(101,2),'roiPosition',0);

fread(fid,1,'bool');
res.imageOffset = fread(fid,2,'double');
res.stageStatus = fread(fid, 256, 'char');
centerline = fread(fid,101*2,'double');
res.centerline(:,1) = centerline(1:2:end);
res.centerline(:,2) = centerline(2:2:end);
res.roiPosition = fread(fid,1,'double');
fclose(fid);
end