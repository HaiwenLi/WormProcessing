function Tracking_Analysis(roi_points)

close all;

Image_Width = 512;
Image_Height = 512;
x_offset = roi_points(:,1) - Image_Width/2;
y_offset = roi_points(:,2) - Image_Height/2;

abs_x_offset = abs(x_offset);
abs_y_offset = abs(y_offset);

mean_abs_x_offset = mean(abs_x_offset);
std_abs_x_offset = std(abs_x_offset);

mean_abs_y_offset = mean(abs_y_offset);
std_abs_y_offset = std(abs_y_offset);

mean_x_offset = mean(x_offset);
std_x_offset = std(x_offset);

mean_y_offset = mean(y_offset);
std_y_offset = std(y_offset);

offset = (x_offset.^2 + y_offset.^2).^0.5;
mean_offset = mean(offset);
std_offset = std(offset);

figure;plot(x_offset);hold on;
plot(mean_x_offset*ones(length(x_offset),1), 'r-');hold off;
ylabel('Offset');
xlabel('Image Num');
title(['X offset: mean ' num2str(mean_x_offset) ', std ' num2str(std_x_offset)]);

figure;plot(y_offset);hold on;
plot(mean_y_offset*ones(length(y_offset),1), 'r-');hold off;
ylabel('Offset');
xlabel('Image Num');
title(['Y offset: mean ' num2str(mean_y_offset) ', std ' num2str(std_y_offset)]);

figure;plot(abs_x_offset);hold on;
plot(mean_abs_x_offset*ones(length(abs_x_offset),1), 'r-');hold off;
ylabel('Offset');
xlabel('Image Num');
title(['Abs X offset: mean ' num2str(mean_abs_x_offset) ', std ' num2str(std_abs_x_offset)]);

figure;plot(abs_y_offset);hold on;
plot(mean_abs_y_offset*ones(length(abs_y_offset),1), 'r-');hold off;
ylabel('Offset');
xlabel('Image Num');
title(['Abs Y offset: mean ' num2str(mean_abs_y_offset) ', std ' num2str(std_abs_y_offset)]);

figure;plot(offset);hold on;
plot(mean_offset*ones(length(offset),1), 'r-');hold off;
ylabel('Offset');
xlabel('Image Num');
title(['Offset: mean ' num2str(mean_offset) ', std ' num2str(std_offset)]);
end

