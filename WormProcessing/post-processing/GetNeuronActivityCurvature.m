function GetNeuronActivityCurvature(Folder,frame_seq)
% Calculate calcium transient of neurons

image_format = '.tiff';

GCaMP_Folder = [Folder 'GCaMP\'];
RFP_Folder = [Folder 'RFP\'];
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format);
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
Neuoron_Pos_Folder = [Folder 'neuron_pos\'];
GCaMP_Neuron_Pos = load([Neuoron_Pos_Folder 'green.txt']);
RFP_Neuron_Pos = load([Neuoron_Pos_Folder 'red.txt']);
RFP_Curvature = load([Folder_Pos_Folder 'neuron_curvature.mat']);
L = 2*RFP_Curvature.curvature_region+1;
C = RFP_Curvature.curvature_region+1;
neuron_radius = load([Neuoron_Pos_Folder 'neuron_radius.txt']);
Neuron_Num = length(neuron_radius);
disp('Load GCaMP and RFP neuron positions, starting to generate neuron tracking video');

GCaMP_Activities = zeros(Neuron_Num, length(frame_seq));
RFP_Activities = zeros(Neuron_Num, length(frame_seq));
Curvature = zeros(Neuron_Num,length(frame_seq));

intensity_ratio = 1.0;
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
       [GCaMP_Activities(j,i), ~] = ExtractFluoEnergyAndBackground(GCaMP_Image,GCaMP_Centers(j,:),neuron_radius(j),intensity_ratio);
       [RFP_Activities(j,i), ~] = ExtractFluoEnergyAndBackground(RFP_Image,RFP_Centers(j,:),neuron_radius(j),intensity_ratio);
    end
end

% Save the neuron activities
save([Folder 'neuron_pos\Neuron_Activity.mat'],'GCaMP_Activities','RFP_Activities','Curvature','rame_seq');

end


