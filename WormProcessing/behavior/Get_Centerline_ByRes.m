clear all;

ResFolder = 'H:\BehaviorImages\ROI Tracking\Res\head_5ms_wash_Res19\';
img_seq = GetImageSeq(ResFolder,'.res');
img_time = img_seq.image_time;
prefix = img_seq.image_name_prefix;

centerlines = zeros(length(img_time),101,2);
image_index = zeros(length(img_time),1);
index = 0;
for i=1:length(img_time)
    res_name = [ResFolder prefix num2str(img_time(i)) '.res'];
%     disp(res_name);
    res = LoadStaringImagingRes(res_name);
    if res.length_error == 0
        index = index+1;
        centerlines(index,:,:) = res.centerline;
        image_index(index) = i;
%     else
%         disp(['Length error: ' num2str(i)]);
%         centerlines(i,:,:) = centerlines(i-1,:,:);
    end
end

centerlines = centerlines(1:index,:,:);
image_index = image_index(1:index);