 function TrackSingleNeuron_Extraction(Folder,anchor_output_index,anchor_start,frame_list,FluoType,params,track_mode) 
% Track single neuron. Comparing with the extracted neurons and track the neuron.
%
% Input parameters:
% ImageFolder: folder contains worm fluorescene images
% frame_list: tracking range
% track_mode: 'update' or 'create'(by default)
% 

% Tracking Parameters Setting
if nargin == 5
    track_mode = 'create';
    search_interval = 10;
    intensity_ratio = 0.3;
elseif nargin == 6
    track_mode = 'create';
elseif nargin < 5
    disp('Invalid function call');
    return;
end

if nargin >= 6
    search_interval = params(2);
    intensity_ratio = params(3);
end

I_ratio_thre = 1.5;
image_format = '.tiff';

% get anchor and neuron index
anchor_index = anchor_output_index(1);
output_index = anchor_output_index(2);

% load data synchronous structure and set folders
sync_struc_data = load([Folder 'sync_struc.mat']);
PosFolder = [Folder 'neuron_pos\' FluoType,'\'];
if strcmp(FluoType,'red')==1
    ImageFolder = [Folder,'RFP\'];
    NeuronFolder = [Folder,'RFP_Neuron\'];
    image_seq = sync_struc_data.rfp_seq;
    initial_pos = load([PosFolder 'RFP_Map.txt']);
elseif strcmp(FluoType,'green')
    ImageFolder = [Folder,'GCaMP\'];
    NeuronFolder = [Folder,'GCaMP_Neuron\'];
    image_seq = sync_struc_data.gcamp_seq;
    initial_pos = load([PosFolder 'GCaMP_Map.txt']);
end
image_time = image_seq.image_time;
prefix = image_seq.image_name_prefix;
neuron_pos_filename = [PosFolder sprintf('neuron %02d',output_index) '.txt'];

Tracking_Length = length(frame_list);
neuron_pos = zeros(Tracking_Length,2);
Wimage_int = imread([ImageFolder prefix num2str(image_time(frame_list(1))) image_format]);
neuron_pos(1,:) = initial_pos;
Succeded_Tracking_Length = 1;

% Load anchor position
anchor_pos = load([PosFolder sprintf('neuron %02d',anchor_index),'.txt']);
anchor_offset = frame_list(1) - anchor_start;

% The first neuron position is known, locally search in the following frames
updated_pos = zeros(8,2);
last_anchor_vector = initial_pos-anchor_pos(1+anchor_offset,:);
last_anchor_dist = sqrt(sum(last_anchor_vector.^2));
[neuron_I_last,~] = GetNeuronIntensity(Wimage_int,initial_pos,search_interval/2,intensity_ratio);

for n = 2:Tracking_Length
    frame_index = frame_list(n);
    Wimage_name = [prefix num2str(image_time(frame_index)) image_format];
    Wimage = imread([ImageFolder Wimage_name]);
    
    gross_pos = neuron_pos(n-1,:) + (anchor_pos(n+anchor_offset,:)-anchor_pos(n+anchor_offset-1,:));
    extracted_neurons = load([NeuronFolder Wimage_name '.mat']);
    extracted_pos = [extracted_neurons.neurons(:,2),extracted_neurons.neurons(:,1)];% [x,y]
    extracted_num = length(extracted_pos(:,1));
    
    % restriction: direction, anchor_dist, neuron_offset, intensity
    directions = zeros(extracted_num,1);
    neuron_I = zeros(extracted_num,1);
    
    for i = 1:extracted_num
        [extracted_pos(i,:),neuron_I(i),~] = UpdateNeuronData(extracted_pos(i,:),search_interval-5, intensity_ratio, Wimage);
        directions(i) = dot((extracted_pos(i,:) - anchor_pos(n + anchor_offset,:)), last_anchor_vector);
    end
    
    anchor_dist = sqrt(sum((extracted_pos-anchor_pos(n+anchor_offset,:)).^2,2));
    neuron_offset = sqrt(sum((extracted_pos-gross_pos).^2,2));
    
    % extract-based restriction parameters [Careful, for different worm, those parameters may be not proper!]
    if last_anchor_dist>20
        offset_thre = last_anchor_dist/2;
    else
        offset_thre = 15;
    end

    if last_anchor_dist>100
        anchor_dist_thre = last_anchor_dist/7.5;
    else
        anchor_dist_thre = 20;
    end

    % search desire extraxcted neuron or use local search to find possible neuron
    I_thre = neuron_I_last/2;
    extracted_index = find(...
        directions > 0 & ...
        abs(anchor_dist-last_anchor_dist) < anchor_dist_thre &...
        anchor_dist > search_interval-3 & ...
        neuron_offset < offset_thre & ...
        neuron_I > I_thre);
    
    if ~isempty(extracted_index)
        extracted_index = extracted_index(anchor_dist(extracted_index) == min(anchor_dist(extracted_index)));
        neuron_pos(n,:) = extracted_pos(extracted_index(1),:);
        Succeded_Tracking_Length = n;
        current_anchor_vector = neuron_pos(n,:)-anchor_pos(n+anchor_offset,:);
        current_anchor_dist = sqrt(sum(current_anchor_vector.^2));

    else % cannot find the right neuron in extracted neurons, begin local search    
        search_interval_local = search_interval*0.5;
        [updated_pos(1,:),~,~] = UpdateNeuronData(gross_pos, search_interval_local, 1, Wimage);
        
        current_anchor_vector = [updated_pos(1,1), updated_pos(1,2)] - anchor_pos(n+anchor_offset,:);
        current_anchor_dist = sqrt(sum(current_anchor_vector.^2));
        [neuron_I_local,I_ratio_local] = GetNeuronIntensity(Wimage,[updated_pos(1,1),updated_pos(1,2)],search_interval/2,intensity_ratio);

        % local search restriction: intensity, neuron/non-neuron-intensity
        % ratio, direction, anchor_dist
        if abs(current_anchor_dist-last_anchor_dist) > anchor_dist_thre+3 ||...
               dot(current_anchor_vector,last_anchor_vector)<0 || ...
               current_anchor_dist<(search_interval-3) || ...
               (neuron_I_local<400 && ...
               I_ratio_local<I_ratio_thre)
             % found the neuron
             disp(['Frame ',num2str(frame_index),'(start from Frame ',num2str(frame_list(1)),')',...
                 '  Cannot find the right neuron. Please label by hand.']);
             Succeded_Tracking_Length = n-1;
             break;
        else
            neuron_pos(n,1) = updated_pos(1,1);
            neuron_pos(n,2) = updated_pos(1,2);
            Succeded_Tracking_Length = n;
        end
    end
   
    last_anchor_dist = current_anchor_dist;
    last_anchor_vector = current_anchor_vector;
    
    disp(['neuron pos ' num2str(frame_index) '/' num2str(frame_list(end)) ...
        '  Ax = ',num2str(neuron_pos(n,1)) ' Ay = ',num2str(neuron_pos(n,2)),'    anchor_dist = ',num2str(current_anchor_dist)]);
end

% Write all neuron positions into file
if strcmp(track_mode,'update')==1
    % load updated neuron position
    updated_neuron_pos = load(neuron_pos_filename);

    % update last neuron position
    updated_neuron_pos(frame_list(1:Succeded_Tracking_Length)-anchor_start+1,:) = neuron_pos(1:Succeded_Tracking_Length,:);
    write_neuronpos(PosFolder,output_index,updated_neuron_pos(:,1),updated_neuron_pos(:,2),'w');
elseif strcmp(track_mode,'create')==1
    write_neuronpos(PosFolder,output_index,neuron_pos(1:Succeded_Tracking_Length,1),neuron_pos(1:Succeded_Tracking_Length,2),'a');  
end

if Succeded_Tracking_Length == length(frame_list)
   disp('All Done');
end

end
        
