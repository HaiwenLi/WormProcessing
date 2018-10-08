function curvature = ComputeWormCurvature(Img_Folder)
% Calculate calcium transient of neurons

Boundary_Folder = [Img_Folder 'Boundary\'];
boundary_seq = GetImageSeq(Boundary_Folder, '.tiff.mat');
prefix = boundary_seq.image_name_prefix;
image_time = boundary_seq.image_time;

reverse = 0;
PARTITION_NUM = 100;

total_num = length(image_time);
curvature = zeros(PARTITION_NUM+1,total_num);
for i=1:total_num
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);
    
%     %%%%% JUST for TEST!
%     image_name = [Src_Folder Img_Folder 'RFP\' boundary_files(i).name(1:end-4)];
%     img = imread(image_name);
%     %%%%%
     
    boundary_file = [Boundary_Folder prefix num2str(image_time(i)) '.tiff.mat'];
    data = load(boundary_file);
    if reverse
        data.boundary = data.boundary(end:-1:1,:);
    end
    new_boundary = spline_fitting_partition(data.boundary,PARTITION_NUM);
%     new_boundary = Boundary_Smooth(data.boundary,fine_arc_length);
    curvature(:,i) = Compute_Curvature(new_boundary);
end

end


