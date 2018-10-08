function [Neuron_tree] = BuildNeuronTree(ref_index,neuron_search,Neuron_tree,Neuron_pair,neuron_last)

i = 1;k = 1;
while neuron_search(ref_index,i) > 0
    j = 1;
    while neuron_search(ref_index+1,j)>0               
        if ~isempty(Neuron_pair(neuron_search(ref_index,i),neuron_search(ref_index+1,j)).ref_index == ref_index) && neuron_last~=j  
            Neuron_tree(ref_index).neuron_last(k) = neuron_last;
            Neuron_tree(ref_index).neuron(k) = neuron_search(ref_index,i);
            Neuron_tree(ref_index).neuron_next(k) = neuron_search(ref_index+1,j);
            k = k + 1;
        end
        j = j + 1;
    end
    i = i + 1;
end

end