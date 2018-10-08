function GetNeuronActivity(Img_Folder,GCaMP_Pos_File,RFP_Pos_File,curvature_file,Neuron_Num,...
    frame_seq,offset,data_outputName)
% Calculate calcium transient of neurons

image_format = '.tiff';
Src_Folder = 'H:\FluoImages\';
Neuoron_Pos_Folder = 'H:\NeuronData\';
Deconved_Folder = 'H:\Deconved\'; % Don't USE deconved image to calculate neuron signal

GCaMP_Folder = [Src_Folder Img_Folder 'GCaMP\'];
RFP_Folder = [Src_Folder Img_Folder 'RFP\'];
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
GCaMP_Neuron_Pos = load([Neuoron_Pos_Folder GCaMP_Pos_File]);
RFP_Neuron_Pos = load([Neuoron_Pos_Folder RFP_Pos_File]);
RFP_Curvature = load(curvature_file);
L = 2*RFP_Curvature.curvature_region+1;
C = RFP_Curvature.curvature_region+1;
disp('Load GCaMP and RFP neuron positions, starting to generate neuron tracking video');

image_num = frame_seq(end)-frame_seq(1)+1;
GCaMP_Ca = zeros(Neuron_Num,image_num);
GCaMP_Ba = zeros(Neuron_Num,image_num);
RFP_Ca = zeros(Neuron_Num,image_num);
RFP_Ba = zeros(Neuron_Num,image_num);
Curvature = zeros(Neuron_Num,image_num);

neuron_radius = 3;
intensity_ratio = (3/neuron_radius)^2;
total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    image_index = frame_seq(i);
    GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
    GCaMP_Image = imread(GCaMP_Imagename);
    RFP_Imagename = [RFP_Folder char(sync_names(image_index+offset,2))];
    RFP_Image = imread(RFP_Imagename);

    GCaMP_Centers = int32(GCaMP_Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:));
    rfp_index = match_index(image_index) - match_index(frame_seq(1)) + 1;
    RFP_Centers = int32(RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+1:rfp_index*Neuron_Num,:));
    
    for j=1:Neuron_Num
        % Find the corresponding curvature
        Curvature(j,i) = RFP_Curvature.curvature(C+(j-1)*L,rfp_index);
        
        % Extract fluorescence energy and background
        [GCaMP_Ca(j,i), GCaMP_Ba(j,i)] = ExtractFluoEnergyAndBackground(GCaMP_Image,GCaMP_Centers(j,:),neuron_radius,intensity_ratio);
        [RFP_Ca(j,i), RFP_Ba(j,i)] = ExtractFluoEnergyAndBackground(RFP_Image,RFP_Centers(j,:),neuron_radius,intensity_ratio);
    end
end

% Save the neuron activities
save([data_outputName '.mat'],'GCaMP_Ca','GCaMP_Ba','RFP_Ca','RFP_Ca','Curvature','frame_seq','offset');

end


