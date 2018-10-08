function DrawBoundary(Folder, frame_seq)

Boundary_Folder = [Folder 'Boundary'];
Img_Folder = [Folder 'RFP_Map\'];
% Img_Folder = Folder;
Figs_Folder = [Folder 'fig\'];

if ~exist(Boundary_Folder,'dir')
    disp('No boundary files');
    return;
end

% image_names = dir([Map_Folder '*.tiff']);
image_names = dir([Img_Folder '*.tiff']);
if strcmp(frame_seq,'all') == 1
    frame_seq = 1:length(image_names);
end

image_num = length(frame_seq);

h = figure;
for i=1:image_num
    image_index = frame_seq(i);
    img = imread([Img_Folder image_names(image_index).name]);
    
    load([Boundary_Folder '\' image_names(image_index).name '.mat']);
    if success
        imagesc(img);colormap(gray);axis image;hold on;
        plot(boundary(:,2),boundary(:,1),'r-');
        plot(boundary(1,2),boundary(1,1),'go');   
        title(['' num2str(image_index)]);hold off;
        saveas(h,[Figs_Folder image_names(image_index).name '.tif']);
    end

    % clear current axis
    if mod(i,200) == 0
        cla('reset'); % clf('reset');
    end
end

end