function ExtractBoundary(Folder,frame_seq)
% Boundary: [y,x]
clc;
close all;

disp(Folder);
% make boudnary and figure folder
Boundary_Folder = [Folder 'Boundary'];
Figs_Folder = [Folder 'Figs'];

if ~exist(Boundary_Folder,'dir')
    mkdir(Boundary_Folder);
end

if ~exist(Figs_Folder,'dir')
    mkdir(Figs_Folder);
end

Image_Folder = [Folder 'RFP_Map\'];
% Image_Folder = '';
image_names = dir([Image_Folder '*.tiff']);
if strcmp(frame_seq,'all') == 1
    frame_seq = 1:length(image_names);
end

image_num = length(frame_seq);

tic
% h = figure;
for i=1:image_num
    image_index = frame_seq(i);
    image = imread([Image_Folder image_names(image_index).name]);
    [binary_img,boundary,crop_region,success] = ExtractBoundaryInRFP_V1(image);
    
    if success
%         disp([num2str(image_index) ': ' image_names(image_index).name]);
%         imagesc(binary_img);axis image;hold on;
%         plot(boundary(:,2),boundary(:,1),'r.-','LineWidth',2);hold off;
%         % pause(0.1);
%         saveas(h,[Figs_Folder '\' image_names(image_index).name '.tif']);
    else
        error = 'Circle Error';
        disp([num2str(image_index) ': ' image_names(image_index).name  '-> ' error]);
    end
    
    % Save the boundary
    save([Boundary_Folder '\' image_names(image_index).name '.mat'],'binary_img','boundary','crop_region','success');
end
time = toc;
disp(['Total time cost: ' num2str(time) ' s']);
end