function [COMP_PAIRS,match_index] = GetCompPairs(names)

COMP_PAIRS = [struct('name','DA4','value',['VA5,','VB3,','VB4']);...
struct('name','DA3','value',['DB3,','VB3']);...
struct('name','DA4','value',['VA3,','VB3,','VA5,','VA6,','VB4']);...
struct('name','DA5','value',['VA6,','VA7,','VB5,','DB4,','DA6']);...
struct('name','DB3','value',['VB3,','VA3,','VA4']);...
struct('name','DB4','value',['VB5,','VB6,','VA6,','VA7']);...
struct('name','DA6','value',['VA7,','VA8,','VA9']);...
struct('name','DA7','value',['VA9,','VA10,','VA11']);...
struct('name','DB6','value',['VB9,','VA10']);...
struct('name','DB5','value',['VB7,','VB8']);...
struct('name','DB5','value',['VB7,','VB8']);...
struct('name','DB7','value',['VB5,','VB11'])];

match_index = nan(length(COMP_PAIRS),8);
index = 0;
for n=1:length(names)
    v = char(names{n});

    % Search each name in COMP PAIRS
    for i=1:length(COMP_PAIRS)
        name = COMP_PAIRS[i].name;
        value = COMP_PAIRS[i].value;
        if strcmp(v,name) == 1
            index = index + 1;

            % search subitems
            value_names = strsplit(value,',');
            for j=1:length(value_names)
                found_index = FindValue(char(value_names{j}), names);
                if ~isnan(found_index)
                    match_index(index,j) = found_index;
                end
            end
        end
    end
end

end