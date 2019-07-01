function MapRFP2GCaMP(Image_Folder, tracking_index, rfp_frames)
% Map neuron positions in RFP image space to GCaMP image space

neuron_num = length(tracking_index);

% Tracking Parameters Setting
search_interval = 4;
intensity_ratio = 0.5;

posFolder = [Image_Folder 'neuron_pos\'];
GCaMP_Folder = [Image_Folder 'GCaMP\'];
image_num = length(rfp_frames);
sync_res = load([Image_Folder 'sync_struc.mat']);

rfp_start = rfp_frames(1);
rfp_end = rfp_frames(image_num);
rfp_map_index = sync_res.sync_struc.match_index;
gcamp_range = ConvertDataRange(sync_res.sync_struc,'red',[rfp_start,rfp_end]);
gcamp_start = gcamp_range(1); gcamp_end = gcamp_range(2);
gcamp_neurons_x = zeros(gcamp_end-gcamp_start+1,neuron_num);
gcamp_neurons_y = zeros(gcamp_end-gcamp_start+1,neuron_num);

Ax_tempt = nan(1,4); Ay_tempt = nan(1,4);
rfp_neurons_x = zeros(image_num,neuron_num);
rfp_neurons_y = zeros(image_num,neuron_num);

for n=1:neuron_num
    index = tracking_index(n);
    rfp_neuron_name = [posFolder,sprintf('red\\neuron %02d',index),'.txt'];    
    rfp_neuron_pos = load(rfp_neuron_name);
    rfp_neurons_x(:,n) = rfp_neuron_pos(:,1);
    rfp_neurons_y(:,n) = rfp_neuron_pos(:,2);
end
    
for i=gcamp_start:gcamp_end
    worm_img = imread([GCaMP_Folder char(sync_res.sync_struc.sync_names(i,1))]);
    rfp_index = rfp_map_index(i);
    
    for n=1:neuron_num
        neuron_pos_x = rfp_neurons_x(rfp_index - rfp_start + 1, n);
        neuron_pos_y = rfp_neurons_y(rfp_index - rfp_start + 1, n);

        % Repeat several times to make search stable
        Ax_tempt(:) = nan; Ay_tempt(:) = nan;
        [Ax_tempt(1),Ay_tempt(1)] = UpdateNeuronPos(neuron_pos_x,neuron_pos_y,...
            search_interval,intensity_ratio,worm_img);
        [Ax_tempt(2),Ay_tempt(2)] = UpdateNeuronPos(Ax_tempt(1),Ay_tempt(1),search_interval-1,intensity_ratio,worm_img);
        
        % update times
        k = 2;
        gcamp_neurons_x(i-gcamp_start+1,n) = Ax_tempt(k);
        gcamp_neurons_y(i-gcamp_start+1,n) = Ay_tempt(k);
        disp(['GCaMP Neuron Pos ' num2str(i) '  Ax = ',num2str(Ax_tempt(k)) ' Ay = ',num2str(Ay_tempt(k))]);
    end
end

% Write all neuron positions into file
write_neuronpos([posFolder 'green\'],tracking_index,gcamp_neurons_x,gcamp_neurons_y);
end