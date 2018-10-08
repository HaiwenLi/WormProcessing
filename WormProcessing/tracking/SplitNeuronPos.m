function SplitNeuronPos(tracking_index,posFolder,FlouType)
% Split Map text and append into neuron position files

if strcmp(FlouType,'red')
    neurons_pos = load([posFolder,FlouType,'\RFP_Map.txt']);
elseif strcmp(FlouType,'green')
    neurons_pos = load([posFolder,FlouType,'\GCaMP_Map.txt']);
end
neuron_num = length(tracking_index);
Tracking_Length = length(neurons_pos(:,1))/neuron_num;
for i = 1:neuron_num
    if tracking_index(i)>9
        output_name = [posFolder,FlouType,'\neuron ',num2str(tracking_index(i)),'.txt'];
    else
        output_name = [posFolder,FlouType,'\neuron 0',num2str(tracking_index(i)),'.txt'];
    end
    fid = fopen(output_name,'a');  
    for j = 1:Tracking_Length
        fprintf(fid,'%d    %d\n',neurons_pos(neuron_num*(j-1)+i,1),neurons_pos(neuron_num*(j-1)+i,2));
    end
    fclose(fid);
    disp(['Succeed:  neuron ',num2str(tracking_index(i))])
end

end