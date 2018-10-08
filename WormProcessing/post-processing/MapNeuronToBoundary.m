function [b_p,map_index] = MapNeuronToBoundary(neuron,boundary,search_interval)
% Map the neuron to boudanry and return the mapped point
% Input: neuron [x,y] 1x2 array, the neuron position
%        boundary ventral boundary of the worm 
%        search_interval the interval for searching the mapped point
% Make sure the index of neuron and boundary are the same

min_list = (boundary(:,1)>=neuron(1)-search_interval);
max_list = (boundary(:,1)<=neuron(1)+search_interval);

if (sum(min_list)>0 && sum((max_list))>0)
    list = min_list | max_list;
elseif sum(min_list)>0
    list = min_list;
else
    list = max_list;
end

min_index = find(list>0, 1 );
max_index = find(list>0, 1, 'last' );
list_index = min_index:max_index;

dist = sum((boundary(min_index:max_index,:) - repmat(neuron,max_index-min_index+1,1)).^2,2);
nearest_index = list_index(dist == min(dist));
b_p = boundary(nearest_index,:);
map_index = nearest_index;
end