function res = LoadStaringImagingRes(filename)

fid = fopen(filename,'rb');
res = struct('length_error',false,'circle',zeros(1,3),'roi_region',[0,0],'margin',0,...
    'rect_region',zeros(1,4),'centerline',zeros(101,2),'focus_regin',0);

res.length_error = fread(fid,1,'bool');
res.circle = fread(fid,3,'double');
res.rect_region = fread(fid,4,'double');
res.margin = fread(fid,1,'double');
res.roi_region = fread(fid,2,'double');

backbone = fread(fid,101*2,'double');
if ~isempty(backbone)
    res.centerline(:,1) = backbone(1:2:end);
    res.centerline(:,2) = backbone(2:2:end);
end

res.focus_region = fread(fid,1,'double');
fclose(fid);
end