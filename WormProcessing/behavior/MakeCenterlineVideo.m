function MakeCenterlineVideo(Centerline_Folder, OutFolder, video_name)

image_format = '.mat';
img_seq = GetImageSeq(Centerline_Folder, image_format);
image_time = img_seq.image_time;
prefix = img_seq.image_name_prefix;

% figure paramters
line_width = 1.5;
marker_size = 5;
frame_rate = 8;

% make video
% writerObj = VideoWriter([video_name '.mp4'],'MPEG-4');
% writerObj.FrameRate = frame_rate;
% open(writerObj);

h = figure;
for i=1:length(image_time)
    index = image_time(i);
    centerline_file = [Centerline_Folder prefix num2str(index) image_format];
    load(centerline_file);
    
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',line_width);hold on;
    plot(centerline(1,2),centerline(1,1),'ro','MarkerSize',marker_size,'LineWidth',line_width);
    title(['Image ' num2str(index)]);
    axis([0 512 0 512]);axis square;
    hold off;
    
    % write this frame into video/file
    current_figure = getframe(gcf);
    region = current_figure.cdata;
    filename = [OutFolder num2str(index) '.tiff'];
    imwrite(region, filename);
%     writeVideo(writerObj,region);
%     
%     if mod(i,5000) == 0
%         cla reset;
%     end
end
% close(writerObj);

end

