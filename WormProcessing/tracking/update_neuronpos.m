function update_neuronpos(Folder,neuron_indice,channel,first_frame,frame_seq)
% update neuron positions for specific time period
% channel must be red or green
% Hint: frame_seq is expected frame list of the channel image (for different channel, frame_seq is different)

% update parameters
search_interval = 7;
intensity_ratio = 0.1;

% init
image_format = '.tiff';
channel = lower(channel);
PosFolder = [Folder 'neuron_pos\' channel '\'];
sync_res = load([Image_Folder 'sync_struc.mat']);
if strcamp(channel,'red') == 1
    ImgFolder = [Folder 'RFP\'];
    img_seq = sync_res.rfp_seq;
elseif strcamp(channel,'green') == 1
    img_seq = sync_res.gcamp_seq;
    ImgFolder = [Folder 'GCaMP\'];
else
    disp('Invalid channel,channel = red or green');
    return;
end
image_time = img_seq.image_time;
prefix = img_seq.image_name_prefix;
    
for ni = 1:length(neuron_indice)
    % load neuron position
    nindex = neuron_indice(ni);
    neuron_pos = load([PosFolder,sprintf('neuron %02d',nindex),'.txt']);
    disp(['Updating neuron ' num2str(nindex) ' positions']);
    
    for t = 1:length(frame_seq)
        image_index = frame_seq(t);
        worm_image = imread([ImgFolder prefix num2str(image_time(image_index)) image_format]);
        
        pos_index = frame_seq(t) - first_frame + 1;
        p = neuron_pos(pos_index,:);
        [newpos,~,~] = UpdateNeuronData(p,search_interval,intensity_ratio,worm_image);
        neuron_pos(pos_index,:) = newpos;
    end
    
    % write into file
    write_neuronpos(PosFolder,neuron_indice(ni),neuron_pos(:,1),neuron_pos(:,2),'w');
end
end
        