function PSF_Images = ExtractPSF(image_name,psf_pos,output_name)
% Read point image and extract one PSF image

point_image = imread(image_name);
PSF_size = 9; % must be odd
half_width = floor(PSF_size/2);

% Extract PSF
pos_num = size(psf_pos,1);
updated_pos = zeros(pos_num,2);
PSF_Images = zeros(PSF_size,PSF_size,pos_num);
for i=1:pos_num
    x = psf_pos(i,1);
    y = psf_pos(i,2);
    
    % Update PSF Image
    PSF_Image = point_image(y-half_width:y+half_width,x-half_width:x+half_width);
    [x1,y1] = UpdatePSFCenter(PSF_Image,x,y);
    updated_pos(i,1) = x1;
    updated_pos(i,2) = y1;
    PSF_Images(:,:,i) = point_image(y1-half_width:y1+half_width,x1-half_width:x1+half_width);
    imagesc(PSF_Images(:,:,i));colormap(gray);axis image;
end

% % Save PSF image
% output_PSF_name = ['PSF-' output_name '.mat'];
% save(output_PSF_name, 'PSF_Images','updated_pos');
end