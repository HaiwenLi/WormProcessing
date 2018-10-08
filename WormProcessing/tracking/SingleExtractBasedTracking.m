 function SingleExtractBasedTracking(frame_list,initial_pos,anchor_output_index,anchor_start,FluoType,imgFolder,posFolder) 
% Track single neuron
% Input:
% ImageFolder: folder contains worm fluorescene images
% frame_list: tracking range
% initial_pos: neuron posiiton in the initial frame
% output_name: tracked neuron position filename

% coordinate [x,y]

% Tracking Parameters Setting
search_interval = 10;
intensity_ratio = 0.3;
I_ratio_thre = 1.5;

if strcmp(FluoType,'red')
    ImageFolder = [imgFolder,'\RFP\'];
    NeuronFolder = [imgFolder,'\RFP_Neuron\'];
elseif strcmp(FluoType,'green')
    ImageFolder = [imgFolder,'\GCaMP\'];
    NeuronFolder = [imgFolder,'\GCaMP_Neuron\'];
end

anchor_index = anchor_output_index(1);
output_index = anchor_output_index(2);

PosFolder = [posFolder,FluoType,'\'];

WormImages = dir([ImageFolder,'*.tiff']);
Tracking_Length = length(frame_list);
neuron_pos = zeros(Tracking_Length,2);
Wimage_int = imread([ImageFolder WormImages(frame_list(1)).name]);
% [initial_pos(1),initial_pos(2)] = update_center(initial_pos(1),initial_pos(2),search_interval-6,intensity_ratio,Wimage_int);
neuron_pos(1,:) = initial_pos(:);


% Load anchor position
if anchor_index<10
    anchor_pos = load([PosFolder,'neuron 0',num2str(anchor_index),'.txt']);
else
    anchor_pos = load([PosFolder,'neuron ',num2str(anchor_index),'.txt']);
end
anchor_offset = frame_list(1) - anchor_start;

% The first neuron position is known, locally search in the following frames.
Ax_tempt = nan(1,20); Ay_tempt = nan(1,20);
last_anchor_vector = initial_pos-anchor_pos(1+anchor_offset,:);
last_anchor_dist = sqrt(sum(last_anchor_vector.^2));

[neuron_I_last,~] = GetRegionI(Wimage_int,initial_pos,search_interval/2,intensity_ratio);



for n = 2:Tracking_Length
    frame_index = frame_list(n);
    Wimage_name = [ImageFolder WormImages(frame_index).name];
    Wimage = imread(Wimage_name);
    
%     offset_dist = sqrt(sum((anchor_pos(n+anchor_offset,:)-anchor_pos(n+anchor_offset-1,:)).^2));

    gross_pos = neuron_pos(n-1,:) + (anchor_pos(n+anchor_offset,:)-anchor_pos(n+anchor_offset-1,:));
  

    extracted_neurons = load([NeuronFolder, WormImages(frame_index).name '.mat']);

    extracted_pos = [extracted_neurons.neurons(:,2),extracted_neurons.neurons(:,1)];       % [x,y]
    extracted_num = length(extracted_pos(:,1));
    
    % restriction: direction, anchor_dist, neuron_offset, intensity
    directions = zeros(extracted_num,1);
    neuron_I = zeros(extracted_num,1);
    
    for i = 1:extracted_num
        [extracted_pos(i,1),extracted_pos(i,2)] = update_center(extracted_pos(i,1),extracted_pos(i,2),search_interval-4,intensity_ratio,Wimage);
        directions(i) = dot((extracted_pos(i,:)-anchor_pos(n+anchor_offset,:)),last_anchor_vector);
        [neuron_I(i),~] = GetRegionI(Wimage,extracted_pos(i,:),search_interval/2,intensity_ratio);
    end
    
    anchor_dist = sqrt(sum((extracted_pos-anchor_pos(n+anchor_offset,:)).^2,2));
    neuron_offset = sqrt(sum((extracted_pos-gross_pos).^2,2));
    
    % extract-based restriction parameters
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
    
    I_thre = neuron_I_last/2;
    
    extracted_index = find(directions>0 & abs(anchor_dist-last_anchor_dist)<anchor_dist_thre & anchor_dist>search_interval-3 & neuron_offset<offset_thre & neuron_I>I_thre);
    
    if ~isempty(extracted_index)
        extracted_index = extracted_index(anchor_dist(extracted_index) == min(anchor_dist(extracted_index)));
        neuron_pos(n,:) = extracted_pos(extracted_index(1),:);
        Succeded_Tracking_Length = n;
        current_anchor_vector = neuron_pos(n,:)-anchor_pos(n+anchor_offset,:);
        current_anchor_dist = sqrt(sum(current_anchor_vector.^2));

    else   % cannot find the right neuron in extracted neurons, begin local search    
        
        search_interval_local = search_interval*0.5;
        
        Gx = zeros(1,search_interval_local*search_interval_local);
        Gy = zeros(1,search_interval_local*search_interval_local);
        Ic = zeros(1,search_interval_local*search_interval_local);
        k = 0; 
        
         for x = (gross_pos(1)-search_interval_local) :  (gross_pos(1)+search_interval_local)
            for y = (gross_pos(2)-search_interval_local) :  (gross_pos(2)+search_interval_local)
                if (x-gross_pos(1))^2 + (y-gross_pos(2))^2<=search_interval_local^2
                    k = k+1;
                    Gx(k) = x;
                    Gy(k) = y;
                    Ic(k) = Wimage(int32(y),int32(x));
                end
            end
         end
         
         k = find(Ic==max(Ic)); 
        
        % Repeat several times to make search stable
%         if strcmp(FlouType,'red')
%             [Ax_tempt(1),Ay_tempt(1)] = update_center(mean(Gx(k)), mean(Gy(k)),search_interval-3,intensity_ratio,Wimage);
%             [Ax_tempt(2),Ay_tempt(2)] = update_center(Ax_tempt(1),Ay_tempt(1),search_interval-5,intensity_ratio,Wimage);
%         elseif strcmp(FlouType,'green')
            [Ax_tempt(2),Ay_tempt(2)] = update_center(mean(Gx(k)), mean(Gy(k)),search_interval-5,intensity_ratio,Wimage);
%         end
        
        current_anchor_vector = [Ax_tempt(2),Ay_tempt(2)]-anchor_pos(n+anchor_offset,:);
        current_anchor_dist = sqrt(sum(current_anchor_vector.^2));
        [neuron_I_local,I_ratio_local] = GetRegionI(Wimage,[Ax_tempt(2),Ay_tempt(2)],search_interval/2,intensity_ratio);

        % local search restriction: intensity, neuron/non-neuron-intensity
        % ratio, direction, anchor_dist
        if abs(current_anchor_dist-last_anchor_dist) > anchor_dist_thre+3|| dot(current_anchor_vector,last_anchor_vector)<0||current_anchor_dist<(search_interval-3)||(neuron_I_local<400 && I_ratio_local<I_ratio_thre)
             disp(['Frame ',num2str(frame_index),'(start from Frame ',num2str(frame_list(1)),')','  Cannot find the right neuron. Please label by hand.']);
             Succeded_Tracking_Length = n-1;
            break;
        else
            neuron_pos(n,1) = Ax_tempt(2);
            neuron_pos(n,2) = Ay_tempt(2);
            Succeded_Tracking_Length = n;
        end
    end
   
    last_anchor_dist = current_anchor_dist;
    last_anchor_vector = current_anchor_vector;
    
    
    disp(['neuron pos ' num2str(frame_index) '/' num2str(frame_list(end)) '  Ax = ',num2str(neuron_pos(n,1)) ' Ay = ',num2str(neuron_pos(n,2)),'    anchor_dist = ',num2str(current_anchor_dist)]);
end

% Write all neuron positions into file
if output_index<10
    output_name = [PosFolder,'neuron 0',num2str(output_index),'.txt'];
else
    output_name = [PosFolder,'neuron ',num2str(output_index),'.txt'];
end
fid = fopen(output_name,'a');  
for i = 1:Succeded_Tracking_Length
    fprintf(fid,'%d    %d\n',neuron_pos(i,1),neuron_pos(i,2));
end
fclose(fid);

if Succeded_Tracking_Length == length(frame_list)
   disp(['neuron ',num2str(output_index),'  All Done'])
end

end
        
