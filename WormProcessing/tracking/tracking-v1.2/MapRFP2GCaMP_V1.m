function MapRFP2GCaMP_V1(Image_Folder, tracking_index, rfp_frames)
% Map red neuron positions to green images

frame_rate = 16;
neuron_num = length(tracking_index);

% Tracking Parameters Setting
intensity_ratio = 0.5;
Neuron_Motion_Threshold = 0;

posFolder = [Image_Folder 'neuron_pos\'];
GCaMP_Folder = [Image_Folder 'GCaMP\'];
RFP_Folder = [Image_Folder 'RFP\'];
image_num = length(rfp_frames);
sync_res = load([Image_Folder 'sync_struc.mat']);
neuron_radius = 4;

rfp_start = rfp_frames(1);
rfp_end = rfp_frames(image_num);
gcamp_range = ConvertDataRange(sync_res.sync_struc,'red',[rfp_start,rfp_end]);
gcamp_start = gcamp_range(1); gcamp_end = gcamp_range(2);
gcamp_neurons_x = zeros(gcamp_end-gcamp_start+1,neuron_num);
gcamp_neurons_y = zeros(gcamp_end-gcamp_start+1,neuron_num);

Ax_tempt = nan(1,10); Ay_tempt = nan(1,10);
rfp_neurons_x = zeros(image_num,neuron_num);
rfp_neurons_y = zeros(image_num,neuron_num);
rfp_neuron_motion = zeros(1, image_num);

% load neuron positions in red images
for n=1:neuron_num
    rfp_neuron_name = [posFolder,sprintf('red\neuron %02d',tracking_index(n)),'.txt'];  
    rfp_neuron_pos = load(rfp_neuron_name);
    rfp_neurons_x(:,n) = rfp_neuron_pos(:,1);
    rfp_neurons_y(:,n) = rfp_neuron_pos(:,2);

    if n>1
        rfp_neuron_motion(n) = sqrt(sum((rfp_neurons_x(n,1) - rfp_neurons_x(n-1,1)).^2 + ...
            (rfp_neurons_y(n,1) - rfp_neurons_y(n-1,1)).^2));
    end
end
% Neuron_Motion_Threshold = mean(RemoveOutlier(rfp_neuron_motion,2*frame_rate));

% map neuron positions
for iFrame=gcamp_start:gcamp_end
    worm_img = imread([GCaMP_Folder char(sync_res.sync_struc.sync_names(iFrame,1))]);
    rfp_index = rfp_map_index(iFrame);
    motion_offset = [0,0];
    
%     if rfp_neuron_motion(rfp_index) > Neuron_Motion_Threshold
%         RFP_Image = imread([RFP_Folder char(sync_res.sync_struc.sync_names(iFrame,2))]);
%         motion_dir = [0, 0]; %x,y
% 
%         if rfp_index + 1 < gcamp_end
%             motion_dir = [mean(rfp_neurons_x(rfp_index+1,:) - rfp_neurons_x(rfp_index,:)), ...
%                           mean(rfp_neurons_y(rfp_index+1,:) - rfp_neurons_y(rfp_index,:))];
%         end
%         motion_offset = CalculateImageOffset(worm_img, RFP_Image, motion_dir);
%     end

    for n=1:neuron_num
        neuron_pos_x = rfp_neurons_x(rfp_index-rfp_start+1, n) + motion_offset(1);
        neuron_pos_y = rfp_neurons_y(rfp_index-rfp_start+1, n) + motion_offset(2);

        % Repeat several times to make searching stable
        Ax_tempt(:) = nan; Ay_tempt(:) = nan;
%         [Ax_tempt(1),Ay_tempt(1)] = UpdateNeuronPos(neuron_pos_x,neuron_pos_y,neuron_radius(n),intensity_ratio,worm_img);
        [Ax_tempt(1),Ay_tempt(1)] = UpdateNeuronPos(neuron_pos_x,neuron_pos_y,neuron_radius,intensity_ratio,worm_img);
        
        % Update 
        k = 1;
        gcamp_neurons_x(iFrame-gcamp_start+1,n) = Ax_tempt(k);
        gcamp_neurons_y(iFrame-gcamp_start+1,n) = Ay_tempt(k);
        disp(['GCaMP Neuron Pos ' num2str(iFrame) '  Ax = ',num2str(Ax_tempt(k)) ' Ay = ',num2str(Ay_tempt(k))]);
    end
end

% Write all neuron positions into file
write_neuronpos([posFolder 'green\'],tracking_index,gcamp_neurons_x,gcamp_neurons_y);
end