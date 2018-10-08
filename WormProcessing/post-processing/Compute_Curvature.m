function curvature = Compute_Curvature(backbone)
% º∆À„œﬂ≥Ê«˙¬ 

backbone_num = length(backbone);
smooth_length = 5;%floor(0.05*backbone_num

y = backbone(:,1);
x = backbone(:,2);

diff_x = diff(x,1);
diff_y = diff(y,1);
diff2_x = -diff(diff_x,1);
diff2_y = -diff(diff_y,1);
diff_x = diff_x(1:end-1);
diff_y = diff_y(1:end-1);
c = (diff_x.*diff2_y - diff2_x.*diff_y)./(diff_x.^2 + diff_y.^2).^1.5;
curvature = zeros(backbone_num,1);
curvature(2:end-1) = c(:);
curvature(1) = curvature(2);
curvature(end) = curvature(end-1);

curvature = smooth(curvature,smooth_length);
% plot(curvature,'b.-');hold on;
% plot(smooth_curvature,'r.-');hold off;
end