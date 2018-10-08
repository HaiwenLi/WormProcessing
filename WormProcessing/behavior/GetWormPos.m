function worm_pos = GetWormPos(Res_Folder,output_name)
% Read all files in Res Folder to get worm positions
% 
% Input Parameters:
% Res_Folder:  containing all .res files recoding state position and worm ROI point
% output_name: filename for saving worm trajectory
% 
% Output Parameters:
% worm_pos (format [y,x] pixel)

% Get res time
res_format = '.res';
res_seq = GetImageSeq(Res_Folder, res_format);
res_time = res_seq.image_time;

% Processing res file and get worm positions
% 1pixel = 6um

STAGE_XY_TO_IMAGE_FACTOR = 5000/106.1914; %5000 pulse (500um) -> 106.1914 pixels
IMAGE_TO_STAGE_XY_FACTOR = 1/STAGE_XY_TO_IMAGE_FACTOR;
IMAGE_TO_STAGE_XY = [-1.0000*IMAGE_TO_STAGE_XY_FACTOR, -0.0003*IMAGE_TO_STAGE_XY_FACTOR;...
                     -0.0028*IMAGE_TO_STAGE_XY_FACTOR, 1.0000*IMAGE_TO_STAGE_XY_FACTOR];
% IMAGE_TO_STAGE_XY_DET = IMAGE_TO_STAGE_XY(1,1) * IMAGE_TO_STAGE_XY(2,2) - IMAGE_TO_STAGE_XY(1,2) * IMAGE_TO_STAGE_XY(2,1);
% STAGE_XY_TO_IMAGE_MATRIX = [IMAGE_TO_STAGE_XY(2,2) / IMAGE_TO_STAGE_XY_DET, -IMAGE_TO_STAGE_XY(1,2)/IMAGE_TO_STAGE_XY_DET;...
%                             -IMAGE_TO_STAGE_XY(2,1) / IMAGE_TO_STAGE_XY_DET, IMAGE_TO_STAGE_XY(1,1) / IMAGE_TO_STAGE_XY_DET];

worm_trajectory = zeros(length(res_time),2);
stage_pos = zeros(length(res_time),2);
image_offset = zeros(length(res_time),2);

error_record = zeros(length(res_time),1);
stage_status = zeros(length(res_time),256);
error_index = 0;
for i=1:length(res_time)
    name = [Res_Folder res_seq.image_name_prefix num2str(res_time(i)) res_format];
    res = Read_ResFile(name);
    
    tmpChar = char(res.stageStatus);
    
    % Get stage position
    tmpChar = strrep(tmpChar',':','');
    [token, remain] = strtok(tmpChar);
    stage_x = str2double(token);
    stage_y = str2double(strtok(remain));
    pos = [stage_x; stage_y];
    
    if isnan(pos(1))
        error_index = error_index+1;
        error_record(error_index) = i;
    end
    
    stage_status(i,:) = res.stageStatus';
    stage_pos(i,:) = pos;
    image_offset(i,:) = res.imageOffset;
    worm_trajectory(i,:) =  res.imageOffset - IMAGE_TO_STAGE_XY*pos; %pixel
end

error_record = error_record(1:error_index,:);
for i = 1:error_index
    if (error_record(i)+1 > length(res_time))
        stage_pos(error_record(i),:) = stage_pos(error_record(i)-1,:);
    else
        stage_pos(error_record(i),:) = stage_pos(error_record(i)+1,:);
    end
    pos = stage_pos(error_record(i),:);
    worm_trajectory(error_record(i),:) =  image_offset(error_record(i),:) - pos*IMAGE_TO_STAGE_XY';%pixle;
end

% worm pos format [y,x] pixel
worm_pos(:,1) = worm_trajectory(:,2);
worm_pos(:,2) = worm_trajectory(:,1);

% figure,axis equal
% plot(worm_trajectory(:,1),worm_trajectory(:,2));
% title('Worm Trajectory');

% save([output_name '.mat'], 'stage_pos','worm_trajectory','image_offset','error_record','stage_status','res_seq');
% figure,axis equal
% plot(stage_trajectory(:,1),stage_trajectory(:,2));
% title('台子相对于大地');

% worm_trajectory_toEarth = worm_trajectory + stage_trajectory;
% figure,axis equal
% plot(worm_trajectory_toEarth(:,1),worm_trajectory_toEarth(:,2));
% title('虫子相对于大地');

% [center,dist,R] = myMeanshift(worm_trajectory_toEarth,5);
% offset = norm(center- [0 0]);
% tmp(picNum+1,:) = [center(1),center(2),offset,R,Image_Start,Image_End];
end