function DrawCenterline_Paper_Crop()

Start_Index = 47;
End_Index = 67;

height = 1320;
width = 1320;
load('overall_tracking_centers_for_paper.mat');
index = 1;
roi_center = [0,0];
for i=Start_Index:End_Index
    img = imread(['Overall\Centerline\Fig_' num2str(i) '.jpg']);
%     roi = centers(index,:);
    roi = [256 256];
    index = index + 1;
    
    roi_center(1) = round(roi(2)*3 + 91);
    roi_center(2) = round(roi(1)*3 + 430);
    crop_img = img(roi_center(1)-height/2+1:roi_center(1)+height/2, roi_center(2)-width/2+1:roi_center(2)+width/2,:);
    imwrite(crop_img, ['Overall\Centerline\Crop\Fig_' num2str(i) '.jpg']);
end

end