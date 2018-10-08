%%%%%%%%% Calculate worm speed

% % 20180813-P2-F1
% Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180813-P2\B1\Image\','I:\FluoImages\20180813-P2\F1\','H:\WormImages\20180813-P2\TimeCali_Beha\','I:\FluoImages\20180813-P2\TimeCali_Fluo\', [],[],'','','');

% worm_pos = GetWormPos('H:\WormImages\20180813-P2\B1\Res\','WormPos_20180813_P2_F1');
% [worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180813-P2\B1\Image\',worm_pos,Fluo_Behavior_Sync,1201:3299);

% save('WormSpeed_20180813_P2_F1.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');


% % 20180813-P2-F8
% Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180813-P2\B8\Image\','I:\FluoImages\20180813-P2\F8\','H:\WormImages\20180813-P2\TimeCali_Beha\','I:\FluoImages\20180813-P2\TimeCali_Fluo\', [],[],'','','');

% worm_pos = GetWormPos('H:\WormImages\20180813-P2\B8\Res\','WormPos_20180813_P2_F8');
% [worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180813-P2\B8\Image\',worm_pos,Fluo_Behavior_Sync,2176:3594);

% save('WormSpeed_20180813_P2_F8.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');


% % 20180813-P2-F9
% Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180813-P2\B9\Image\','I:\FluoImages\20180813-P2\F9\','H:\WormImages\20180813-P2\TimeCali_Beha\','I:\FluoImages\20180813-P2\TimeCali_Fluo\',[],[],'','','');

% worm_pos = GetWormPos('H:\WormImages\20180813-P2\B9\Res\','WormPos_20180813_P2_F9');
% [worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180813-P2\B9\Image\',worm_pos,Fluo_Behavior_Sync,1891:3665);

% save('WormSpeed_20180813_P2_F9.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');


% % 20180813-P2-F10
% Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180813-P2\B10\Image\','I:\FluoImages\20180813-P2\F10\','H:\WormImages\20180813-P2\TimeCali_Beha\','I:\FluoImages\20180813-P2\TimeCali_Fluo\', [],[],'','','');

% worm_pos = GetWormPos('H:\WormImages\20180813-P2\B10\Res\','WormPos_20180813_P2_F10');
% [worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180813-P2\B10\Image\',worm_pos,Fluo_Behavior_Sync,2056:3161);

% save('WormSpeed_20180813_P2_F10.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');


% % 20180813-P2-F11
% Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180813-P2\B11\Image\','I:\FluoImages\20180813-P2\F11\','H:\WormImages\20180813-P2\TimeCali_Beha\','I:\FluoImages\20180813-P2\TimeCali_Fluo\',[],[],'','','');

% worm_pos = GetWormPos('H:\WormImages\20180813-P2\B11\Res\','WormPos_20180813_P2_F11');
% [worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180813-P2\B11\Image\',worm_pos,Fluo_Behavior_Sync,1:1350);

% save('WormSpeed_20180813_P2_F11.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

%%%%% crop neuron activity data

20180813-P2-F1 去掉末尾数据   1~85s
Smooth_F1_Activity = ComputeSmoothGCaMPActivity('I:\NeuronData\20180813-P2\F1\Neuron_Activity.mat',[1:(85*24)]);
F1_names = {'VB3','DB3','VA3','VB4','DA3/VA4','VB5','DB4','VA5','VB6','DA4','VA6','VA8','VB9','DB6','DA6','VA9','VB10'};

20180813-P2-F8 OK
Smooth_F8_Activity = ComputeSmoothGCaMPActivity('I:\NeuronData\20180813-P2\F8\Neuron_Activity.mat',[1:1419]);
F8_names = {'DB3','DA2','VA3','VB4','DB4','DA4','VA8','VB9','DB6','DA6','VA9','VB10'};

20180813-P2-F9 去掉末尾数据
% Smooth_F9_Activity = ComputeSmoothGCaMPActivity('I:\NeuronData\20180813-P2\F9\Neuron_Activity.mat',[1:(72*24)]);
F9_names = {'DA4','VB7','VA8','VB9','DB6','DA6','VA9','VB10'};

20180813-P2-F10 OK
F10_names = {'VA2','VB3','DB3','VA3','VB4','VB5','DB4','VB7','VB8','DB6','DA6','VA9','VB10'};

20180813-P2-F11 去掉末尾数据
Smooth_F11_Activity = ComputeSmoothGCaMPActivity('I:\NeuronData\20180813-P2\F11\Neuron_Activity.mat',[1:(55*24)]);
F11_names = {'VA3','VB4','VB5','DB4','VB7','VB8','DB6','DA6','VA9','VB10'};

20180813-P2-F14 该数据已处理完毕
F14_names = {'DB2','DB1','VA2','VB3','DB3','VA3','VB4','DA3','VA4','DB4','VB6','DA4','VA6','VA8','VB9','DB6','DA6','VA9','VB10','VA10'}



====================================================

20180516 data (不加盖玻片)，进对比几个神经元的数据

=================
frame_rate = 24;
r = 0.42;
crawl_direction = worm_pos(2:end,:)-worm_pos(1:end-1,:);
crawl_dist = sqrt(sum(crawl_direction.^2,2));
speed = crawl_dist*frame_rate*r;
smooth_speed = smooth(speed,floor(2*frame_rate));