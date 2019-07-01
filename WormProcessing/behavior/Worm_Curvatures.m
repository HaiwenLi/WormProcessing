function curvatures = Worm_Curvatures(Centerline_Folder,frame_seq)
% scalculate worm curvature

Num = length(frame_seq);
PNum = 50;

for i = 1:length(frame_seq)
    index = frame_seq(i);
    
	centerline_data = load([Centerline_Folder num2str(index) '.mat']);
    centerline = centerline_data.centerline;
    
    % make to 50 points
    if length(centerline) ~= PNum
        centerline = spline_fitting_partition(centerline,PNum-1);
    end
    
	if i==1
		curvatures = zeros(Num,length(centerline)); % allocate spaces
	end
	curvatures(i,:) = Compute_Curvature(centerline);
end
% % save worm regions and positions
% save('WormCurvature.mat','curvatures');
end