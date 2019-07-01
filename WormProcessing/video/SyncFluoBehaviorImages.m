function sync_struc = SyncFluoBehaviorImages(Fluo_Seq,Fluo_CaliTime,Beha_Seq,Beha_CaliTime)
% 同步荧光图像和行为图像。使用时间配准后，确定每帧荧光图像所对应的行为图像
% 参数说明：Fluo_Seq为荧光图像序列文件名结构体，Fluo_CaliTime为荧光图像时间标定序列文件名结构体
%          Beha_Seq和Beha_CaliTime同上
% 注：所有文件名中的时间按时间升序排列

close all;

fluo_prefix = Fluo_Seq.image_name_prefix;
behavior_prefix = Beha_Seq.image_name_prefix;
Num = length(Fluo_Seq.image_time);
sync_names = cell(Num,2);% 第一列对应荧光图像，第二列为对应的行为图像

% 首先观测荧光和行为连续帧的时间差，确定时间阈值
% figure;plot(diff(Fluo_Seq.image_time),'b-.');title('Fluorescent image time');ylabel('ms');
% figure;plot(diff(Fluo_CaliTime.image_time),'b-.');title('Fluorescent time calibration');ylabel('ms');
% figure;plot(diff(Beha_Seq.image_time),'b-.');title('Behavioral image time');ylabel('ms');
% figure;plot(diff(Beha_CaliTime.image_time),'b-.');title('Behavioral time calibration');ylabel('ms');

Time_Thres = 10;
Fluo_Interval = mean(diff(Fluo_Seq.image_time));    %连续两帧荧光图像平均时间间隔
Behavior_Interval = mean(diff(Beha_Seq.image_time));%连续两帧行为图像平均时间间隔
Fluo_CaliTime = Fluo_CaliTime.image_time(1);        %荧光图像校正时间
Beha_CaliTime = Beha_CaliTime.image_time(1);%行为图像校正时间
behavior_time_calibrated = Beha_Seq.image_time - Beha_CaliTime;%时间矫正后的行为图像序列拍摄时间

sync_index = nan(Num,1);

for i=1:Num
    fluo_time = Fluo_Seq.image_time(i);
    sync_names{i,1} = [fluo_prefix num2str(fluo_time) '.tiff'];
    % 匹配荧光图像和行为图像
    
    fluo_time_calibrated = fluo_time - Fluo_CaliTime;
    behavior_match = behavior_time_calibrated - fluo_time_calibrated;
    match_flag = abs(behavior_match) < (2*Fluo_Interval + Time_Thres);
    if isempty(match_flag) || sum(match_flag) == 0
        if i==1
            sync_names{i,2} = [];
        else
            sync_names{i,2} = sync_names{i-1,2};
            sync_index(i) = sync_index(i-1);
        end
    else
        match_index = find(match_flag == 1,1); %向前匹配
        behavior_time = Beha_Seq.image_time(match_index);
        sync_names{i,2} = [behavior_prefix num2str(behavior_time) '.tiff'];
        sync_index(i) = match_index;
    end 
end

sync_struc.sync_name = sync_names;
sync_struc.beha_index = sync_index;
% sync_struc.fluo_time = Fluo_Seq.image_time - Fluo_CaliTime;
% sync_struc.beha_time = behavior_time_calibrated(sync_index) - sync_struc.fluo_time(1);
% sync_struc.fluo_time = sync_struc.fluo_time - sync_struc.fluo_time(1);
% 
% % make the time be positive
% if (sync_struc.beha_time(1) < 0)
%      sync_struc.fluo_time = sync_struc.fluo_time - sync_struc.beha_time(1);
%      sync_struc.beha_time = sync_struc.beha_time - sync_struc.beha_time(1);
% end

end