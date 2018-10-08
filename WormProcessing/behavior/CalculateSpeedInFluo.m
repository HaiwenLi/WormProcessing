function [out_speed,match_index] = CalculateSpeedInFluo(behavior_folder,worm_pos,sync_data,frame_seq)

% worm_pos: pixel unit

mag = 4.7; % 1 pixel is 4.74 um

behavior_seq = GetImageSeq(behavior_folder, '.tiff');
image_time = behavior_seq.image_time;
prefix = behavior_seq.image_name_prefix;

speed = zeros(length(worm_pos),1);
speed(2:end) = sqrt(sum((worm_pos(2:end,:) - worm_pos(1:end-1,:)).^2,2));
speed(1) = speed(2);
match_index = sync_data.index;
% match_index = zeros(length(sync_data),1);
speed = speed*8*mag; % um/s

% for i=1:length(sync_data)
%     for j=max(1,match_index(i)):length(image_time)
%         if strcmp([prefix num2str(image_time(j)) '.tiff'], char(sync_data{i,2})) == 1
%             match_index(i) = j;
%             break;
%         end
%     end
% end

out_speed = zeros(length(frame_seq),1);
for i=1:length(frame_seq)
    out_speed(i) = speed(match_index(frame_seq(i)));
end

end

