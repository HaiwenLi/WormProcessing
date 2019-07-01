function ref_list = GetRefList(neuron_pos_last)
Max_Dist = 150;%150
Min_Dist = 80;%80

neuron_num = length(neuron_pos_last(:,1));
ref_list = zeros(neuron_num-1,4);      % adjacent neuron distance, distance threshold, neuron vector
ref_list(:,1) = sqrt(sum((neuron_pos_last(1:neuron_num-1,:) - neuron_pos_last(2:neuron_num,:)).^2,2));

% set tolerance for different neuron distance
ref_list(ref_list(:,1)>Max_Dist,2) = ref_list(ref_list(:,1)>Max_Dist,1)/7;
ref_list(ref_list(:,1)>Min_Dist & ref_list(:,1)<= Max_Dist, 2) = 20;%25
ref_list(ref_list(:,1)<=Min_Dist,2) = ref_list(ref_list(:,1)<=Min_Dist,1)/3;
ref_list(:,3:4) = neuron_pos_last(1:neuron_num-1,:) - neuron_pos_last(2:neuron_num,:);
end