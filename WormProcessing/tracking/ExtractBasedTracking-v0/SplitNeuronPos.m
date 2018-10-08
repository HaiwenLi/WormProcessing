function SplitNeuronPos(tracking_index,posFolder)
    neurons_pos = load([posFolder,'neuron_pos.txt']);
    neuron_num = length(tracking_index);
    Tracking_Length = length(neurons_pos(:,1))/neuron_num;
    for i = 1:neuron_num
        output_name = [posFolder,'neuron ',num2str(tracking_index(i)),'.txt'];
        fid = fopen(output_name,'a');  
        for j = 1:Tracking_Length
            fprintf(fid,'%d    %d\n',neurons_pos(neuron_num*(j-1)+i,1),neurons_pos(neuron_num*(j-1)+i,2));
        end
        fclose(fid);
        disp(['Succeed:  neuron',num2str(tracking_index(i))])
    end
end