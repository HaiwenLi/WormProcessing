function HeadTailRecognize(Folder,frame_seq)
% Centerline format: [y,x]
clc;

% make boudnary and figure folder
Centerline_Folder = [Folder 'centerline\'];

seq = GetImageSeq(Centerline_Folder, '.mat');
prefix = seq.image_name_prefix;
time = seq.image_time;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(time);
end
c_num = length(frame_seq);

h = figure;
for i=1:c_num
    c_index = frame_seq(i);   
    centerline_filename = [Centerline_Folder prefix num2str(time(c_index)) '.mat'];
    data = load(centerline_filename);
    centerline = data.centerline;
        
    head_pos = centerline(1,:);
    tail_pos = centerline(end,:);
    if i==1
        last_head_pos = head_pos;
        last_tail_pos = tail_pos;
        last_direction = last_head_pos - last_tail_pos;
    else
        current_direction = head_pos - tail_pos;
        if sum(last_direction .* current_direction) < eps
            centerline = centerline(end:-1:1,:); % reverse the boundary
            last_head_pos = tail_pos;
            last_tail_pos = head_pos;
            last_direction = last_head_pos - last_tail_pos;
            % save the boundary into file
            save([Centerline_Folder prefix num2str(time(c_index)) '.mat'],'centerline');
        end
    end
end

% update figure
disp('Updating Figures');
DrawCenterline_Fig(Folder, frame_seq);
end