function CombineCenterlines(F1,F2)
% Combine centerline files in two folders
% Move and rename centerlines in F1 into F2

% figure paramters
line_width = 1.5;
marker_size = 5;

F1_seq = GetImageSeq([F1 'Image\'], '.tiff');
F1_time = F1_seq.image_time;
F1_prefix = F1_seq.image_name_prefix;

F2_seq = GetImageSeq([F2 'Image\'], '.tiff');
F2_time = F2_seq.image_time;

ref_index = 1;
figure;
for i=1:length(F1_time)
    cfilename = [F1 'centerline\' num2str(i) '.mat'];
    
    % Find image index compared with reference list
    index = ref_index;
    while index < length(F2_time)
        if F1_time(i) == F2_time(index)
            ref_index = index;
            break;
        else
            index = index + 1;
        end
    end
    copyfile(cfilename,[F2 'centerline\' num2str(ref_index) '.mat']);
    
    % Update centerline figure and save it
    image_name = [F1 'Image\' F1_prefix num2str(F1_time(i)) '.tiff'];
    img = imread(image_name);
    data = load(cfilename);
    centerline = data.centerline;
    
    imshow(img);colormap(gray);axis image;axis off;hold on;
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',line_width);hold on;
    plot(centerline(1,2),centerline(1,1),'ro','MarkerSize',marker_size,'LineWidth',line_width);
    title(['Image ' num2str(ref_index)]);
    hold off;
    
    saveas(gcf,[F2 'fig\Fig_' num2str(ref_index) '.tiff']);
end

end