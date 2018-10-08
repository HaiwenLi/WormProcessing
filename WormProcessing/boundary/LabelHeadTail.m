function LabelHeadTail(Folder,frame_seq)
% Boundary: [y,x]
clc;

% make boudnary and figure folder
Boundary_Folder = [Folder 'Boundary'];
Figs_Folder = [Folder 'Figs'];
Map_Folder = [Folder 'RFP_Map\'];

image_names = dir([Map_Folder '*.tiff']);
if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(image_names);
end
image_num = length(frame_seq);

tic
h = figure;
for i=1:image_num
    image_index = frame_seq(i);   
    boundary_filename = [Boundary_Folder '\' image_names(image_index).name '.mat'];
    if exist(boundary_filename,'file')
        data = load(boundary_filename);
        boundary = data.boundary;
        binary_img = data.binary_img;
        crop_region = data.crop_region;
        success = data.success;
    else
        disp(image_names(image_index).name);
        continue;
    end
    
%     if isempty(data.boundary)
%         disp(image_names(image_index).name);
%     end
    % Use head-tail distance to recognize head-tail
    if ~data.success
        disp(image_names(image_index).name);
        continue;
    end
    head_pos = boundary(1,:);
    tail_pos = boundary(end,:);
    if i==1
        last_head_pos = head_pos;
        last_tail_pos = tail_pos;
        last_direction = last_head_pos - last_tail_pos;
    else
        current_direction = head_pos - tail_pos;
        if sum(last_direction .* current_direction) < eps
            boundary = boundary(end:-1:1,:); % reverse the boundary
            last_head_pos = tail_pos;
            last_tail_pos = head_pos;
            last_direction = last_head_pos - last_tail_pos;
            % save the boundary into file
            save([Boundary_Folder '\' image_names(image_index).name '.mat'],'binary_img','boundary','crop_region','success');
        end
    end
    
    % show figure
    % disp([num2str(image_index) ': ' image_names(image_index).name]);
    img = imread([Map_Folder image_names(image_index).name]);
    imagesc(img);axis image;colormap(gray);hold on;
    plot(boundary(:,2),boundary(:,1),'r-','LineWidth',1);hold on;
    plot(boundary(1,2),boundary(1,1),'go','MarkerSize',8);hold off;%head
    title(num2str(image_index));
    saveas(h,[Figs_Folder '\' image_names(image_index).name '.tif']);
    
    % reset figure/axis
    cla('reset');

% %     crop_img = image(crop_region(1):crop_region(2),crop_region(3):crop_region(4));
%     if success
%         disp([num2str(image_index) ': ' image_names(image_index).name]);
%         imagesc(binary_img);axis image;hold on;
%         plot(boundary(:,2),boundary(:,1),'r.-','LineWidth',1.5);hold on;
%         plot(boundary(1,2),boundary(1,1),'go','MarkerSize',10);hold off;
%         title(num2str(image_index));
%         % pause(0.1);
%         saveas(h,[Figs_Folder '\' image_names(image_index).name '.tif']);
%     else
%         error = 'Circle Error';
%         disp([num2str(i) ': ' image_names(image_index).name  '-> ' error]);
%     end
end
time = toc;
disp(['Total time cost: ' num2str(time) ' s']);
end