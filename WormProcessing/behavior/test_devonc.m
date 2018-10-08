a = [1 2 3 4 5 6 7];
k = [1 2 1];
b = conv(a,k,'same');

n = floor(length(a)/2);
k = deconv([ zeros(1,n) b zeros(1,n)],a)

% deconv
% k = deconv1d(a,b)
