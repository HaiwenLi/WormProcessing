function update_positions(Folder,first_frame,frame_seq,pos_file)
% update neuron positions 

pos = load(pos_file);
wimages = dir([Folder '*tiff']);
search_interval = 7;
intensity_ratio = 0.1;
for i = 1:length(frame_seq)
    image_index = frame_seq(i);
    pos_index = frame_seq(i) - first_frame + 1;
    worm_image = imread([Folder,wimages(image_index).name]);
    [pos(pos_index,1),pos(pos_index,2)] = UpdateNeuronPos(pos(pos_index,1),pos(pos_index,2),...
        search_interval,intensity_ratio,worm_image);
    disp(num2str(i));
end

fid = fopen(pos_file,'w');
for i = 1:length(pos(:,1))     
	fprintf(fid,'%d    %d\n',pos(i,1),pos(i,2));       
end
fclose(fid); 
end
        