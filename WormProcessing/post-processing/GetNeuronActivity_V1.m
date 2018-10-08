function GetNeuronActivity_V1(Img_Folder,Neuoron_Pos_Folder,Neuron_Num,frame_seq,data_outputName)
% Calculate calcium transient of neurons

image_format = '.tiff';
Update_Center = 1;
% Deconved_Folder = 'L:\Deconved\'; % Don't USE deconved image to calculate neuron signal

GCaMP_Folder = [Img_Folder 'GCaMP\'];
RFP_Folder = [Img_Folder 'RFP\'];
GCaMP_Images_Seq = GetImageSeq(GCaMP_Folder,image_format); 
RFP_Images_Seq = GetImageSeq(RFP_Folder,image_format);
sync_struc = SyncImageGroups(GCaMP_Images_Seq,RFP_Images_Seq);
sync_names = sync_struc.sync_names;
match_index = sync_struc.match_index;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
GCaMP_Neuron_Pos = load([Neuoron_Pos_Folder 'green.txt']);
RFP_Neuron_Pos = load([Neuoron_Pos_Folder 'red.txt']);
disp('Load GCaMP and RFP neuron positions, starting to generate neuron tracking video');

image_num = frame_seq(end)-frame_seq(1)+1;
GCaMP_Ca = zeros(Neuron_Num,image_num);
GCaMP_Ba = zeros(Neuron_Num,image_num);
RFP_Ca = zeros(Neuron_Num,image_num);
RFP_Ba = zeros(Neuron_Num,image_num);

Search_Interval = 5;
neuron_radius = 4;
% intensity_ratio = (3/neuron_radius)^2;
intensity_ratio = 0.75;
total_num = length(frame_seq);
for i=1:length(frame_seq)-1 % 为了避免之前map与目前sync map不一致的情况
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    image_index = frame_seq(i);
    GCaMP_Imagename = [GCaMP_Folder char(sync_names(image_index,1))];
    GCaMP_Image = imread(GCaMP_Imagename);
    RFP_Imagename = [RFP_Folder char(sync_names(image_index,2))];
    RFP_Image = imread(RFP_Imagename);

    GCaMP_Centers = GCaMP_Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:);
    rfp_index = match_index(image_index) - match_index(frame_seq(1)) + 1;
    RFP_Centers = RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+1:rfp_index*Neuron_Num,:);
    
    for j=1:Neuron_Num
        % Update Centers
        if Update_Center == 1
            % update gcamp neuron pos
            [GCaMP_Centers(j,1),GCaMP_Centers(j,2)] = UpdateNeuronPos(GCaMP_Centers(j,1),GCaMP_Centers(j,2),...
                Search_Interval, 0.5, GCaMP_Image);
%             [GCaMP_Centers(j,1),GCaMP_Centers(j,2)] = UpdateNeuronPos(GCaMP_Centers(j,1),GCaMP_Centers(j,2),...
%                 Search_Interval-3, 0.5, GCaMP_Image);
            
            % update rfp neuron pos
            [RFP_Centers(j,1),RFP_Centers(j,2)] = UpdateNeuronPos(RFP_Centers(j,1),RFP_Centers(j,2),...
                Search_Interval, 0.5, RFP_Image);
%             [RFP_Centers(j,1),RFP_Centers(j,2)] = UpdateNeuronPos(RFP_Centers(j,1),RFP_Centers(j,2),...
%                 Search_Interval-3, 0.5, RFP_Image);
        end
        
        % Update the original neuron pos
        if Update_Center == 1
            GCaMP_Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:) = GCaMP_Centers;
            RFP_Neuron_Pos((rfp_index-1)*Neuron_Num+1:rfp_index*Neuron_Num,:) = RFP_Centers;
        end
        
        % Extract fluorescence energy and background
        [GCaMP_Ca(j,i), GCaMP_Ba(j,i)] = ExtractFluoEnergyAndBackground(GCaMP_Image,GCaMP_Centers(j,:),neuron_radius,intensity_ratio);
        [RFP_Ca(j,i), RFP_Ba(j,i)] = ExtractFluoEnergyAndBackground(RFP_Image,RFP_Centers(j,:),neuron_radius,intensity_ratio);
    end
end

% rewrite the data into file
if Update_Center == 1
    GCaMP_fid = fopen([Neuoron_Pos_Folder 'green.txt'],'wt+');
    for i = 1:length(GCaMP_Neuron_Pos)
        fprintf(GCaMP_fid,'%d    %d\n',GCaMP_Neuron_Pos(i,1),GCaMP_Neuron_Pos(i,2));
    end
    fclose(GCaMP_fid);
    
    RFP_fid = fopen([Neuoron_Pos_Folder 'red.txt'],'wt+');
    for i = 1:length(RFP_Neuron_Pos)
        fprintf(RFP_fid,'%d    %d\n',RFP_Neuron_Pos(i,1),RFP_Neuron_Pos(i,2));
    end
    fclose(RFP_fid);
end
        
% Save the neuron activities
save([data_outputName '.mat'],'GCaMP_Ca','GCaMP_Ba','RFP_Ca','RFP_Ba','frame_seq');

end