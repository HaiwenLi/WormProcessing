function CopyFluoFolder(in_folder,out_folder)

GCaMP_Folder = [in_folder 'GCaMP_Map\'];
RFP_Folder = [in_folder 'RFP_Map\'];
Output_GCaMP_Folder = [out_folder 'GCaMP_Map'];
Output_RFP_Folder = [out_folder 'RFP_Map'];
if ~exist(Output_GCaMP_Folder,'dir')
    mkdir(Output_GCaMP_Folder);
end
if ~exist(Output_RFP_Folder,'dir')
    mkdir(Output_RFP_Folder);
end
Output_GCaMP_Folder = [Output_GCaMP_Folder '\'];
Output_RFP_Folder = [Output_RFP_Folder '\'];

disp(['Copying ' in_folder ' to ' out_folder]);
% copy synchronous strcuture
copyfile([in_folder 'sync_struc.mat'],[out_folder 'sync_struc.mat']);

% copy images
copyfile(GCaMP_Folder,Output_GCaMP_Folder);
copyfile(RFP_Folder,Output_RFP_Folder);

end
