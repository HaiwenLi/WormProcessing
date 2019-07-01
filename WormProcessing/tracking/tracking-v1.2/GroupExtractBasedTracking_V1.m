function GroupExtractBasedTracking_V1(Folder,tracking_index,FluoType,frame_seq,stage_motion)
% Tracking neurons by neuron distance pair match

% set global parameters
global NeuronPath;
global path_num;
global used_flag;

% Tracking Parameters
offset_thre = 130;
intensity_ratio = 0.3;
neuron_radius = 5;
I_ratio_thre = 0.1;
search_interval = 6;
Max_Candidate_Num = 32;
Max_Path = 128;

if nargin == 4
    stage_motion = zeros(length(frame_seq),2);    
end

% Processing Folders
image_format = '.tiff';
sync_struc_data = load([Folder 'sync_struc.mat']);
if strcmp(FluoType,'red')
    Neuron_Folder = [Folder 'RFP_Neuron\'];
    image_seq = sync_struc_data.rfp_seq;
    %image_seq = GetImageSeq([Folder 'RFP_Map\'],image_format);
    if nargin == 5 %if porviding stage position
        stage_motion = stage_motion(ConvertRedIndex2Green(sync_struc_data.sync_struc,frame_seq),:);
    end
elseif strcmp(FluoType,'green')  
    Neuron_Folder = [Folder 'GCaMP_Neuron\'];
    image_seq = sync_struc_data.gcamp_seq;
    if nargin == 5 %if porviding stage position
        stage_motion = stage_motion(frame_seq(1):frame_seq(end),:);
    end
end
posFolder = [Folder 'neuron_pos\' FluoType '\'];

if ~exist(Neuron_Folder,'dir')
    disp('No Neuron Folder');
    return;
end

if strcmp(FluoType,'red')
    Image_Folder = [Folder 'RFP\'];
    Int_pos = load([posFolder,'RFP_Map.txt']);
elseif strcmp(FluoType,'green')
    Image_Folder = [Folder 'GCaMP\'];
    Int_pos = load([posFolder,'GCaMP_Map.txt']);
end

% image_seq = GetImageSeq(Image_Folder,image_format); % use GetImageSeq to get sequential image names
image_time = image_seq.image_time;
image_prefix = image_seq.image_name_prefix;
image_num = length(frame_seq);
Tracking_Length = length(frame_seq);

% Load initial neuron positions
neuron_num = length(tracking_index);
neuron_pos = zeros(neuron_num*Tracking_Length,2); 
neuron_pos_last = zeros(neuron_num,2);

% check initial neuron positions
if mod(length(Int_pos),neuron_num) ~= 0
    disp('Input neuron positions are invalid');
    return;
end
Int_Image_Num = length(Int_pos)/neuron_num;
neuron_pos(1:length(Int_pos),:) = Int_pos(:,:);
neuron_pos_last(1:neuron_num,:) = Int_pos(((Int_Image_Num-1)*neuron_num+1):Int_Image_Num*neuron_num,:);

% update the last inputed position
worm_image = imread([Image_Folder image_prefix num2str(image_time(frame_seq(1))) image_format]);
for i =1:neuron_num
    [neuron_pos_last(i,1),neuron_pos_last(i,2)] = UpdateNeuronPos(Int_pos(i,1),Int_pos(i,2),search_interval,intensity_ratio,worm_image);
end

% Start tracking neurons
ref_list = GetRefList(neuron_pos_last);% first frame, vol_1: distance, vol_2: error, head to tail
neuron_I = zeros(1,neuron_num);
candidate_neuron = zeros(neuron_num,Max_Candidate_Num);

% Set global parameters
NeuronPath = zeros(Max_Path,neuron_num);

for i = 1:neuron_num
    [neuron_I(i),~] = GetNeuronIntensity(worm_image,Int_pos(i,:),neuron_radius,intensity_ratio);
end
for t=(Int_Image_Num+1):image_num
    image_index = frame_seq(t);
    image_name = [image_prefix num2str(image_time(image_index)) image_format];
    worm_image = imread([Image_Folder image_name]);

    neuron_dataname = [Neuron_Folder image_name '.mat'];
    neuron_data = load(neuron_dataname);  
    extracted_pos = [neuron_data.neurons(:,2),neuron_data.neurons(:,1)]; % convert to [x,y]
    extracted_num = length(extracted_pos(:,1));

    neuron_offset = zeros(neuron_num,extracted_num);
    extracted_I = zeros(1,extracted_num);
    for i = 1:extracted_num
        %[extracted_pos(i,1),extracted_pos(i,2)] = UpdateNeuronPos(extracted_pos(i,1),extracted_pos(i,2),search_interval-4,intensity_ratio,worm_image);
        neuron_offset(:,i) = sqrt(sum((neuron_pos_last - repmat(extracted_pos(i,:),neuron_num,1)).^2,2));
        [extracted_I(i),~] = GetNeuronIntensity(worm_image,extracted_pos(i,:),neuron_radius,intensity_ratio);
    end

    % find candidate neuron index
    candidate_neuron(:,:) = nan;
    for i = 1:neuron_num
        candidate_index = find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i));
        if ~isempty(candidate_index)
            candidate_neuron(i,1:length(candidate_index)) = candidate_index;
        end
    end

    % set Neuron_pair
    Neuron_pair = struct('dist',{},'ref_index',{});  % initialize
    for i = 1:extracted_num       % i = neuron, j = neuron_next          
        for j = 1:extracted_num
            if i == j
                Neuron_pair(i,j).ref_index = 0;
                Neuron_pair(i,j).ref_index = nan;
            else
                vector = extracted_pos(i,:)-extracted_pos(j,:);
                Neuron_pair(i,j).dist = sqrt(sum(vector.^2));
                direction = zeros(neuron_num-1,1);
                for k = 1:neuron_num-1
                    direction(k) = dot(vector,ref_list(k,3:4));
                end

                ref_index = find(abs(ref_list(:,1)-Neuron_pair(i,j).dist)<ref_list(:,2) & direction > -eps);
                if ~isempty(ref_index) && (Neuron_pair(i,j).dist > 0.75*neuron_radius)
                     Neuron_pair(i,j).ref_index = ref_index;
                else
                    Neuron_pair(i,j).ref_index = nan;
                end
            end
        end
    end
    
    % search candidate paths
    Stack_node = struct('neuron_index',nan,'extracted_index',nan);
    Neuron_stack = struct('nodes',Stack_node,'layer_num',0); 
    NeuronPath(:,:) = 0; path_num = 0;
    used_flag = zeros(1,extracted_num);
    
    for i = 1:length(find(candidate_neuron(1,:)>0))
        % intialize stack and the first node
        used_flag(:) = 0;
        Stack_node.neuron_index = 1;
        Stack_node.extracted_index = candidate_neuron(1,i);
        Neuron_stack.nodes(1) = Stack_node;
        Neuron_stack.layer_num = 1;
        used_flag(candidate_neuron(1,i)) = 1;
        
        % add to stack
        Neuron_stack = DeepSearch(candidate_neuron,Neuron_pair,Stack_node,Neuron_stack);% search candidate neurons from top
    end

    % find the most optimal path
    if path_num == 0
        % show image and extracted neurons
        figure;imagesc(worm_image);axis image;hold on;
        plot(extracted_pos(:,1), extracted_pos(:,2),'r.');
        title(['Frame ' num2str(image_index)]);
        hold off;
        
        disp(['frame: ', num2str(image_index),' Cannot find the right path. Please label by hand.']);
        Tracking_Length = (t-1)*neuron_num;
        break;
    elseif path_num == 1
        neuron_pos_last = extracted_pos(NeuronPath(1,:),:);
    elseif path_num > 1
        path_score = zeros(path_num,1);
        offset_sum = zeros(path_num,1);
             for i = 1:path_num
                 for j = 1:neuron_num-1
                    vector = extracted_pos(NeuronPath(i,j),:)-extracted_pos(NeuronPath(i,j+1),:); 
                    dist = Neuron_pair(NeuronPath(i,j),NeuronPath(i,j+1)).dist;
                    cos_theta =  dot(vector,ref_list(j,3:4))/dist/ref_list(j,1);
                    path_score(i) = path_score(i) + ((dist-ref_list(j,1))/ref_list(j,1))^2 + (1-cos_theta^2);
                 end
                 for j = 1:neuron_num
                     offset_sum(i) = offset_sum(i) + neuron_offset(j,NeuronPath(i,j));    
                 end
             end
         path_score = path_score + (offset_sum./max(offset_sum)/2).^2;
         temp = find(path_score == min(path_score));
         neuron_pos_last = extracted_pos(NeuronPath(temp(1),:),:); 
    end

     neuron_pos((t-1)*neuron_num+1:t*neuron_num,:) = neuron_pos_last;
     for i = 1:neuron_num
         [neuron_I(i),~] = GetNeuronIntensity(worm_image,neuron_pos_last(i,:),neuron_radius,intensity_ratio);
     end
    ref_list = GetRefList(neuron_pos_last); 
    Tracking_Length = t*neuron_num;

    disp(['Succeed:  frame ',num2str(image_index),'/',num2str(frame_seq(end))]);
end

if image_num == 1
    Tracking_Length = neuron_num;
end

% write into file
for i = 1:neuron_num
    output_name = [posFolder,sprintf('neuron %02d',tracking_index(i)),'.txt'];    
    fid = fopen(output_name,'a');  
    for j = 1:Tracking_Length/neuron_num
        fprintf(fid,'%d    %d\n',neuron_pos(neuron_num*(j-1)+i,1),neuron_pos(neuron_num*(j-1)+i,2));
    end
    fclose(fid);
end

if Tracking_Length/neuron_num == length(frame_seq)
    disp('All Done');
end
  
end

function output_stack(stack)
% output stack data for debuging
disp('---------- stack ----------');
for i=1:length(stack.nodes)
    disp(['neuron index: ' num2str(stack.nodes(i).neuron_index) ', extracted index: ' num2str(stack.nodes(i).extracted_index)]);
end
end