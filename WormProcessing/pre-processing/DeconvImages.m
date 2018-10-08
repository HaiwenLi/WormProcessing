function DeconvImages(input_folder, output_folder, PSF, image_background)
% Deconv images
images = dir([input_folder '*.tiff']);

parfor n=1:length(images)
    disp(['Processing: ' images(n).name]);
    image_filename = [input_folder images(n).name];
    output_filename = [output_folder images(n).name];
    image = imread(image_filename);
    deconved_img = ImageDeconv(image,PSF,image_background);
    % save the deconved image into file
    imwrite(uint16(deconved_img),output_filename);
end