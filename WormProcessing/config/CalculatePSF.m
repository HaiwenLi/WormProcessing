function CalculatePSF()
% Read point image and extract one PSF image

% Construct PSF data
image_folder = 'C:\Users\MaoHeng\Documents\MATLAB\PSF\2017-11-2-PSF\';
PSF_Data = [struct('image_name','546,697.tif','pos',[549, 700; 822, 736; 612, 1908]),...
    struct('image_name','547,699.tif','pos',[549, 701; 822, 737;]),...
    struct('image_name','883,1643.tif','pos',[885, 1647;]),...
    struct('image_name','963,693.tif','pos',[965, 696; 1026, 1905;]),...
    struct('image_name','992,912.tif','pos',[995, 917; 1143, 1345;]),...
    struct('image_name','1148,1745.tif','pos',[1151, 1750; 966, 698;]),...
    struct('image_name','1163,1505.tif','pos',[1166, 1510;]),...
    struct('image_name','1317,426.tif','pos',[1321, 429; 1535, 1062;]),...
    struct('image_name','1477,771.tif','pos',[1481, 775;]),...
    struct('image_name','1615,769.tif','pos',[1619, 772;])];

for i=1:length(PSF_Data)
    image_name = [image_folder PSF_Data(i).image_name];
    psf_pos = PSF_Data(i).pos;
    psf_images = ExtractPSF(image_name,psf_pos,'');
    if i==1
        PSF_Size = size(psf_images,1);
        psf_mean_images = zeros(PSF_Size,PSF_Size,length(PSF_Data));
    end
    psf_mean_images(:,:,i) = GetMeanPSF(psf_images);
end

% Draw the horizontal and vertical profiles of MEAN PSF images
data_num = length(PSF_Data);
figure;
for i=1:data_num
    subplot(data_num,2,(i-1)*2+1);
    plot(psf_mean_images(ceil(PSF_Size/2),:,i),'b.-','LineWidth',1.2);
    title('Horizontal Profile');
    
    subplot(data_num,2,(i-1)*2+2);
    plot(psf_mean_images(:,ceil(PSF_Size/2),i),'b.-','LineWidth',1.2);
    title('Vertical Profile');
end
save('2017-11-2-PSF.mat','psf_mean_images');

end