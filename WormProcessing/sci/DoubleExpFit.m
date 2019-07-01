function tao = DoubleExpFit(input_data,output_data,delta_t, tao_0)
% Assume the convulution kernel of output_data and input data is
% double exponetial k(t) = exp(-t/t1) - exp(-t/t2), t>0. Then, fit the parameters by data. 

% 使用最速下降算法时，最重要的问题就是步长以及收敛速度的协调
% iteration control parameters
MaxIter = 10000;
epsilon1 = 1.0e-6;
epsilon2 = 1.0e-6;
step = delta_t/10; %非常重要的参数，第一次搜索时就要保证目标函数是减小的！

iter = 0;
tao = tao_0;  % tao_1, tao_2, alpha, initial values
H = calc_cost(output_data, input_data, tao, delta_t);
while (iter < MaxIter)
    % update tao
    delta_tao = calc_partial(output_data, input_data, tao, delta_t);
    new_tao = tao - step * delta_tao;
%     disp(new_tao);
      
    % update H
    lastH = H;
    H = calc_cost(output_data, input_data, new_tao, delta_t);
%     disp(H);
    
    if abs(H - lastH)<epsilon1*(1+abs(H)) && sum(abs(tao - new_tao))<epsilon2*(1+norm(new_tao))
%         disp('break');
        break;
    end
    tao = new_tao;
    iter = iter + 1;
end

end

% calculate the cost function
function H = calc_cost(output_data, input_data, tao, delta_t)

N = length(output_data);
H = 0;
for i=1:N
    conv_output_data = sum((input_data(1:i).*...
                         (exp(-(i-(1:i))*delta_t/tao(1)) - exp(-(i-(1:i))*delta_t/tao(2)))));
    H = H + (output_data(i) - tao(3)*conv_output_data)^2;
end
H = H/(2*N);

end

% calculate the partial derivative of cost function
function pTao = calc_partial(output_data, input_data, tao, delta_t)

N = length(output_data);
pTao = zeros(size(tao));
for i=1:N
    conv_output_data = sum((input_data(1:i).*...
                         (exp(-(i-(1:i))*delta_t/tao(1)) - exp(-(i-(1:i))*delta_t/tao(2)))));
    p1 = -tao(3)*sum((input_data(1:i).*exp(-(i-(1:i))*delta_t/tao(1)).*(i-(1:i))*delta_t/(tao(1)^2)));
    p2 =  tao(3)*sum((input_data(1:i).*exp(-(i-(1:i))*delta_t/tao(2)).*(i-(1:i))*delta_t/(tao(2)^2)));

    pTao(1) = pTao(1) + (output_data(i) - tao(3)*conv_output_data) * p1;
    pTao(2) = pTao(2) + (output_data(i) - tao(3)*conv_output_data) * p2;
    pTao(3) = pTao(3) + (output_data(i) - tao(3)*conv_output_data) * (-conv_output_data);
end
pTao = pTao/N;

end
