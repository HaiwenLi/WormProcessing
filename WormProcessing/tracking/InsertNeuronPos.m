function InsertNeuronPos(tracking_index, insert_pos, posFolder, FlouType)
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
    original_neuron_pos = load(output_name);
    updated_neuron_pos = zeros(length(original_neuron_pos)+Tracking_Length, 2);

    % insert neuron positions
    if ~isempty(insert_pos)
        updated_neuron_pos(1:insert_pos-1,:) = original_neuron_pos(1:insert_pos-1,:);
        for k=1:Tracking_Length
            updated_neuron_pos(insert_pos+k-1,:) = neurons_pos((k-1)*neuron_num+i, :);
        end
        updated_neuron_pos((insert_pos+Tracking_Length):end,:) = original_neuron_pos(insert_pos:end,:);
    else
        % append the neuron position
        insert_pos = length(original_neuron_pos) + 1;
        updated_neuron_pos(1:(insert_pos-1),:) = original_neuron_pos(:,:);
        for k=1:Tracking_Length
            updated_neuron_pos(insert_pos+k-1,:) = neurons_pos((k-1)*neuron_num+i, :);
        end
    end

    % write neuron positions into file
    fid = fopen(output_name,'wt');
    for j = 1:length(updated_neuron_pos)
        fprintf(fid,'%d    %d\n', updated_neuron_pos(j,1), updated_neuron_pos(j,2));
    end
    fclose(fid);
    disp(['Succeed:  neuron ',num2str(tracking_index(i))])
end

end