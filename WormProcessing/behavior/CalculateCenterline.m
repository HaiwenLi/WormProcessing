function CalculateCenterline(InputFolder,Output_Folder,start_index,end_index)
% Use worm_cv.exe to calculate the worm centerline

system(['..\worm_cv\worm_cv.exe ' InputFolder ' ' Output_Folder ' ' num2str(start_index) ' '...
    num2str(end_index)]);
end