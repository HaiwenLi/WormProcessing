function SyncNeuronTracking(frame_seq,sync_File,posFolder,RFP_Pos_File,tracking_index) 
% 将GCaMP通过同步对应到已追踪好的RFP

image_num = length(frame_seq);
neuron_num = length(tracking_index);
GCaMP_Neuron_Pos = zeros(neuron_num * image_num, 2);
RFP_Neuron_Pos = load([posFolder RFP_Pos_File]);
sync_file = load([sync_File]);

for i=1:image_num
    disp(['Processing: ' num2str(i) '/' num2str(image_num)]);
    image_index = sync_file.sync_struc.match_index(i);
    for j = 1:neuron_num
        GCaMP_Neuron_Pos((i-1)*neuron_num+j, :) = RFP_Neuron_Pos((image_index-1)*neuron_num+j, :);
    end   
end

for i = 1:neuron_num
    if tracking_index(i)>9
    	output_name = [posFolder,'green\neuron ',num2str(tracking_index(i)),'.txt'];
    else
    	output_name = [posFolder,'green\neuron 0',num2str(tracking_index(i)),'.txt'];
    end
    fid = fopen(output_name,'a');  
    for j = 1:image_num
    	fprintf(fid,'%d    %d\n',GCaMP_Neuron_Pos(neuron_num*(j-1)+i,1),GCaMP_Neuron_Pos(neuron_num*(j-1)+i,2));
    end
    fclose(fid);
    disp(['Saved:  neuron',num2str(tracking_index(i))])
end

end
