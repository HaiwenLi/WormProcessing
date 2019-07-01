function sync_struc = SyncFluoBehaviorImages(Fluo_Seq,Fluo_CaliTime,Beha_Seq,Beha_CaliTime)
% ͬ��ӫ��ͼ�����Ϊͼ��ʹ��ʱ����׼��ȷ��ÿ֡ӫ��ͼ������Ӧ����Ϊͼ��
% ����˵����Fluo_SeqΪӫ��ͼ�������ļ����ṹ�壬Fluo_CaliTimeΪӫ��ͼ��ʱ��궨�����ļ����ṹ��
%          Beha_Seq��Beha_CaliTimeͬ��
% ע�������ļ����е�ʱ�䰴ʱ����������

close all;

fluo_prefix = Fluo_Seq.image_name_prefix;
behavior_prefix = Beha_Seq.image_name_prefix;
Num = length(Fluo_Seq.image_time);
sync_names = cell(Num,2);% ��һ�ж�Ӧӫ��ͼ�񣬵ڶ���Ϊ��Ӧ����Ϊͼ��

% ���ȹ۲�ӫ�����Ϊ����֡��ʱ��ȷ��ʱ����ֵ
% figure;plot(diff(Fluo_Seq.image_time),'b-.');title('Fluorescent image time');ylabel('ms');
% figure;plot(diff(Fluo_CaliTime.image_time),'b-.');title('Fluorescent time calibration');ylabel('ms');
% figure;plot(diff(Beha_Seq.image_time),'b-.');title('Behavioral image time');ylabel('ms');
% figure;plot(diff(Beha_CaliTime.image_time),'b-.');title('Behavioral time calibration');ylabel('ms');

Time_Thres = 10;
Fluo_Interval = mean(diff(Fluo_Seq.image_time));    %������֡ӫ��ͼ��ƽ��ʱ����
Behavior_Interval = mean(diff(Beha_Seq.image_time));%������֡��Ϊͼ��ƽ��ʱ����
Fluo_CaliTime = Fluo_CaliTime.image_time(1);        %ӫ��ͼ��У��ʱ��
Beha_CaliTime = Beha_CaliTime.image_time(1);%��Ϊͼ��У��ʱ��
behavior_time_calibrated = Beha_Seq.image_time - Beha_CaliTime;%ʱ����������Ϊͼ����������ʱ��

sync_index = nan(Num,1);

for i=1:Num
    fluo_time = Fluo_Seq.image_time(i);
    sync_names{i,1} = [fluo_prefix num2str(fluo_time) '.tiff'];
    % ƥ��ӫ��ͼ�����Ϊͼ��
    
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
        match_index = find(match_flag == 1,1); %��ǰƥ��
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