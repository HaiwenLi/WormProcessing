function NeuronPosRepeat(tracking_index,Folder,FlouType,frame_seq)
% Repeat the neuron position for the length of frame_seq times
% neuron pos format: [x,y]

% Parameters
UPDATE_NUM = 5;
Search_Interval = 10;
Intensity_Ratio = 0.35;

% Set pos folder
posFolder = [Folder 'neuron_pos\'];
if strcmp(FlouType,'red')
    ImgFolder = [Folder 'RFP\'];
    neurons_pos = load([posFolder,FlouType,'\RFP_Map.txt']);
elseif strcmp(FlouType,'green')
    ImgFolder = [Folder 'GCaMP\'];
    neurons_pos = load([posFolder,FlouType,'\GCaMP_Map.txt']);
end

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
            [x,y] = UpdateNeuronPos(Neuorns_PosX(j-1,i),Neuorns_PosY(j-1,i),Search_Interval,...
              Intensity_Ratio,wimage); 
            [x,y] = UpdateNeuronPos(x,y,Search_Interval-3,Intensity_Ratio,wimage);  
            Neuorns_PosX(j,i) = x;
            Neuorns_PosY(j,i) = y;
        else
            Neuorns_PosX(j,i) = Neuorns_PosX(j-1,i);
            Neuorns_PosY(j,i) = Neuorns_PosY(j-1,i);
        end
                
        disp(['Processed ' num2str(frame_seq(j)) ':  neuron ',num2str(tracking_index(i))]);
    end
end

for i=1:neuron_num
    if tracking_index(i)>9
        output_name = [posFolder,FlouType,'\neuron ',num2str(tracking_index(i)),'.txt'];
    else
        output_name = [posFolder,FlouType,'\neuron 0',num2str(tracking_index(i)),'.txt'];
    end

    fid = fopen(output_name,'a');
    for j=1:Tracking_Length
        fprintf(fid,'%d    %d\n',Neuorns_PosX(j,i),Neuorns_PosY(j,i));
    end
    fclose(fid);
end

end