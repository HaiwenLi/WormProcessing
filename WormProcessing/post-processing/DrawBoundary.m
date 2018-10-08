function DrawBoundary(Folder, frame_seq, frame_rate, boundary_video)

Boundary_Folder = [Folder 'Boundary'];
if ~exist(Boundary_Folder,'dir')
    error('No boundary files');
end

writerObj = VideoWriter([boundary_video '.mp4'], 'MPEG-4');
writerObj.FrameRate = frame_rate;
open(writerObj);

Image_Folder = [Folder 'RFP\'];
image_names = dir([Image_Folder '*.tiff']);
image_num = length(frame_seq);
tic

h = CreateGaborFilter(4,0);
background = 160;
g_threshold = 40;

% Load neuron positions and draw them
Neuoron_Pos_Folder = 'K:\NeuronData\';
RFP_Pos_File = '20171125_F12_rfp.txt';
RFP_Neuron_Pos = load([Neuoron_Pos_Folder RFP_Pos_File]);
Neuron_Num = 4;

for i=1:image_num
    image_index = frame_seq(i);
    img = imread([Image_Folder image_names(image_index).name]);
    rfp_index = i;
    RFP_Centers = RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+1:rfp_index*Neuron_Num,:);
    
    % binarize the image
    original_img = medfilt2(img);
    original_img = medfilt2(original_img,[5,5]);
    original_img = double(original_img);

%     % Using Gauusian filter to smooth the image
%     sigma = 3;
%     hsize = 7;
%     h = fspecial('gaussian',hsize,sigma);
%     g = imfilter(original_img,h,'replicate');
%     binary_image = g > background;
    f1 = imfilter(original_img,h,'replicate');
    f2 = imfilter(original_img,h','replicate');
    g = f1.^2 + f2.^2;
    binary_image = (g>=g_threshold^2) & (original_img>background);

    % Filtering the small connected componnets
    small_dots = 5;
    binary_image = bwareaopen(binary_image,small_dots,8);

    load([Boundary_Folder '\' image_names(image_index).name '.mat']);
    imagesc(255*binary_image);colormap(gray);axis image;hold on;
    plot(boundary(:,2),boundary(:,1),'b.-');hold on;
    plot(boundary(1,2),boundary(1,1),'ro');hold on;
    plot(RFP_Centers(:,1),RFP_Centers(:,2),'gs');
    
%     boundary_num = length(boundary);
%     plot(boundary(boundary_num,2),boundary(boundary_num,1),'ro');
    title(['Frame ' num2str(i)]);
%     frame = getframe;
%     imwrite(frame.cdata,['figs\' num2str(i) '.tiff']);
    
    % Save the image into video
    writeVideo(writerObj,getframe(gcf));
end

close(writerObj);
end