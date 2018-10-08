function ref_list = GetRefList(neuron_pos_last)

neuron_num = length(neuron_pos_last(:,1));
ref_list = zeros(neuron_num-1,2);              % first frame, vol_1: distance, vol_2: error, head to tail

ref_list(:,1) = sqrt(sum((neuron_pos_last(1:neuron_num-1,:) - neuron_pos_last(2:neuron_num,:)).^2,2));
ref_list(ref_list(:,1)>100,2) = ref_list(ref_list(:,1)>100,1)/7.5;
ref_list(ref_list(:,1)<=100,2) = 10;
ref_list(:,3:4) = neuron_pos_last(1:neuron_num-1,:) - neuron_pos_last(2:neuron_num,:);

end