function Worm_Motion_Sim()

close all;

delta_t = 2*pi/100;
t = -pi:delta_t:pi;
num = 100;
interval = 10;
roi_pos = 0.3;
roi_points = zeros(num,2);

for k=1:num
    x = t + (k-1)*interval*delta_t;
    y = sin(2*x);
    roi_points(k,:) = Get_ROI(x,y,1-roi_pos);
    
    min_x = x(1);
    max_x = x(length(x));
    target_x = (1-roi_pos)*(max_x-min_x) + min_x;
    plot([target_x,target_x],[-1,1],'g-','LineWidth',2);hold on;
    plot(x,y);hold on;
    plot(roi_points(k,1),roi_points(k,2),'r.');
    axis([min_x max_x -1 1]);
    hold off;
end

offset = roi_points(2:num,:) - roi_points(1:num-1,:);
plot(offset);
end

function roi_point = Get_ROI(x,y,roi_pos)

Partition_Num = 100;
num = length(x);
roi_point = zeros(2,1);

x_diff = diff(x);
y_diff = diff(y);
arc_diff = (x_diff.^2 + y_diff.^2).^0.5;

arc = zeros(num,1);
arc(2:num) = cumsum(arc_diff);
arc_length = arc(length(arc));

arc_x_fn = csaps(arc,x);
arc_y_fn = csaps(arc, y);

interpolated_line = zeros(Partition_Num+1,2);
interpolated_line(:,1) = fnval(arc_x_fn, 0:arc_length/Partition_Num:arc_length);
interpolated_line(:,2) = fnval(arc_y_fn, 0:arc_length/Partition_Num:arc_length);

roi_point(1) = interpolated_line(floor(roi_pos*Partition_Num),1);
roi_point(2) = interpolated_line(floor(roi_pos*Partition_Num),2);
end