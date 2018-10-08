function curvatures = Worm_Curvatures(centerlines)
% ¼ÆËãÏß³æÇúÂÊ

N = size(centerlines,1);
curvatures = zeros(N,size(centerlines,2));
for i=1:N
    c = centerlines(i,:,:);
    c = [c(1,:,1);c(1,:,2)]';
    curvatures(i,:) = Compute_Curvature(c);
end
end