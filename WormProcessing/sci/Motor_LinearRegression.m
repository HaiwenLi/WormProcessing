function [A,B] = Motor_LinearRegression(motion_features,neural_activities)
% Using linear regression to fitting the transition and control matraices
% of motor citcuit of C. elegans
%
% Input parameters:
% motion_features: m x N matrix
% neural_activities: s x N matrix
%
% Output parameters:
% A: transition matrix
% B: control matrix
% A and B meet the equation: X(t) = A*X(t-1) + B*U(t) + 
% 

% Optimization parameters
MAX_ITRE = 100000;
epsilon = 1.0e-1;

X = motion_features';         % motion features 
[m,N] = size(X);
U = neural_activities(:,2:N); % neural activities
s = size(U,1);
X1 = X(:,1:N-1);
X2 = X(:,2:N);
A = random(m,m); % initialization of variables
B = random(m,s);

lambda1 = 1.0;
lambda2 = 1.0;

% Using the gradient descent to optimize the maxtrix
iter = 0;
while true
    iter = iter + 1;
    A_temp = A - lambda1*(-X2*X1' + A*(X1*X1') + B*U*X1');
    B_temp = B - lambda2*(-X2*U' + A*X1*U' + B*(U*U'));
    
    if iter >= MAX_ITRE
        disp('Reach the max iteration, exit the loop');
    else
        if norm(A-A_temp,'fro')<epsilon && norm(B-B_temp,'fro')<epsilon
            break;
        end
    end
    % update the matrix
    A = A_temp;
    B = B_temp;
end

end