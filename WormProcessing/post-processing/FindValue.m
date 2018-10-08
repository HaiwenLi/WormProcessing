function index = FindValue(v,values)
% Found string v in values (cell)

index = nan;
for i=1:length(values)
    if strcmp(v,char(values{i})) == 1
        index = i;
        break;
    end
end