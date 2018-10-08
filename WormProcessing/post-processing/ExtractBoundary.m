function ExtractBoundary(Folder,frame_seq)
% Boundary: [y,x]

clc;

Boundary_Folder = [Folder 'Boundary'];
if ~exist(Boundary_Folder,'dir')
    mkdir(Boundary_Folder);
end

Image_Folder = [Folder 'RFP\'];
image_names = dir([Image_Folder '*.tiff']);
image_num = length(frame_seq);

tic
for i=1:image_num
    image_index = frame_seq(i);
    image = imread([Image_Folder image_names(image_index).name]);
    [binary_img,boundary,crop_region,success] = ExtractBoundaryInRFP(image);
    
    if success
        disp([num2str(i) ': ' image_names(image_index).name]);
%         imagesc(binary_img);axis image;hold on;
%         plot(boundary(:,2),boundary(:,1),'r.-');
%         pause(0.1);
    else
        error = 'Circle Error';
        disp([num2str(i) ': ' image_names(image_index).name  '-> ' error]);
    end
    
    % Save the boundary
    save([Boundary_Folder '\' image_names(image_index).name '.mat'],'binary_img','boundary','crop_region','success');
end
time = toc;
disp(['Total time cost: ' num2str(time) ' s']);
end