function SplitNeuronPos(Folder,tracking_index,FlouType)
% Split Map text and append into neuron position files

posFolder = [Folder 'neuron_pos\' FlouType '\'];
if strcmp(FlouType,'red')
    neurons_pos = load([posFolder,'RFP_Map.txt']);
elseif strcmp(FlouType,'green')
    neurons_pos = load([posFolder,'GCaMP_Map.txt']);
end
neuron_num = length(tracking_index);
Tracking_Length = length(neurons_pos(:,1))/neuron_num;
for i = 1:neuron_num
    output_name = [posFolder sprintf('neuron %02d',tracking_index(i)) '.txt'];
    fid = fopen(output_name,'a');  
    for j = 1:Tracking_Length
        fprintf(fid,'%d    %d\n',neurons_pos(neuron_num*(j-1)+i,1),neurons_pos(neuron_num*(j-1)+i,2));
    end
    fclose(fid);
    disp(['Succeed:  neuron ',num2str(tracking_index(i))])
end

end