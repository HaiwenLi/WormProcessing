function Mean_PSF = GetMeanPSF(PSF_Images)
% Normalized by the area of the PSF image
% The PSF image also can be normalized by the maximum value of image

PSF_Size = size(PSF_Images,1);
PSF_Num = size(PSF_Images,3);
Mean_PSF = zeros(PSF_Size,PSF_Size);
for i=1:PSF_Num
    %normalized_psf = PSF_Images(:,:,i)/max(max(PSF_Images(:,:,i)));
    normalized_psf = PSF_Images(:,:,i)/sum(sum(PSF_Images(:,:,i)));
    Mean_PSF = Mean_PSF + normalized_psf;
end
Mean_PSF = Mean_PSF/PSF_Num;

end