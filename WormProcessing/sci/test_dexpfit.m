clc;
input_data = rand(1,100);
delta_t = 0.1;

tao = [0.5, 0.1, 2];
output_data = zeros(size(input_data));
for i=1:length(output_data)
    output_data(i) = tao(3)*sum((input_data(1:i).*...
                     (exp(-(i-(1:i))*delta_t/tao(1)) - exp(-(i-(1:i))*delta_t/tao(2)))));
end

% draw input data and output data
t = (1:length(input_data))*delta_t;
% plot(t, input_data, t, output_data);

% test the doule exponetial convolution kernel
tao_0 = [0.4, 0.2, 1.5];
fitted_tao = DoubleExpFit(input_data, output_data, delta_t, tao_0);
disp(fitted_tao);