function GetWormShape(Folder)

Centerline_Folder = [Folder 'centerline\'];
Seq = GetImageSeq(Centerline_Folder,'.mat');
image_time = Seq.image_time;
prefix = Seq.image_name_prefix;

for i=1:length(image_time)
	c_data = load([Centerline_Folder prefix num2str(image_time(i)) '.mat']);
	centerline = spline_fitting_partition(c_data.centerline,29); % 30 points in centerline
	if i==1
		angles = zeros(length(image_time),length(centerline)-1);
	end
	angles(i,:) = CalculateAngle(centerline);
	angles(i,:) = angles(i,:) - mean(angles(i,:));
end

% save the shape angles
save([Folder 'shape_angle.mat'],'angles');
end

function shape_angle = CalculateAngle(centerline)
	shape_angle = zeros(length(centerline)-1,1);
	for i=1:(length(centerline)-1)
		shape_angle(i) = atan2(centerline(i+1,1)-centerline(i,1),centerline(i+1,2)-centerline(i,2));
	end
end