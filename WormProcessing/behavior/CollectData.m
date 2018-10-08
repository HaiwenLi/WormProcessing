% Collect behavior data (image and centerline)

M = 500; % 500 images
for n=4:25
    disp(['Processing data ' num2str(n)]);
    
    ImgFolder = ['H:\BehaviorImages\ROI Tracking\head_5ms_wash_Tiff' num2str(n) '\'];
    ResFolder = ['H:\BehaviorImages\ROI Tracking\Res\head_5ms_wash_Res' num2str(n) '\'];
    
    OutFolder = ['C:\Users\Kevin\Desktop\BehaviorData\Worm' num2str(n)];
    OutImgFolder = [OutFolder '\Image'];
    if ~exist(OutImgFolder,'dir')
        mkdir(OutImgFolder);
    end
    OutImgFolder = [OutImgFolder '\'];
    
    img_seq = GetImageSeq(ResFolder,'.res');
    img_time = img_seq.image_time;
    prefix = img_seq.image_name_prefix;

    centerlines = zeros(M,101,2);
    i = 1;
    while i<=M
        img_name = [ImgFolder prefix num2str(i-1) '.tiff'];
        out_img_name = [OutImgFolder prefix num2str(i) '.tiff'];
        
        res_name = [ResFolder prefix num2str(img_time(i)) '.res'];
%         disp(res_name);
        res = LoadStaringImagingRes(res_name);
        if res.length_error == 0
            centerlines(i,:,:) = res.centerline;
            
            % copy images to folder
            copyfile(img_name, out_img_name);
        else
            disp(['Length error: ' num2str(i)]);
        end
        i = i+1;
    end
    
    % save centerlines into folder
    save([OutFolder '\centerlines.mat'],'centerlines');
end