function MakeGif()

Image_Folder = 'D:\Tracking Images\CrossLine Images\';
Image_Front = 'Image_';
Image_Format = '.tiff';
Image_Start = 37;
Image_End = 124;
FrameRate = 8;

T = 8;
green = [0,1,0];
for i=Image_Start:Image_End
    image_name = [Image_Folder Image_Front num2str(i) Image_Format];
    image = imread(image_name);
    
    % crop images
    crop_width = 512;
    crop_height = 256;
    [rows,cols,~] = size(image);
    y_offset = fix((rows-crop_height)/2);
    x_offset = fix((cols-crop_width)/2);
    new_image = image(y_offset+1:y_offset+crop_height,x_offset+1:x_offset+crop_width,:);
    
    %save to gif format
    if (i-Image_Start+1)<=T
        new_image = AddTriangle(new_image,green);
    end
    [A,map] = rgb2ind(new_image,256);
    if i==Image_Start
        imwrite(A,map,'video.gif', 'gif', 'LoopCount',Inf, 'DelayTime',1/FrameRate);
    else
        imwrite(A,map,'video.gif', 'gif', 'WriteMode','Append','DelayTime',1/FrameRate);
    end
end

for j=1:8
    black_image = zeros(crop_height,crop_width,3);
    [A,map] = rgb2ind(black_image,256);
    imwrite(A,map,'video.gif', 'gif', 'WriteMode','Append','DelayTime',1/FrameRate);
end
end

function image = AddTriangle(image,color)
start_x = 30;
start_y = 10;
triangle_height = 20;
center_height = fix(triangle_height/2 + triangle_height);
triangle_width = triangle_height*3^0.5/2;

color = unit8(floor(255*color));
color(color < 0) = 0;
color(color > 255) = 255;

for i=1:fix(triangle_width)
    y = fix((triangle_width - (i-1))*3^0.5/3);
    for j=center_height-y:center_height+y
        image(start_y+j,start_x+i,:) = ;
    end
end
end
