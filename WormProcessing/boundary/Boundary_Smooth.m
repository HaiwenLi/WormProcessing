function smooth_boundary = Boundary_Smooth(boundary,arc_interval)
% 分割中心线，获取中心点坐标(interpolated_line)
% 参数说明：before_interpolate 表示获取的边界坐标，PARTITION_NUM 表示分割的数目

POINT_NUM = size(boundary,1);
border_index_m = boundary(:,1);
border_index_n = boundary(:,2);

pp_m = csaps(1 : POINT_NUM, border_index_m);                            % doing the cubic smoothing spline for border x index
pp_n = csaps(1 : POINT_NUM, border_index_n);                            % doing the cubic smoothing spline for border y index
curve_m = fnval(pp_m, 1:POINT_NUM);                                     % giving the x location of spline curve
curve_n = fnval(pp_n, 1:POINT_NUM);                                     % giving the y location of spline curve

curve_m_diff = curve_m(2:POINT_NUM) - curve_m(1:POINT_NUM-1);
curve_n_diff = curve_n(2:POINT_NUM) - curve_n(1:POINT_NUM-1);
curve_diff = sqrt(curve_m_diff.^2 + curve_n_diff.^2);
spline_length = sum(curve_diff);

spline_arc(2:POINT_NUM) = cumsum(curve_diff);
spline_pp_m = csaps(spline_arc,curve_m);
spline_pp_n = csaps(spline_arc,curve_n);

t = 0:arc_interval:spline_length;
smooth_boundary = zeros(length(t),2);
smooth_boundary(:,1) = fnval(spline_pp_m, t);
smooth_boundary(:,2) = fnval(spline_pp_n, t);
end

