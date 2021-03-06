function GroupExtractBasedTracking(frame_seq,Folder,posFolder)

field1 = 'extracted_index';
field2 = 'neuron_index';
field3 = 'layer_index';
field4 = 'dist';
field5 = 'ref_index';
value1 = zeros(1);
value2 = zeros(1);
value3 = zeros(1);
value4 = {zeros(1)};
value5 = {zeros(1)};
Neuron_pair = struct(field4,value4,field5,value5);  % dist,ref_index

Stack_node = struct(field1,value1,field2,value2,field3,value3);  % extracted_index,neuron_index,layer_index
Neuron_stack = struct('node',Stack_node);  % layer_num, node. layer_num+1 layers in fact
layer_num = 0;

offset_thre = 100;
intensity_ratio = 0.3;
neuron_radius = 5;
I_ratio_thre = 0.5;

Neuron_Folder = [Folder 'Neuron'];
if ~exist(Neuron_Folder,'dir')
    disp('No Neuron Folder');
    return;
end

Image_Folder = [Folder 'RFP\'];
image_names = dir([Image_Folder '*.tiff']);
image_num = length(frame_seq);

%     Int_pos = load([posFolder,image_names(frame_seq(1)).name(1:length(image_names(1).name)-4),'txt']);
Int_pos = load([posFolder,'RFP.txt']);
neuron_num = length(Int_pos(:,1));
neuron_pos_last = Int_pos;
worm_image = imread([Image_Folder image_names(frame_seq(1)).name]);

Tracking_Length = length(frame_seq);
neuron_pos = zeros(Tracking_Length,2);
neuron_pos(1:neuron_num,:) = Int_pos;
output_name = [posFolder,'neuron_pos.txt'];

ref_list = GetRefList(neuron_pos_last);              % first frame, vol_1: distance, vol_2: error, head to tail

neuron_I = zeros(1,neuron_num);
for i = 1:neuron_num
    [neuron_I(i),~] = GetRegionI(worm_image,Int_pos(i,:),neuron_radius,intensity_ratio);
end

for t=2:image_num
    image_index = frame_seq(t);
    worm_image = imread([Image_Folder image_names(image_index).name]);
    
    neuron_dataname = [Neuron_Folder '\' image_names(image_index).name '.mat'];
    neuron_data = load(neuron_dataname);  
    extracted_pos = [neuron_data.neurons(:,2),neuron_data.neurons(:,1)];       % [x,y]

    extracted_num = length(extracted_pos(:,1));
    sign = zeros(1,extracted_num);

    neuron_offset = zeros(neuron_num,extracted_num);
    extracted_I = zeros(1,extracted_num);
    for i = 1:extracted_num
        neuron_offset(:,i) = sqrt(sum((neuron_pos_last - extracted_pos(i,:)).^2,2));
        [extracted_I(i),~] = GetRegionI(worm_image,extracted_pos(i,:),neuron_radius,intensity_ratio);
    end
       
    
    neuron_search = zeros(neuron_num,extracted_num);
    for i = 1:neuron_num
        neuron_search(i,1:length(find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i)))) = ...
            find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i));
        
%             temp1 =  find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i);
%             offset_sort = sort(neuron_offset(i,temp1),'descend');
%             temp2 = 
    end
    
    Neuron_pair = struct(field4,value4,field5,value5);  % initialize
    for i = 1:extracted_num       % i = neuron, j = neuron_next
        for j = 1:extracted_num 
            vector = extracted_pos(i,:)-extracted_pos(j,:);
            Neuron_pair(i,j).dist = sqrt(sum(vector.^2));
            direction = zeros(neuron_num-1,1);
            for k = 1:neuron_num-1
                direction(k) = dot(vector,ref_list(k,3:4));
            end
            
            if ~isempty(find(abs(ref_list(:,1)-Neuron_pair(i,j).dist)<ref_list(:,2) & direction>0, 1))
                 Neuron_pair(i,j).ref_index = find(abs(ref_list(:,1)-Neuron_pair(i,j).dist)<ref_list(:,2));
            end
        end
    end
    
    
   Neuron_stack = struct('node',Stack_node); 
    for i = 1:length(find(neuron_search(1,:)>0))
        Stack_node.neuron_index = 1;
        Stack_node.extracted_index = neuron_search(1,i);
        [Neuron_stack,layer_num] = StackIn(Neuron_stack,Stack_node,layer_num);
    end
               
    if layer_num == 0             
        disp(['frame: ', num2str(image_index),' Cannot find the right path. Please label by hand.']);
        Tracking_Length = (t-1)*neuron_num;
        break;
    end
    
    top = topStack(Neuron_stack,layer_num);
    sign(top.extracted_index) = 1;
    current_layer_num = layer_num;
    current_neuron_index = top.neuron_index;
    while top.neuron_index<neuron_num  
        possible = find(neuron_search(top.neuron_index+1,:)>0);
        possible = possible(sign(neuron_search(top.neuron_index+1,possible))==0);
        
        if ~isempty(possible)
            for j = 1:length(possible)
                if ~isempty(find(Neuron_pair(top.extracted_index,neuron_search(top.neuron_index+1,possible(j))).ref_index == top.neuron_index, 1))
                    Stack_node.neuron_index = top.neuron_index+1;
                    Stack_node.extracted_index = neuron_search(top.neuron_index+1,possible(j));
                   [Neuron_stack,layer_num] = StackIn(Neuron_stack,Stack_node,layer_num);
                end
            end
        end
        

        
        if layer_num == current_layer_num  % nothing added to stack
            [sign,Neuron_stack,layer_num] = StackOut(Neuron_stack,layer_num,sign);
            
                top = topStack(Neuron_stack,layer_num);
                while current_neuron_index ~= top.neuron_index && layer_num>0
                    current_neuron_index = top.neuron_index;
                    [sign,Neuron_stack,layer_num] = StackOut(Neuron_stack,layer_num,sign);
                    top = topStack(Neuron_stack,layer_num);
                end
            
                if layer_num == 0
                    break;
                end
                    
        end        
        
%             if top.neuron_index < current_neuron
            
        top = topStack(Neuron_stack,layer_num);
        sign(top.extracted_index) = 1;
        current_layer_num = layer_num;
        current_neuron_index = top.neuron_index;
    end
    
    if layer_num == 0             
        disp(['frame: ', num2str(image_index),' Cannot find the right path. Please label by hand.']);
        Tracking_Length = (t-1)*neuron_num;
        break;
    end
    
    top = topStack(Neuron_stack,layer_num);
    for k = neuron_num:(-1):2
        neuron_pos((t-1)*neuron_num+k,:) = extracted_pos(top.extracted_index,:);
        neuron_pos_last(k,:) = extracted_pos(top.extracted_index,:);
        [neuron_I(k),~] = GetRegionI(worm_image,neuron_pos_last(k,:),neuron_radius,intensity_ratio);
        [sign,Neuron_stack,layer_num] = StackOut(Neuron_stack,layer_num,sign);
        
        top = topStack(Neuron_stack,layer_num);
        while top.neuron_index == k
            [sign,Neuron_stack,layer_num] = StackOut(Neuron_stack,layer_num,sign);
            top = topStack(Neuron_stack,layer_num);
        end
    end
    neuron_pos((t-1)*neuron_num+1,:) = extracted_pos(top.extracted_index,:);
    neuron_pos_last(1,:) = extracted_pos(top.extracted_index,:);
    [neuron_I(1),~] = GetRegionI(worm_image,neuron_pos_last(1,:),neuron_radius,intensity_ratio);
    
    disp(['Succeed:  frame ',num2str(image_index)]);
    
    Tracking_Length = t*neuron_num;
    
    ref_list = GetRefList(neuron_pos_last); 
    layer_num = 0;

end

fid = fopen(output_name,'a');  
for i = 1:Tracking_Length
    fprintf(fid,'%d    %d\n',neuron_pos(i,1),neuron_pos(i,2));
end
fclose(fid);
    
end





