function out = RemoveOutlier(data)
% ������������һά��̬�ֲ���ͨ������ֲ����ݵľ�ֵ�������ж������Ƿ����쳣��
%

winsize = 24; % 1 second

half_winsize = ceil(winsize/2);
deviation_ratio = 2;
T = length(data);
out = data;

% ����ԭ���������˹�ֲ�������moving window�����
for i=half_winsize+1:T-half_winsize
    local_data = data((i-half_winsize):(i+half_winsize));
    local_mean = mean(local_data);
    local_median = median(local_data);
    local_std = std(local_data);
    local_data(abs(local_data - local_mean) > deviation_ratio*local_std) = local_median;
    out((i-half_winsize):(i+half_winsize)) = local_data; % update data
end

% 

% Ŀǰ��Ҫ���쳣�����ǻ��ڸ���ͳ�Ƶģ�
%��1��������̬�ֲ���һά�����쳣����
%��2�����ڶ�Ԫ��˹�ֲ��쳣���⣺s1 ����ÿ��ά���Ƕ����ģ�s2 ���ø�ά��˹�ֲ��������
%��3����ԴMahalanobis���� Dist^2 = (x-u)^T S^-1 (x-u), S��ʾЭ�������
%��4�����ڿ����ֲ���ǰ��������ÿ��ά��������̬�ֲ�

end