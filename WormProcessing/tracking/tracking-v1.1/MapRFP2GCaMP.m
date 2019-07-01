% function MapRFP2GCaMP(Image_Folder,rfp_filename,sync_filename,rfp_frames,output_name)
function MapRFP2GCaMP(Image_Folder, sync_filename, tracking_index, rfp_frames)

neuron_num = length(tracking_index);

% Tracking Parameters Setting
search_interval = 4;
intensity_ratio = 0.5;

posFolder = [Image_Folder 'neuron_pos\'];
GCaMP_Folder = [Image_Folder 'GCaMP\'];
image_num = length(rfp_frames);
sync_res = load([Image_Folder sync_filename '.mat']);

rfp_start = rfp_frames(1);
rfp_end = rfp_frames(image_num);
rfp_map_index = sync_res.sync_struc.match_index;
gcamp_start = find(rfp_map_index == rfp_start, 1 );
gcamp_end = find(rfp_map_index == rfp_end, 1, 'last' );
if isempty(gcamp_end)
    rfp_end = rfp_end-1;
    gcamp_end = find(rfp_map_index == rfp_end, 1, 'last' );
end

gcamp_neurons_x = zeros(gcamp_end-gcamp_start+1,neuron_num);
gcamp_neurons_y = zeros(gcamp_end-gcamp_start+1,neuron_num);

Ax_tempt = nan(1,10); Ay_tempt = nan(1,10);
rfp_neurons_x = zeros(image_num,neuron_num);
rfp_neurons_y = zeros(image_num,neuron_num);

for n=1:neuron_num
    index = tracking_index(n);
    if index > 9
        rfp_neuron_name = [posFolder,'red\neuron ',num2str(index),'.txt'];
    else
        rfp_neuron_name = [posFolder 'red\neuron 0',num2str(index),'.txt'];
    end
    
    rfp_neuron_pos = load(rfp_neuron_name);
    rfp_neurons_x(:,index) = rfp_neuron_pos(:,1);
    rfp_neurons_y(:,index) = rfp_neuron_pos(:,2);
end
    
for i=gcamp_start:gcamp_end
    worm_img = imread([GCaMP_Folder char(sync_res.sync_struc.sync_names(i,1))]);
    rfp_index = rfp_map_index(i);
    
    for n=1:neuron_num
        index = tracking_index(n);
        neuron_pos_x = rfp_neurons_x(rfp_index - rfp_start + 1, index);
        neuron_pos_y = rfp_neurons_y(rfp_index - rfp_start + 1, index);

        % Repeat several times to make search stable
        Ax_tempt(:) = nan; Ay_tempt(:) = nan;
        [Ax_tempt(1),Ay_tempt(1)] = update_center(neuron_pos_x,neuron_pos_y,...
            search_interval,intensity_ratio,worm_img);
%         [Ax_tempt(2),Ay_tempt(2)] = update_center(Ax_tempt(1),Ay_tempt(1),search_interval,intensity_ratio,worm_img);
        
        % update times
        k = 1;
        gcamp_neurons_x(i-gcamp_start+1,index) = Ax_tempt(k);
        gcamp_neurons_y(i-gcamp_start+1,index) = Ay_tempt(k);
        disp(['GCaMP Neuron Pos ' num2str(i) '  Ax = ',num2str(Ax_tempt(k)) ' Ay = ',num2str(Ay_tempt(k))]);
    end
end

% Write all neuron positions into file
for n=1:neuron_num
    index = tracking_index(n);
    if index>9
        output_name = [posFolder,'green\neuron ',num2str(index),'.txt'];
    else
        output_name = [posFolder 'green\neuron 0',num2str(index),'.txt'];
    end
    
    fid = fopen(output_name,'wt');  
    for t = 1:(gcamp_end-gcamp_start+1)
        fprintf(fid,'%d    %d\n',gcamp_neurons_x(t,index),gcamp_neurons_y(t,index));
    end
    fclose(fid);
end

end