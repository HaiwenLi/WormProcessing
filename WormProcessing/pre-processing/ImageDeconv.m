function deconved_img = ImageDeconv(img, background)
% Use lucy richardson or winner filtering algorithm to deconv the image

img = double(img);

% Load PSF
PSF = load('..\config\2017-11-2-FinalPSF.mat');

% remove background in the image
img = img - background;
img(img <=0 ) = 0;

% deconved_img = deconvwnr(img, PSF); %using winner filter to deconv image
iteration_num = 11; % deconvlucy default value: 10
deconved_img = deconvlucy(img, PSF, iteration_num);

deconved_img(deconved_img>65535) = 65535;
deconved_img = uint16(deconved_img);
end