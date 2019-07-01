function out = RemoveOutlier(data)
% 假设数据满足一维正态分布，通过计算局部数据的均值及方差判断数据是否是异常点
%

winsize = 24; % 1 second

half_winsize = ceil(winsize/2);
deviation_ratio = 2;
T = length(data);
out = data;

% 假设原数据满足高斯分布，采用moving window逐点检查
for i=half_winsize+1:T-half_winsize
    local_data = data((i-half_winsize):(i+half_winsize));
    local_mean = mean(local_data);
    local_median = median(local_data);
    local_std = std(local_data);
    local_data(abs(local_data - local_mean) > deviation_ratio*local_std) = local_median;
    out((i-half_winsize):(i+half_winsize)) = local_data; % update data
end

% 

% 目前主要的异常点检测是基于概率统计的：
%（1）基于正态分布的一维数据异常点检测
%（2）基于多元高斯分布异常点检测：s1 假设每个维度是独立的，s2 采用高维高斯分布计算概率
%（3）济源Mahalanobis距离 Dist^2 = (x-u)^T S^-1 (x-u), S表示协方差矩阵
%（4）基于卡方分布，前提是数据每个维度满足正态分布

end