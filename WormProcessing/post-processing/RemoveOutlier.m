function out = RemoveOutlier(data)
% ������������һά��̬�ֲ���ͨ������ֲ����ݵľ�ֵ�������ж������Ƿ����쳣��
%

winsize = 24; % 1 second
T = length(data);
out = data;

for i=1:T-winsize
    local_data = data(1:i+winsize-1);
    local_mean = mean(local_data);
    local_median = median(local_data);
    local_std = std(local_data);
    local_data(abs(local_data - local_mean) > 3*local_std) = local_median;
    out(1:i+winsize-1) = local_data;
end

% Ŀǰ��Ҫ���쳣�����ǻ��ڸ���ͳ�Ƶģ�
%��1��������̬�ֲ���һά�����쳣����
%��2�����ڶ�Ԫ��˹�ֲ��쳣���⣺s1 ����ÿ��ά���Ƕ����ģ�s2 ���ø�ά��˹�ֲ��������
%��3����ԴMahalanobis���� Dist^2 = (x-u)^T S^-1 (x-u), S��ʾЭ�������
%��4�����ڿ����ֲ���ǰ��������ÿ��ά��������̬�ֲ�

end