function MakeCenterlinePointTrackingVideo(Image_Folder,Res_Folder,OutFolder,list)
% Make centerline point tracking images for video
% All filename are determined!
%

Image_Width = 512;
Image_Height = 512;
Mag = 15.35;
Circle_Radius = floor((2048*6.5/(2*Mag))/6);% convert to behavior images
circle = [Circle_Radius 256 256];

% Read all images and res files in Folder
res_seq = GetImageSeq(Res_Folder, '.mat');
prefix = res_seq.image_name_prefix;
time = res_seq.image_time;

if isempty(list)
    list = 1:length(time);
end

% Drawing parameters
line_width = 1.2;
resolution = 300;
offset = [31, 92]; % need check in different computer
op = 'dot'; % draw style, op can be 'dot' or 'line'

h = figure;
for i=1:length(list)
    image_name = [Image_Folder prefix num2str(time(list(i))) '.tiff'];
    res_name = [Res_Folder prefix num2str(time(list(i))) '.mat'];
    
    res_data = load(res_name);
    res = res_data.res;
    centerline = res.centerline;
    centerline = centerline(end:-1:1,:);
    centerline = spline_fitting_partition(centerline,50);
    points_num = length(centerline);
    roi_index = floor(points_num*0.5);
    
    feature_point = [centerline(roi_index,1) centerline(roi_index,2)];
    if strcmp(op, 'dot') == 1
        image = imread(image_name);
    elseif strcmp(op, 'line') == 1
        image = DrawCrossLine(imread(image_name),feature_point);
    end
    
    % Draw circle (FOV of NCI), centerline and cross lines
    imshow(image);axis image;hold on;axis off;
    % draw steps: centerline
    plot(centerline(:,2),centerline(:,1),'c-','LineWidth',line_width);
    plot(centerline(1,2),centerline(1,1),'ro','LineWidth',line_width);% head
    plot(centerline(points_num,2),centerline(points_num,1),'go','LineWidth',line_width);% tail
    
    % draw steps: circle
    viscircles([circle(2) circle(3)],circle(1),'EdgeColor','w','LineStyle','--',...
        'LineWidth',line_width,'DrawBackgroundCircle',false);
    
    if strcmp(op, 'line') == 1
        plot(feature_point(1),feature_point(2),'Marker','.','Color','m','MarkerSize',14);
    end
    
    % Save file
    cdata = frame2im(getframe(gcf));
    cdata = cdata(offset(1):offset(1)+Image_Height-1,offset(2):offset(2)+Image_Width-1,:);
    imwrite(uint8(cdata),[OutFolder prefix num2str(time(list(i))) '.tiff'], 'resolution',resolution);
    
    % clear figure
    cla('reset'); % clf('reset');
end

end