function AnalyzePSF(PSF_name)
% Analyze PSF image
clc
close all;

disp(['Analyze PSF: ' PSF_name]);
load(PSF_name);

pos_num = size(updated_pos,1);
PSF_Size = size(PSF_Images(:,:,1),1);
half_width = floor(PSF_Size/2);

figure;
for i=1:pos_num
    psf_image = double(PSF_Images(:,:,i));
    max_value = max(psf_image(:));
    normalized_psf_image = psf_image/max_value;
    PSF_Images(:,:,i) = normalized_psf_image;
    
    % Draw profile
    subplot(pos_num,2,(i-1)*2+1);
    plot(normalized_psf_image(half_width+1,:),'b.-');
    title('Horizontal Profile');
    subplot(pos_num,2,i*2);
    plot(normalized_psf_image(:,half_width+1),'b.-');
    title('Vertical Profile');
end

% Calculate variance per (x,y)
PSF_Var = zeros(PSF_Size,PSF_Size);
for i=1:PSF_Size
    for j=1:PSF_Size
        PSF_Var(i,j) = var(PSF_Images(i,j,:));
    end
end
figure;
imagesc(PSF_Var);axis image;
title('PSF Variance');

end