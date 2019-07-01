function DrawCenterline_Paper()
% Draw centerline in images
close all;

orange_color = [1 165/255 0];

Backbone_Folder = 'F:\Omega_Images\20170420\group10\Backbone\';
Image_Folder = 'F:\Omega_Images\20170420\group10\Src\';
Start_Index = 985;
End_Index = 1054;

centers = zeros(length(Start_Index:End_Index),2);
index = 1;
for i=Start_Index:End_Index
    image_name = [Image_Folder 'Image_' num2str(i) '.tiff'];
    image = imread(image_name);
    
    backbone_res = LoadCenterlineResults([Backbone_Folder 'backbone_' num2str(i) '.bin']);
    centerline = backbone_res.current_backbone;
    centerline = centerline(end:-1:1,:);
    points_num = length(centerline);
    
    roi_index = floor(points_num*0.9)+1;
    radius = 10;
    figure(1);imshow(image);colormap(gray);axis image;hold on;
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',1.5);
    plot(centerline(1,2),centerline(1,1),'go','LineWidth',1.5);
    plot(centerline(points_num,2),centerline(points_num,1),'ro','LineWidth',1.5);
    viscircles([centerline(roi_index,2) centerline(roi_index,1)],radius,'EdgeColor',orange_color,...
               'DrawBackgroundCircle',false,'LineWidth',1.5);
    hold off;
    
    roi_center = [centerline(roi_index,2) centerline(roi_index,1)];
    centers(index,:) = roi_center;
    index = index+1;
    % img = zeros(512,512);
    % img(255:257,255:257) = 255;
    % imagesc(img);axis image;colormap(gray);axis off;
    print(1,'-djpeg','-r300',['Centerline\Fig_' num2str(i)]);
    pause(1);
end
save('roi_centers_for_paper.mat','centers');
end

