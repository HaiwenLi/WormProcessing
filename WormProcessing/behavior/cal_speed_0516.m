
% 20180516-F1
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B1\Image\','I:\FluoImages\20180516\F1\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B1\Res\','WormPos_20180516_F1');
[worm_speed, ~] = CalculateSpeedInFluo('H:\WormImages\20180516\B1\Image\',worm_pos,Fluo_Behavior_Sync,1:1321);

save('WormSpeed_20180516_F1.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

% 20180516-F2
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B2\Image\','I:\FluoImages\20180516\F2\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B2\Res\','WormPos_20180516_F2');
[worm_speed, ~] = CalculateSpeedInFluo('H:\WormImages\20180516\B2\Image\',worm_pos,Fluo_Behavior_Sync,1:770);

save('WormSpeed_20180516_F2.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

% 20180516-F3
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B3\Image\','I:\FluoImages\20180516\F3\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B3\Res\','WormPos_20180516_F3');
[worm_speed, ~] = CalculateSpeedInFluo('H:\WormImages\20180516\B3\Image\',worm_pos,Fluo_Behavior_Sync,556:2051);

save('WormSpeed_20180516_F3.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

% 20180516-F4
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B4\Image\','I:\FluoImages\20180516\F4\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B4\Res\','WormPos_20180516_F4');
[worm_speed, ~] = CalculateSpeedInFluo('H:\WormImages\20180516\B4\Image\',worm_pos,Fluo_Behavior_Sync,288:1501);

save('WormSpeed_20180516_F4.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

% 20180516-F5
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B5\Image\','I:\FluoImages\20180516\F5\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B5\Res\','WormPos_20180516_F5');
[worm_speed, ~] = CalculateSpeedInFluo('H:\WormImages\20180516\B5\Image\',worm_pos,Fluo_Behavior_Sync,833:1761);

save('WormSpeed_20180516_F5.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');


% 20180516-F8
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B8\Image\','I:\FluoImages\20180516\F8\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B8\Res\','WormPos_20180516_F8');
[worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180516\B8\Image\',worm_pos,Fluo_Behavior_Sync,1:2159);

save('WormSpeed_20180516_F8.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');

% 20180516-F9
Fluo_Behavior_Sync = MakeSyncBehaFluoVideo('H:\WormImages\20180516\B9\Image\','I:\FluoImages\20180516\F9\','H:\WormImages\20180516\TimeCali\','I:\FluoImages\20180516\TimeCali\', [],[],'','','');

worm_pos = GetWormPos('H:\WormImages\20180516\B9\Res\','WormPos_20180516_F9');
[worm_speed, ~] =  CalculateSpeedInFluo('H:\WormImages\20180516\B9\Image\',worm_pos,Fluo_Behavior_Sync,1872:2336);

save('WormSpeed_20180516_F9.mat','worm_speed','Fluo_Behavior_Sync','worm_pos');