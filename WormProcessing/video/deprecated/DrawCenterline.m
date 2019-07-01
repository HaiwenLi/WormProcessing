function DrawCenterline()
% Draw centerline in images
close all;

Backbone_Folder = 'G:\Backbone\20170420\Img1\';
Image_Folder = 'I:\Worm_Images\20170420\ROI0.1_24Hz_Img1_Tiff\';
Start_Index = 0;
End_Index = 12526;

writerObj = VideoWriter('group2_video.mp4','MPEG-4');
writerObj.FrameRate = 24;
open(writerObj);
range = [85,31,512,512];

for i=Start_Index:End_Index
%     image_name = ['Centerline\Fig_' num2str(i) '.jpg'];
%     img = imread(image_name);
%     [height, width,~] = size(img);
%     x_offset = floor((width - 1024)/2);
%     y_offset = floor((height-1024)/2);
%     new_img = img(y_offset+1:y_offset+1024,x_offset+1:x_offset+1024,:);
%     imwrite(new_img,image_name);
    image_name = [Image_Folder 'Image_' num2str(i) '.tiff'];
    image = imread(image_name);
% %     binary_image = image > Binary_Threshold;
    
    backbone_res = LoadCenterlineResults([Backbone_Folder 'backbone_' num2str(i) '.bin']);
    centerline = backbone_res.current_backbone;
    points_num = length(centerline);
    
    figure(1);imshow(image);colormap(gray);axis image;hold on;
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',1.5);
    plot(centerline(1,2),centerline(1,1),'ro');
    plot(centerline(points_num,2),centerline(points_num,1),'go');hold off;
% %     saveas(gcf,['Centerline\Fig_' num2str(i) '.fig']);
%     print(1,'-djpeg','-r300',['Centerline\Fig_' num2str(i)]);
    %pause(1);

    % Make video
    current_figure = getframe(gcf);
    region = current_figure.cdata;
    region = region(range(2):range(2)+range(4)-1,range(1):range(1)+range(3)-1,:);
    writeVideo(writerObj,region);
end
close(writerObj);
end

