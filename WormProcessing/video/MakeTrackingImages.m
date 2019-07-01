function MakeTrackingImages(Src_Folder,frame_seq)

close all;
% Teset the crop region 
% test_img = zeros(512,512);
% test_img(1:3,1:3) = 1;
% test_img(1:3,510:512) = 1; 
% test_img(510:512,1:3) = 1;
% test_img(510:512,510:512) = 1;
% imshow(test_img);axis image;
% current_figure = getframe(gcf);
% figure;imagesc(current_figure.cdata);axis image;

D = [0,0.5,70,256,256];
circle = D(3:5);
Centerline_Folder = [Src_Folder 'centerline\'];
Image_Folder = [Src_Folder 'Image\'];

img_seq = GetImageSeq([Src_Folder 'Image\'], '.tiff');
image_name_prefix = img_seq.image_name_prefix;
image_time = img_seq.image_time;

% Start_Index = 1;
% End_Index = length(image_time);
Start_Index = 1;
End_Index = length(frame_seq);
% centers_file = [Src_Folder 'feature_points.txt'];
% centers = load(centers_file);

for i=Start_Index:End_Index
    image_index = frame_seq(i);
    
    image_name = [Image_Folder image_name_prefix num2str(image_time(image_index)) '.tiff'];
    image = imread(image_name);
    imshow(image);axis off;axis image;hold on;
    
    % Load centerline
    %centerline_name = [Centerline_Folder num2str(i) '.mat']; 
    centerline_name = [Centerline_Folder image_name_prefix num2str(image_time(image_index)) '.mat']; 
    load(centerline_name);
    centerline = res.centerline;
    centerline = centerline(end:-1:1,:); % reverse centerline
    points_num = length(centerline);
    
    plot(centerline(1,2),centerline(1,1),'ro','LineWidth',1.5);
    plot(centerline(points_num,2),centerline(points_num,1),'go','LineWidth',1.5);
    plot(centerline(:,2),centerline(:,1),'c-','LineWidth',1.5);
    viscircles([circle(2) circle(3)],circle(1),'EdgeColor','w','LineStyle','--','LineWidth',1.5,'DrawBackgroundCircle',false);
    % rectangle('Position',[rect_region(3) rect_region(1) (rect_region(4) - rect_region(3)),...
    %     (rect_region(2) - rect_region(1))],'EdgeColor',orange_color,'LineWidth',1.5);
    %plot(tracking_point(2),tracking_point(1),'Color',orange_color,'Marker','+','MarkerSize',8,'LineWidth',1.5);
    % plot(centerline(Current_Index(1):Current_Index(2),2),...
    %     centerline(Current_Index(1):Current_Index(2),1),'Marker','.','Color','m','LineWidth',2);
    centers = centerline(floor(0.5*points_num),:);
    plot(centers(2), centers(1), 'Marker','.','MarkerSize', 14, 'Color','m','LineWidth',2);    
    hold off;
    
%     set(gcf,'InvertHardcopy','off');
%     print(1,'-dtiff','-r300',[Src_Folder 'Fig-Dot\' image_name_prefix num2str(image_time(i))]);
    frame = getframe();
    imwrite(frame.cdata(1:512,1:512,:), [Src_Folder 'Fig-Dot\' image_name_prefix num2str(image_time(image_index)) '.tiff'], 'resolution', 300);
end
end

