function covM = shape_cov(data)
% calculate the covariance of data (one by one)

time = length(data(1,:));
data_size = length(data(:,1));
covM = zeros(data_size,data_size);
for i = 1:time
    covM = covM+(data(:,i)-mean(data(:,i)))*(data(:,i)-mean(data(:,i)))';
end
covM = covM/time;

end

