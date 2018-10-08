function DeconvImages_Fast(input_folder, output_folder, PSF, image_background)
% Deconv images
images = dir([input_folder '*.tiff']);

parfor n=1:length(images)
    disp(['Processing: ' images(n).name]);
    image_filename = [input_folder images(n).name];
    output_filename = [output_folder images(n).name];

    % Read image and extract worm region
    src_img = imread(image_filename);
    region = CalculateCropRegion(src_img,image_background*1.5);
    crop_img = src_img(region(1):region(2),region(3):region(4));

    deconved_crop_img = ImageDeconv(crop_img,image_background);
    deconved_img = uint16(size(src_img));
    deconved_img(region(1):region(2),region(3):region(4)) = uint16(deconved_crop_img);

    % save the deconved image into file
    imwrite(deconved_img,output_filename);
end