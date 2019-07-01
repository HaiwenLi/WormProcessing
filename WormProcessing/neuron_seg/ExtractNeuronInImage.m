function [worm_region,neurons,intensities] = ExtractNeuronInImage(img)
% Recongnize and Segment neuron in image

NeuronSegConfig;

% Neuron_Itensity = 450; % need to be adaptive
% Background_Threshold = 150;

original_img = medfilt2(img,[5,5]);
worm_region = CalculateCropRegion(original_img,Background_Threshold);
worm_img = double(original_img(worm_region(1):worm_region(2),worm_region(3):worm_region(4)));
[height, ~] = size(worm_img);

% Neuron binary image
binary_img = worm_img > Neuron_Itensity;
dist_img = bwdist(~binary_img);

% 对worm_img做Gaussian平滑，消除多个局部极大值点
filter_size = [5,5];
h = fspecial('gaussian',filter_size,1.5);
intensity_img = imfilter(worm_img.*binary_img,h);
intensity_img(intensity_img <= Background_Threshold) = 0;
intensity_img = intensity_img + 20*dist_img; % 使用距离函数做图像增强

% worm_img_p2 = medfilt2(worm_img.*binary_img, filter_size);
% worm_img_p2 = imfilter(worm_img_p2,h);
% worm_img_p2 = medfilt2(worm_img_p2,filter_size);
% figure;imagesc(worm_img_p2);axis image;

% low pass and high pass to process image
% LowPassSigma = NeuronRadius_Thres;
% HighPassSigma = sqrt(3)*NeuronRadius_Thres;
% intensity_img = GaussianLowPass(intensity_img, LowPassSigma);
% intensity_img = GaussianHighPass(intensity_img, HighPassSigma);

% Speed is low!
% localmax_img = imextendedmax(dist_img,0.5) | imextendedmax(intensity_img, 50);
% 算法核心部分，确定神经元大致位置，后续需要进一步验证！
% localmax_img = (dist_img >= NeuronRadius_Thres) & imextendedmax(intensity_img, NeuronItensity_MaxThres);
localmax_img = imextendedmax(intensity_img, NeuronItensity_MaxThres);

conncomps = bwconncomp(localmax_img,8);
neurons = zeros(2*conncomps.NumObjects,2);

Distance_Thres = 2*NeuronRadius_Thres + 1;
neurons_num = 0;
for i=1:conncomps.NumObjects
    pixels = conncomps.PixelIdxList{i};
    % 若面积过小，则不认为是cell
    if length(pixels)<NeuronArea_Thres
        continue;
    end
    
    % 提取连通分支
    [conncomp_img,~,conncomp_region] = extract_conncomp(worm_img,pixels);
    
    % 获取连通分支中的局部最大点，并将联通的局部最大点缩小为一个点
    localmax_points = extract_localmax_points(localmax_img,worm_img,conncomp_region);
    
    % 如果每个连通分支中有多个极大值，则判断是否需要合并极值
    localmax_points_in_conncomp = points_in_list(localmax_points,pixels);
    
    if ~isempty(localmax_points_in_conncomp)
        candi_points = zeros(length(localmax_points_in_conncomp),2);
        candi_points(:,2) = floor(localmax_points_in_conncomp/height)+1; %列坐标
        candi_points(:,1) = localmax_points_in_conncomp - (candi_points(:,2)-1)*height; %行坐标
        if length(localmax_points_in_conncomp)>1
            point_values = worm_img(localmax_points_in_conncomp);
            seed_points = combine_points(candi_points,point_values,Distance_Thres);
        else
            seed_points =  candi_points;
        end
    else
        continue;
    end
    
    % 算法简化版本，不做神经元的分割，只需要知道位置
        
    % 获得种子图像
    seed_points = round(seed_points); 
    [~,new_seed_points] = create_seeds(seed_points,conncomp_region);
%     figure;imagesc(conncomp_img);axis image;
%     figure;imagesc(seed_img);axis image; 

    % 提取连通分支，并使用区域增长算法分割每一部分，种子点为out_points
    g = regionseg(conncomp_img,new_seed_points,Distance_Thres);
    
    % 获取neuron数据
    max_num = max(g(:));
    for c_label = 1:max_num
        [y,x] = find(g==c_label);
        if ~isempty(x)
            neuron_data_y = y+conncomp_region(1)-conncomp_region(5)+worm_region(1)-2; %row
            neuron_data_x = x+conncomp_region(2)-conncomp_region(5)+worm_region(3)-2; %col
            neurons_num = neurons_num+1;
            neurons(neurons_num,:) = [mean(neuron_data_y) mean(neuron_data_x)];
        end
    end
end
neurons = neurons(1:neurons_num,:);

intensities = zeros(neurons_num,1);
% % Extract neurons intensities
% radius = 4;
% for i=1:neurons_num
%     intensities(i) = GetNeuronIntensity(img,[neurons(i,2) neurons(i,1)],radius,nan);
% end

end