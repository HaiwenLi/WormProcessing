function SingleLocalSearch(frame_seq,initial_pos,anchor_index,ImageFolder,output_folder,FlouType) 
% Track single neuron in local region
% 

WormImages = dir([ImageFolder,'*.tiff']);
search_interval = 20;
intensity_ratio = 1;
I_ratio_thre = 1.5; % Neuron Signal/Background

last_anchor_pos = initial_pos; 
anchor_pos = zeros(length(frame_seq),2);
anchor_pos(1,:) = initial_pos;

% local search in the following frames
for n = 2:length(frame_seq)
    frame_index = frame_seq(n);
    Wimage_name = [ImageFolder,WormImages(frame_index).name];
    Wimage = imread(Wimage_name);
    
    % track neuron in local region of anchor
    Cx = zeros(1,search_interval*search_interval);
    Cy = zeros(1,search_interval*search_interval);
    Ic = zeros(1,search_interval*search_interval);
    k = 0; 
    
    for x = (last_anchor_pos(1)-search_interval) : (last_anchor_pos(1)+search_interval)
        for y = (last_anchor_pos(2)-search_interval) : (last_anchor_pos(2)+search_interval)
            if (x-last_anchor_pos(1))^2 + (y-last_anchor_pos(2))^2<=search_interval^2
                k = k+1;
                Cx(k) = x;
                Cy(k) = y;
                Ic(k) = Wimage(int32(y),int32(x));
            end
        end
    end
    k = find(Ic==max(Ic)); 
     
    if strcmp(FlouType,'red')
        [Ax_tempt(1),Ay_tempt(1)] = UpdateNeuronPos(mean(Cx(k)), mean(Cy(k)),search_interval-13,intensity_ratio,Wimage);
        [Ax_tempt(2),Ay_tempt(2)] = UpdateNeuronPos(Ax_tempt(1),Ay_tempt(1),search_interval-15,intensity_ratio,Wimage);
    elseif strcmp(FlouType,'green')
        [Ax_tempt(2),Ay_tempt(2)] = UpdateNeuronPos(mean(Cx(k)), mean(Cy(k)),search_interval-15,intensity_ratio,Wimage);
    end
    
  
     [neuron_I_local, back_I_local] = GetNeuronIntensity(Wimage,[Ax_tempt(2),Ay_tempt(2)],search_interval/4,intensity_ratio);
     I_ratio_local = neuron_I_local/(back_I_local + eps);

     % restriction: intensity, neuron/non-neuron-intensity ratio
     if neuron_I_local<400 && I_ratio_local<I_ratio_thre
         disp(['Frame ',num2str(frame_index),'(start from Frame ',num2str(frame_seq(1)),')','  Cannot find the right neuron. Please label by hand.']);
         Succeded_Tracking_Length = n-1;
        break;
     else
         anchor_pos(n,:) = [Ax_tempt(2),Ay_tempt(2)];
         last_anchor_pos = [Ax_tempt(2),Ay_tempt(2)];
         Succeded_Tracking_Length = n;
     end

    disp(['Frame: ',num2str(frame_index),'  anchor_index ',num2str(anchor_index),'  Ax = ',num2str(anchor_pos(n,1)),' Ay = ',num2str(anchor_pos(n,2))]);
end
    
%每帧neuron坐标写入txt文档  
output_name = [output_folder,'neuron ',num2str(anchor_index),'.txt'];
fid = fopen(output_name,'a');  
for i = 1:Succeded_Tracking_Length
    fprintf(fid,'%d    %d\n',anchor_pos(i,1),anchor_pos(i,2));
end
fclose(fid);

end
        