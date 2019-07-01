function Neuron_stack = DeepSearch(candidate_neurons,Neuron_pair,root,Neuron_stack)
% deep search to find possible neuron paths

global NeuronPath;
global path_num;
global used_flag;

neuron_num = size(NeuronPath,2);
if root.neuron_index == neuron_num
   path_num = path_num + 1; 
   for i = neuron_num:(-1):1
       NeuronPath(path_num,i) = Neuron_stack.nodes(end+i-neuron_num).extracted_index;
   end
   Neuron_stack = StackOut(Neuron_stack);
else
   current_nindex = root.neuron_index;
   while current_nindex < neuron_num
        next_nindex = root.neuron_index+1;
        candidate_index = candidate_neurons(next_nindex,(candidate_neurons(next_nindex,:)>0));
        candidate_index = candidate_index(used_flag(candidate_index) == 0);
        in_times = 0;
        if ~isempty(candidate_index)
            for i = 1:length(candidate_index)
                 if ~isempty(find(Neuron_pair(root.extracted_index,candidate_index(i)).ref_index == current_nindex, 1))
                     in_times = in_times+1;
                     Stack_node = struct('neuron_index',next_nindex,'extracted_index',candidate_index(i));
                     Neuron_stack = StackIn(Neuron_stack,Stack_node); 
                     Neuron_stack = DeepSearch(candidate_neurons,Neuron_pair,Stack_node,Neuron_stack);
                 end
            end
        end
        
       % debug: output neuron stack
       %output_stack(Neuron_stack);
       
       % return to the root and start to visit its silblings
        if in_times == 0 || i == length(candidate_index)  % || isempty(possible)
            Neuron_stack = StackOut(Neuron_stack);
            break;
        end
   end
end
end