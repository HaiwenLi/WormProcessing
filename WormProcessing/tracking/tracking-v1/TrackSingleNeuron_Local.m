function TrackSingleNeuron_Local(ImageFolder,anchor_filename,anchor_start,frame_list,initial_pos,output_name) 
% Track single neuron
% Input:
% ImageFolder: folder contains worm fluorescene images
% frame_list: tracking range
% initial_pos: neuron posiiton in the initial frame
% output_name: tracked neuron position filename
% 
% usage: 
% 
% 注：神经元坐标格式为[x,y]

% Tracking Parameters Setting
search_interval = 15;
intensity_ratio = 0.5;

WormImages = dir([ImageFolder,'*.tiff']);
Tracking_Length = length(frame_list);
neuron_pos = zeros(Tracking_Length,2);
neuron_pos(1,:) = initial_pos(:);

% Load anchor position
anchor_pos = load(anchor_filename);
anchor_offset = frame_list(1) - anchor_start;

% The first neuron position is known, locally search in the following frames.
Ax_tempt = nan(1,20); Ay_tempt = nan(1,20);
for n = 2:Tracking_Length
    frame_index = frame_list(n);
    Wimage_name = [ImageFolder WormImages(frame_index).name];
    Wimage = imread(Wimage_name);
    
    gross_pos = neuron_pos(n-1,:) + (anchor_pos(n+anchor_offset,:)-anchor_pos(n+anchor_offset-1,:));
    
    % Repeat several times to make search stable
    Ax_tempt(:) = nan; Ay_tempt(:) = nan;
    [Ax_tempt(1),Ay_tempt(1)] = UpdateNeuronPos(gross_pos(1),gross_pos(2),...
        search_interval,intensity_ratio,Wimage);
    [Ax_tempt(2),Ay_tempt(2)] = UpdateNeuronPos(Ax_tempt(1),Ay_tempt(1),search_interval-3,intensity_ratio,Wimage);
%     [Ax_tempt(3),Ay_tempt(3)] = UpdateNeuronPos(Ax_tempt(2),Ay_tempt(2),search_interval,intensity_ratio,Wimage);
    
    k = 2;
    neuron_pos(n,1) = Ax_tempt(k);
    neuron_pos(n,2) = Ay_tempt(k);
    disp(['neuron pos ' num2str(frame_index) '  Ax = ',num2str(Ax_tempt(k)) ' Ay = ',num2str(Ay_tempt(k))]);
end

% Write all neuron positions into file
fid = fopen(output_name,'wt');  
for n = 1:Tracking_Length
    fprintf(fid,'%d    %d\n',neuron_pos(n,1),neuron_pos(n,2));
end
fclose(fid);

end
        