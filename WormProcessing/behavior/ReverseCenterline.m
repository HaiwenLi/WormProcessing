function ReverseCenterline(CenterlineFolder,reverse_index)
% Reverse centerline
%
% Inputed Parameters:
% reverse_index: a list containing all centerline indices needed to be reversed
%

num = length(reverse_index);
for i=1:num
    image_index = reverse_index(i);
    curve_file = [CenterlineFolder num2str(image_index) '.mat'];
    data = load(curve_file);
    res = data.res;

    % reverse and save centerline
    res.centerline = res.centerline(end:-1:1,:);
    save([CenterlineFolder num2str(image_index) '.mat'],'res');
end
end