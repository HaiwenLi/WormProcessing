function [crawl_direction, speed] = CalculateSpeed(worm_pos,frame_rate)
% 计算线虫特征信息：爬行速率，方向
%
% Input Parameters:
% worm_pos:   worm positions [y,x], unit pixel (at camare space)
% frame_rate:  

% mag = GetBehaviorMag(frame_rate);
mag = frame_rate;
displacement = zeros(length(worm_pos),2);
speed = displacement;

% Convert pixel to um
crawl_direction = worm_pos(2:end,:)-worm_pos(1:end-1,:);
displacement(2:end,:) = crawl_direction*mag; % pixel/s
displacement(1,:) = displacement(2,:);

% crawl_dist = sqrt(sum(crawl_direction.^2,2));
% crawl_direction = crawl_direction./crawl_dist;
% crawl_direction(:,2) = -crawl_direction(:,2); %from image space into cartesian

% Smooth speed
speed(:,1) = smooth(displacement(:,1),floor(3*frame_rate),'moving');
speed(:,2) = smooth(displacement(:,2),floor(3*frame_rate),'moving');

end