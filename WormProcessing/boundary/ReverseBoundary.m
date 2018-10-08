function ReverseBoundary(Folder,reverse_index)

Boundary_Folder = [Folder 'Boundary\'];
Figs_Folder = [Folder 'Figs\'];
num = length(reverse_index);

Image_Folder = [Folder '\RFP_Map\'];
image_names = dir([Image_Folder '*.tiff']);
h = figure;
for i=1:num
    image_index = reverse_index(i);
    image_name = image_names(image_index).name;
    
    boundary_file = [Boundary_Folder image_name '.mat'];
    data = load(boundary_file);
    boundary = data.boundary;
    binary_img = data.binary_img;
    crop_region = data.crop_region;
    success = data.success;

    % reverse the boundary
    boundary = boundary(end:-1:1,:);
        
    % Save the boundary
    save([Boundary_Folder image_name '.mat'],'binary_img','boundary','crop_region','success');
    
%     % Plot boundary
%     img = imread([Image_Folder image_name]);
%     imagesc(img);axis image;colormap(gray);hold on;
%     plot(boundary(:,2),boundary(:,1),'r-','LineWidth',1);hold on;
%     plot(boundary(1,2),boundary(1,1),'go','MarkerSize',8);hold off;%head
%     title(num2str(image_index));
%     saveas(h,[Figs_Folder '\' image_name '.tif']);
%     
%     % clear current axis
%     if mod(i,200) == 0
%         cla('reset'); % clf('reset');
%     end
end
end