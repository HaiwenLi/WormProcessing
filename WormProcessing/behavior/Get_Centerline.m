function Get_Centerline(Folder, Head_Pos)
% Read backbone data and convert to centerline
%

seq = GetImageSeq([Folder 'backbone\'], '.bin');
image_time = seq.image_time;
prefix = seq.image_name_prefix;
is_reverse = 0;

for i=1:length(image_time)
	backbone_name = [Folder 'backbone\' prefix num2str(image_time(i)) '.bin'];
	backbone = LoadCenterlineResults(backbone_name);

	if ~backbone.length_error  || i==2
		centerline = backbone.current_backbone;
    else
        centerline = backbone.last_backbone;
		disp(['Error backbone ' num2str(i)]);
    end

    if i == 1 && ~isnan(Head_Pos(1))
    	head_dist = sum((centerline(1,:) - Head_Pos).^2,2);
	    tail_dist = sum((centerline(length(centerline),:) - Head_Pos).^2,2);
	    if (tail_dist < head_dist)
	        is_reverse = 1;
	    end
    end
    
    if is_reverse == 1
    	centerline = centerline(end:-1:1,:);
	end

	centerline = spline_fitting_partition(centerline,49); % 50 points
    centerline_name = [Folder 'centerline\' num2str(i) '.mat'];
    save(centerline_name, 'centerline');
end

end