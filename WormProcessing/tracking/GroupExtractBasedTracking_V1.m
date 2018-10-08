 function GroupExtractBasedTracking_V1(frame_seq,tracking_index,FlouType,Folder,posFolder)
    field1 = 'extracted_index';
    field2 = 'neuron_index';
    field3 = 'cos_theta';
    field4 = 'dist';
    field5 = 'ref_index';
    value1 = zeros(1);
    value2 = zeros(1);
    value3 = zeros(1);
    value4 = {zeros(1)};
    value5 = {zeros(1)};


    
%     Stack_node = struct(field1,value1,field2,value2);  % extracted_index,neuron_index,layer_index
%     Neuron_stack = struct('node',Stack_node,'layer_num',0);  % layer_num, node. layer_num+1 layers in fact
%     Neuron_pair = struct(field4,value4,field5,value5);  % dist,ref_index
    
    offset_thre = 100;
    intensity_ratio = 0.3;
    neuron_radius = 5;
    I_ratio_thre = 0.3;
    search_interval = 10;
    
    if strcmp(FlouType,'red')
        Neuron_Folder = [Folder 'RFP_Neuron'];
    elseif strcmp(FlouType,'green')  
        Neuron_Folder = [Folder 'GCaMP_Neuron'];
    end
    
    if ~exist(Neuron_Folder,'dir')
        disp('No Neuron Folder');
        return;
    end

    if strcmp(FlouType,'red')
        Image_Folder = [Folder 'RFP\'];
        Int_pos = load([posFolder,FlouType,'\RFP_Map.txt']);
    elseif strcmp(FlouType,'green')
        Image_Folder = [Folder 'GCaMP\'];
        Int_pos = load([posFolder,FlouType,'\GCaMP_Map.txt']);
    end
    image_names = dir([Image_Folder '*.tiff']);
    image_num = length(frame_seq);

%     Int_pos = load([posFolder,image_names(frame_seq(1)).name(1:length(image_names(1).name)-4),'txt']);
%     Int_pos = load([posFolder,'RFP.txt']);
    neuron_num = length(Int_pos(:,1));
    neuron_pos_last = zeros(neuron_num,2);
    worm_image = imread([Image_Folder image_names(frame_seq(1)).name]);
    for i =1:neuron_num
        [neuron_pos_last(i,1),neuron_pos_last(i,2)] = update_center(Int_pos(i,1),Int_pos(i,2),search_interval-6,intensity_ratio,worm_image);
    end
     
    Tracking_Length = length(frame_seq);
    neuron_pos = zeros(Tracking_Length,2); 
    neuron_pos(1:neuron_num,:) = neuron_pos_last;
%     output_name = [posFolder,'neuron_pos.txt'];
    
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
            [extracted_pos(i,1),extracted_pos(i,2)] = update_center(extracted_pos(i,1),extracted_pos(i,2),search_interval-4,intensity_ratio,worm_image);
            neuron_offset(:,i) = sqrt(sum((neuron_pos_last - repmat(extracted_pos(i,:),neuron_num,1)).^2,2));
            [extracted_I(i),~] = GetRegionI(worm_image,extracted_pos(i,:),neuron_radius,intensity_ratio);
        end
           
        % set neuron_search
        neuron_search = zeros(neuron_num,1);
        for i = 1:neuron_num
            neuron_search(i,1:length(find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i)))) = ...
                find(neuron_offset(i,:)<offset_thre & extracted_I>I_ratio_thre*neuron_I(i));
        end
        
        % set Neuron_pair
        Neuron_pair = struct(field4,value4,field5,value5);  % initialize
        for i = 1:extracted_num       % i = neuron, j = neuron_next          
            for j = 1:extracted_num 
                if ~isempty(find(neuron_search==i, 1)) && ~isempty(find(neuron_search==j, 1))
                    vector = extracted_pos(i,:)-extracted_pos(j,:);
                    Neuron_pair(i,j).dist = sqrt(sum(vector.^2));
                    direction = zeros(neuron_num-1,1);
                    for k = 1:neuron_num-1
                        direction(k) = dot(vector,ref_list(k,3:4));
                    end

                    if ~isempty(find(abs(ref_list(:,1)-Neuron_pair(i,j).dist)<ref_list(:,2) & direction>0 & Neuron_pair(i,j).dist>search_interval-6, 1))
                         Neuron_pair(i,j).ref_index = find(abs(ref_list(:,1)-Neuron_pair(i,j).dist)<ref_list(:,2) & direction>-eps);
                    end
                    
                end
            end
        end
         
        
        NeuronPath = zeros(1,neuron_num);
        path_num = 0;

        Stack_node = struct(field1,value1,field2,value2);    % initiate Stack_node
        Neuron_stack = struct('nodes',Stack_node,'layer_num',0); 

        % search paths
        for i = 1:length(find(neuron_search(1,:)>0))
            Stack_node.neuron_index = 1;
            Stack_node.extracted_index = neuron_search(1,i);
            [Neuron_stack,sign] = StackIn(Neuron_stack,Stack_node,sign);
            top = topStack(Neuron_stack);
             [Neuron_stack,NeuronPath,sign,path_num] =  DeepSearch(neuron_search,Neuron_pair,top,NeuronPath,Neuron_stack,sign,neuron_num,path_num);
        
        end
        
        % find most optimal path
        if path_num == 0
            disp(['frame: ', num2str(image_index),' Cannot find the right path. Please label by hand.']);
            Tracking_Length = (t-1)*neuron_num;
            break;
        elseif path_num == 1
            neuron_pos_last = extracted_pos(NeuronPath,:);
        elseif path_num > 1
            path_score = zeros(path_num,1);
            offset_sum = zeros(path_num,1);
                 for i = 1:path_num
                     for j = 1:neuron_num-1
                        vector = extracted_pos(NeuronPath(i,j),:)-extracted_pos(NeuronPath(i,j+1),:);                   
                        dist = Neuron_pair(NeuronPath(i,j),NeuronPath(i,j+1)).dist;
                        cos_theta =  dot(vector,ref_list(j,3:4))/dist/ref_list(j,1);
                        path_score(i) = path_score(i) + ((dist-ref_list(j,1))/ref_list(j,1))^2 - cos_theta^2;
                     end
                     for j = 1:neuron_num
                         offset_sum(i) = offset_sum(i) + neuron_offset(j,NeuronPath(i,j));    
                     end
                 end
             path_score = path_score + (offset_sum./max(offset_sum)/2).^2;    %   + (offset_sum./max(offset_sum)).^2;
             temp = find(path_score == min(path_score));
             neuron_pos_last = extracted_pos(NeuronPath(temp(1),:),:);                                                                                                         
        end
        
         neuron_pos((t-1)*neuron_num+1:t*neuron_num,:) = neuron_pos_last;
         for i = 1:neuron_num
                [neuron_I(i),~] = GetRegionI(worm_image,neuron_pos_last(i,:),neuron_radius,intensity_ratio);
         end
        ref_list = GetRefList(neuron_pos_last); 
        Tracking_Length = t*neuron_num;
        
        disp(['Succeed:  frame ',num2str(image_index),'/',num2str(frame_seq(end))]);
         
    end
    
%         fid = fopen(output_name,'a');  
%         for i = 1:Tracking_Length
%             fprintf(fid,'%d    %d\n',neuron_pos(i,1),neuron_pos(i,2));
%         end
%         fclose(fid);

        for i = 1:neuron_num
            if tracking_index(i)>9
                output_name = [posFolder,FlouType,'\neuron ',num2str(tracking_index(i)),'.txt'];
            else
                output_name = [posFolder,FlouType,'\neuron 0',num2str(tracking_index(i)),'.txt'];
            end
            fid = fopen(output_name,'a');  
            for j = 1:Tracking_Length/neuron_num
                fprintf(fid,'%d    %d\n',neuron_pos(neuron_num*(j-1)+i,1),neuron_pos(neuron_num*(j-1)+i,2));
            end
            fclose(fid);
            disp(['Saved:  neuron',num2str(tracking_index(i))])
        end
        
        if Tracking_Length/neuron_num == length(frame_seq)
            disp('All Done')
        end
        
        

    
        
end





