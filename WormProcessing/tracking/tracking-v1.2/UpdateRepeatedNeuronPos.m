function UpdateRepeatedNeuronPos(Folder,tracking_index,anchor_index,FlouType,origin_start,frame_seq,params)
% Repeat the neuron position for the length of frame_seq times
% neuron pos format: [x,y]

% Parameters
if nargin == 6
    UPDATE_NUM = 1;
    Search_Interval = 4;
    Intensity_Ratio = 0.5;
elseif nargin > 6
    UPDATE_NUM = params(1);
    Search_Interval = params(2);
    Intensity_Ratio = params(3);
end

% Set pos folder
posFolder = [Folder 'neuron_pos\',FlouType, '\'];
if strcmp(FlouType,'red')
    ImgFolder = [Folder 'RFP\'];
    neurons_pos = load([posFolder,'\RFP_Map.txt']);
elseif strcmp(FlouType,'green')
    ImgFolder = [Folder 'GCaMP\'];
    neurons_pos = load([posFolder,'\GCaMP_Map.txt']);
end

if ~isnan(anchor_index) && ~isempty(anchor_index)
    anchor_name = [posFolder sprintf('neuron %02d',anchor_index),'.txt'];
    anchor_pos = load(anchor_name);
else
    anchor_pos = zeros(frame_seq(end)-origin_start+1,2);
end
anchor_offset = frame_seq(1)-origin_start;

% Get image time and image names
seq = GetImageSeq(ImgFolder, '.tiff');
image_time = seq.image_time;
prefix = seq.image_name_prefix;

neuron_num = length(tracking_index);
if neuron_num ~= length(neurons_pos(:,1))
    disp('Neuron number error');
    return
end

Tracking_Length = length(frame_seq);
Neuorns_PosX = zeros(Tracking_Length, neuron_num);
Neuorns_PosY = zeros(Tracking_Length, neuron_num);

for j = 1:Tracking_Length
    for i=1:neuron_num
        if j==1
            Neuorns_PosX(j,i) = neurons_pos(i,1);
            Neuorns_PosY(j,i) = neurons_pos(i,2);
            continue;
        end
        
        % update neuron positions
        if mod(j,UPDATE_NUM) == 0
            img_name = [ImgFolder prefix num2str(image_time(frame_seq(j))) '.tiff'];
            wimage = imread(img_name);
            
            x = Neuorns_PosX(j-1,i) + (anchor_pos(j+anchor_offset,1)-anchor_pos(j+anchor_offset-1,1));
            y = Neuorns_PosY(j-1,i) + (anchor_pos(j+anchor_offset,2)-anchor_pos(j+anchor_offset-1,2));
            [newpos,~,~] = UpdateNeuronData([x,y],Search_Interval,Intensity_Ratio,wimage);
            Neuorns_PosX(j,i) = newpos(1);
            Neuorns_PosY(j,i) = newpos(2);
        else
            Neuorns_PosX(j,i) = Neuorns_PosX(j-1,i);
            Neuorns_PosY(j,i) = Neuorns_PosY(j-1,i);
        end
                
        disp(['Processed ' num2str(frame_seq(j)) ':  neuron ',num2str(tracking_index(i))]);
    end
end

% 需要注意：此时所有的神经元位置已经得到，不能采用添加方式写文档，而是直接读取文档
% 修改相关数据
for i=1:neuron_num
    output_name = [posFolder sprintf('neuron %02d',tracking_index(i)),'.txt'];
    if exist(output_name,'file')
        origin_neurons_pos = load(output_name);
        pos_start = frame_seq(1)-origin_start+1;
        pos_end = frame_seq(end)-origin_start+1;
        origin_neurons_pos(pos_start:pos_end,1) = Neuorns_PosX(:,i);
        origin_neurons_pos(pos_start:pos_end,2) = Neuorns_PosY(:,i);
    else
        origin_neurons_pos = zeros(size(Neuorns_PosX,1),2);
        origin_neurons_pos(:,1) = Neuorns_PosX(:,i);
        origin_neurons_pos(:,2) = Neuorns_PosY(:,i);
    end
    
    fid = fopen(output_name,'wt');
    for j=1:size(origin_neurons_pos,1)
        fprintf(fid,'%d    %d\n',origin_neurons_pos(j,1),origin_neurons_pos(j,2));
    end
    fclose(fid);
end

end