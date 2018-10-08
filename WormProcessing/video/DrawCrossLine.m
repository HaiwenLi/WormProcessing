function processed_image = DrawCrossLine(image,point)
% point (x,y)
processed_image = uint8(zeros(size(image,1),size(image,2),3));
processed_image(:,:,1) = image;
processed_image(:,:,2) = image;
processed_image(:,:,3) = image;

% draw cross lines in processed image
row = int32(point(1));
col = int32(point(2));
center_row = uint32(size(image,1)/2);
center_col = uint32(size(image,2)/2);
for k=-9:9
    %center
    %processed_image(center_row-1,center_col+k,:) = [255,0,0];
    processed_image(center_row,center_col+k,:) = [255,0,0];
    processed_image(center_row+1,center_col+k,:) = [255,0,0];

    %processed_image(center_row+k, center_col-1,:) = [255,0,0];
    processed_image(center_row+k, center_col,:) = [255,0,0];
    processed_image(center_row+k, center_col+1,:) = [255,0,0];

    %current position
    %processed_image(row-1,col+k,:) = [0,255,0];
    processed_image(row,col+k,:) = [0,255,0];
    processed_image(row+1,col+k,:) = [0,255,0];

    %processed_image(row+k,col-1,:) = [0,255,0];
    processed_image(row+k,col,:) = [0,255,0];
    processed_image(row+k,col+1,:) = [0,255,0];
end
end