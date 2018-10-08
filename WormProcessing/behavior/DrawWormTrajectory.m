function DrawWormTrajectory(worm_pos)
close all;

% smooth the worm position by averaging moving
span = 5;
worm_pos(:,1) = smooth(worm_pos(:,1),span,'moving');
worm_pos(:,2) = smooth(worm_pos(:,2),span,'moving');
worm_pos(:,1) = worm_pos(:,1) - worm_pos(1,1);
worm_pos(:,2) = worm_pos(1,2) - worm_pos(:,2);% from image space to the cartesian

line_width = 1.5;
font_size = 12;
worm_pos = worm_pos/GetBehaviorMag();
plot(worm_pos(:,1), worm_pos(:,2), 'LineWidth', line_width);hold on;
plot(worm_pos(1,1), worm_pos(1,2),'ro');
hold off;
set(gca,'FontSize',font_size);
% xlabel('X (um)','FontSize',font_size);
% ylabel('Y (um)','FontSize',font_size);
xlabel('X (pixel)','FontSize',font_size);
ylabel('Y (pixel)','FontSize',font_size);
end