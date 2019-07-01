function [W,H] = shape_nmf(data,k)
% data is m*n matrix, where m is the dimension of data, and n is data num
% k is the reduction dimension

opt = statset('Maxiter',10000,'Display','final');

% make data be non-negative
% m = size(data,1);
% min_data = min(data);
% max_data = max(data);
% data = (data - repmat(min_data,m,1))./repmat((max_data - min_data),m,1);
data = abs(data);

% W is m*k matrix and H is k*n matrix
% rng(1);
[W,H] = nnmf(data, k, 'option', opt);

% normalize W
for i=1:k
    W(:,i) = W(:,i)/max(W(:,i));
end

end