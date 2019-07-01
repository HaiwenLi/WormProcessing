function GetNeuronActivityInChannel(Folder,channel,frame_seq)
% Calculate calcium transient of neurons

image_format = '.tiff';
Update_Center = 0;

if strcmp(channel,'red') == 1
    Image_Folder = [Folder 'RFP\'];
    NeuronPos_File = [Folder 'neuron_pos\red.txt'];
elseif strcmp(channel, 'green') == 1
    Image_Folder = [Folder 'GCaMP\'];
    NeuronPos_File = [Folder 'neuron_pos\green.txt'];
end
image_seq = GetImageSeq(Image_Folder,image_format);
image_time = image_seq.image_time;
prefix = image_seq.image_name_prefix;

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(match_index);
end

% Load neuron positions from the file
Neuoron_Pos_Folder = [Folder 'neuron_pos\'];
Neuron_Pos = load(NeuronPos_File);
neuron_radius = load([Neuoron_Pos_Folder 'neuron_radius.txt']);
Neuron_Num = length(neuron_radius);
disp('Load neuron positions, starting to extract neuron acticity');

neuron_names = ReadNeuronNames([Folder 'neuron_pos\neuron_name.txt'],Neuron_Num);
activities = zeros(Neuron_Num, length(frame_seq));

intensity_ratio = 1;
total_num = length(frame_seq);
for i=1:length(frame_seq)
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);

    image_index = frame_seq(i);
    worm_img = imread([Image_Folder prefix num2str(image_time(image_index)) image_format]);
    neuron_centers = Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:);
    
    % update neuron position and extract neuron activity
    for j=1:Neuron_Num
        if neuron_centers(j,1) > 0 && neuron_centers(j,2) > 0
            [neuron_centers(j,1),neuron_centers(j,2)] = UpdateNeuronPos(neuron_centers(j,1), neuron_centers(j,2), neuron_radius(j), 0.5, worm_img);
            [activities(j,i), ~] = ExtractFluoEnergyAndBackground(worm_img,neuron_centers(j,:),neuron_radius(j),intensity_ratio);
        else
            activities(j,i) = nan;
        end
    end

    Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:) = neuron_centers; % save updated neuron positions
end

% rewrite the data into file
if strcmp(channel,'red') == 1
    filename = [Folder 'neuron_pos\updated_red.txt'];
elseif strcmp(channel, 'green') == 1
    filename = [Folder 'neuron_pos\updated_green.txt'];
end

fid = fopen(filename,'wt+');
for i = 1:size(Neuron_Pos,1)
    fprintf(fid,'%d    %d\n',Neuron_Pos(i,1),Neuron_Pos(i,2));
end
fclose(fid);
        
% Save the neuron activities
save([Folder 'neuron_pos\Neuron_Activity.mat'],'activities','neuron_names');

end