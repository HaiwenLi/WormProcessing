function UpdateBoundary_ByHand(Folder)
% Update boundary, the new boundary is determined by hand
close all;

Boundary_Folder = [Folder 'Boundary\'];
Figs_Folder = [Folder 'Figs'];
Image_Folder = [Folder 'RFP_Map\'];
% Image_Folder = Folder;
Check_Folder = [Folder 'error\'];
image_names = dir([Image_Folder '*.tiff']);

Seq = GetImageSeq(Check_Folder,'.txt');
seq_index = Seq.image_time;
prefix = Seq.image_name_prefix;

h = figure;
for i=1:length(seq_index)
    image_index = seq_index(i);
    image_name = [prefix num2str(seq_index(i)) '.tiff'];
    
    boundary_file = [Boundary_Folder image_name '.mat'];
    
    % Load boundary file
    load(boundary_file);
    boundary = load([Check_Folder prefix num2str(seq_index(i)) '.txt']);% Get by ImageJ, data is [x,y]
    new_boundary = zeros(size(boundary));
    new_boundary(:,1) = boundary(:,2);% change [x,y] to [y,x]
    new_boundary(:,2) = boundary(:,1);
    boundary = Boundary_Smooth(new_boundary,20);
    success = 1;
    
    % Plot boundary
    img = imread([Image_Folder image_name]);
    imagesc(img);axis image;colormap(gray);hold on;
    plot(boundary(:,2),boundary(:,1),'r-','LineWidth',1);hold on;
    plot(boundary(1,2),boundary(1,1),'go','MarkerSize',8);hold off;%head
    title(num2str(image_index));
    saveas(h,[Figs_Folder '\' image_name '.tif']);
    
    % Save the boundary
    save([Boundary_Folder '\' image_name '.mat'],'binary_img','boundary','crop_region','success');
    
    % reset current axis
    cla('reset');
end