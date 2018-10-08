function DrawPairNeuronActivity(COMP_PAIRS, match_index, activity, neuron_names)

[COMP_PAIRS,match_index] = GetCompPairs(neuron_names);

for i=1:size(match_index,1)
    if ~isnan(match_index(i,1))
        n1_name = COMP_PAIRS[i].name;
        n1_index = FindValue(n1_name, neuron_names);
        values = strsplit(COMP_PAIRS[i].value, ',');
        for j=1:size(match_index,2)
            if ~isnan(match_index(i,j))
                n2_name = char(values{j});
                n2_index = match_index(j);

                % Draw code

                legend(n1_name, n2_name);
            end
        end
    end

end