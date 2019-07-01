function update_index = UpdateCenterline_ByHand(Folder)
% Update curve (may be centerline, boundary), new curve are determined by hand
% Hint: Be carefully with the index of image and centerline!!!

Partition_Num = 150;

Curve_Folder = [Folder 'centerline\'];
Check_Folder = [Folder 'error\'];

Image_Seq = GetImageSeq([Folder 'Image\'],'.tiff');
image_time = Image_Seq.image_time;

Seq = GetImageSeq(Check_Folder,'.txt');
seq_index = Seq.image_time;
curve_prefix = Seq.image_name_prefix;

update_index = zeros(1,length(seq_index));

for i=1:length(seq_index)
    curve_index = seq_index(i);
    % curve_file = [Res_Folder curve_prefix num2str(curve_index) '.mat'];
    
    % Load curve file
    curve = load([Check_Folder curve_prefix num2str(curve_index) '.txt']);
    curve = spline_fitting_partition(curve,Partition_Num);

    % Get by ImageJ, data is [x,y]
    new_curve = zeros(size(curve));
    new_curve(:,1) = curve(:,2);% change [x,y] to [y,x]
    new_curve(:,2) = curve(:,1);
    
    % load(curve_file);
    % default is centerline
    res.centerline = new_curve;
    
    % Save the curve
    index = find(curve_index == image_time);
    update_index(i) = index;
    
    %out_file = [Curve_Folder num2str(index) '.mat'];
    out_file = [Curve_Folder curve_prefix num2str(curve_index) '.mat'];
    save(out_file,'res');
end

end