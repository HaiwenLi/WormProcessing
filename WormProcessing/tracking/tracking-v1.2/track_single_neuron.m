function track_single_neuron(Folder,track_index,anchor_index,anchor_start,FluoType,frame_seq,params) 
% Track single neuron
% Input:
% ImageFolder: folder contains worm fluorescene images
% frame_list: tracking range
% initial_pos: neuron posiiton in the initial frame
% output_name: tracked neuron position filename

% 注：神经元坐标格式为[x,y]

Backgroun_Neuron_Ratio = 0.6;

% Tracking Parameters Setting
if nargin == 6
    search_interval = 10;
    intensity_ratio = 0.3;
elseif nargin > 6
    search_interval = params(1);
    intensity_ratio = params(2);
end

if isempty(anchor_index)
    disp('No anchor input'); return;
end

image_format = '.tiff';
sync_struc_data = load([Folder 'sync_struc.mat']);
PosFolder = [Folder 'neuron_pos\' FluoType '\'];
if strcmp(FluoType,'red')
    ImageFolder = [Folder 'RFP\'];
    initial_pos = load([PosFolder 'RFP_Map.txt']);
    image_seq = sync_struc_data.rfp_seq;
elseif strcmp(FluoType,'green')  
    ImageFolder = [Folder 'GCaMP\'];
    initial_pos = load([PosFolder 'GCaMP_Map.txt']);
    image_seq = sync_struc_data.gcamp_seq;
end
image_time = image_seq.image_time;
prefix = image_seq.image_name_prefix;

Tracking_Length = length(frame_seq);
neuron_pos = zeros(Tracking_Length,2);
neuron_pos(1,:) = initial_pos(:);

% Load anchor position
anchor_pos = load([PosFolder, sprintf('neuron %02d',anchor_index), '.txt']);
anchor_offset = frame_seq(1) - anchor_start;

% The first neuron position is known, locally search in the following frames.
neuron_I_thre = 400;
updated_pos = zeros(8,2);
for n = 2:Tracking_Length
    frame_index = frame_seq(n);
    Wimage_name = [ImageFolder prefix num2str(image_time(frame_index)) image_format];
    Wimage = imread(Wimage_name);
    
    % Repeat several times to make search stable
    gross_pos = neuron_pos(n-1,:) + (anchor_pos(n+anchor_offset,:)-anchor_pos(n+anchor_offset-1,:));
    [updated_pos(1,:),~,~] = UpdateNeuronData(gross_pos, search_interval, 1, Wimage);
    [updated_pos(2,:),neuron_I,background] = UpdateNeuronData(updated_pos(1,:), search_interval-3, intensity_ratio, Wimage);
 
    k = 2;
    neuron_pos(n,1) = updated_pos(k,1);
    neuron_pos(n,2) = updated_pos(k,2);

    % restriction: intensity, neuron/non-neuron-intensity ratio
    I_ratio = background/neuron_I;
    if neuron_I < 0.8*neuron_I_thre && I_ratio > Backgroun_Neuron_Ratio
        disp(['Frame ',num2str(frame_index),'(start from Frame ',num2str(frame_seq(1)),')','  Cannot find the right neuron. Please label by hand.']);
        Succeded_Tracking_Length = n - 1;
        break;
    else
        disp(['neuron pos ' num2str(frame_index) '  Ax = ',num2str(neuron_pos(n,1)) ' Ay = ',num2str(neuron_pos(n,2))]);
        Succeded_Tracking_Length = n;
        neuron_I_thre = neuron_I;
    end
end
neuron_pos = neuron_pos(1:Succeded_Tracking_Length,:);

% Write all neuron positions into file
write_neuronpos(PosFolder,track_index,neuron_pos(:,1),neuron_pos(:,2),'a');
end
        