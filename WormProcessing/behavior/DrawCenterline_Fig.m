function DrawCenterline_Fig(Folder, frame_seq)
% Draw centerline and save into figure

close all;

Image_Folder = [Folder 'Image\'];
Centerline_Folder = [Folder 'centerline\'];

% Parameters setting
image_format = '.tiff';
seq = GetImageSeq(Image_Folder,image_format);
image_time = seq.image_time;
prefix = seq.image_name_prefix;

% figure paramters
line_width = 1.5;
marker_size = 5;

for i=1:length(frame_seq)
    index = frame_seq(i);
    
    image_name = [Image_Folder prefix num2str(image_time(index)) image_format];
    image = imread(image_name);
        
    centerline_name = [Centerline_Folder num2str(index) '.mat'];
    if ~exist(centerline_name, 'file')
        disp(['Image ' num2str(index) ' has no centerline data']);
        continue;
    end
    data = load(centerline_name);
    centerline = data.res.centerline;
    
%     % add worm region to centerline
%     centerline = centerline + ...
%         repmat([worm_region(i-Start_Index+1,1) worm_region(i-Start_Index+1,3)], length(centerline),1);
%    image = image(worm_region(i-Start_Index+1,1):worm_region(i-Start_Index+1,2),...
%                    worm_region(i-Start_Index+1,3):worm_region(i-Start_Index+1,4));
    
    imshow(image);colormap(gray);axis image;axis off;hold on;
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',line_width);hold on;
    plot(centerline(1,2),centerline(1,1),'ro','MarkerSize',marker_size,'LineWidth',line_width);

%     if (mod(i,50) == 0)
%         cla reset;
%     end

%     plot(worm_centroid(i-Start_Index+1,2), worm_centroid(i-Start_Index+1,1),...
%         'gs','MarkerSize',marker_size,'LineWidth',line_width);
%     plot(centerline(points_num,2),centerline(points_num,1),'go','MarkerSize',marker_size,...
%         'LineWidth',line_width);
    title(['Image ' num2str(index)]);
    hold off;
    %saveas(gcf,[Folder 'fig\Fig_' num2str(index) '.tiff']);
    saveas(gcf,[Folder 'fig\' prefix num2str(image_time(index)) image_format]);
end
end

