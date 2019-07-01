% data pre-processing
clear;clc;

load('data\B19_curvature_50pts.mat');
curvatures = curvatures*140;

%using PCA to denoise
K = 4;
T = size(curvatures,1);
PNum = size(curvatures,2);
[coeff,score,latent,~,explained,mu] = pca(curvatures);
DataCurvature = score(:,1:K)*coeff(:,1:K)' + repmat(mu,T,1);

%using gaussian to smooth the curvature in spatial domain
for i=1:T
    % using gaussian smoothing
    winsize = floor(0.2*PNum/2)*2+1;
    sigma = winsize/2;
    
    % reverse curvature, because tail is 0 and head is 1 in this code
    DataCurvature(i,:) = smoothts(DataCurvature(i,end:-1:1), 'g', winsize, sigma);
end

% using gaussian to smooth the curvature in temporal domain
for i=1:PNum
%     % using gaussian smoothing
    winsize = 24;
%     sigma = winsize/4;
%     
%     % reverse curvature, because tail is 0 and head is 1 in this code
%     DataCurvature(:,i) = smoothts(DataCurvature(:,i), 'g', winsize, sigma);
    DataCurvature(:,i) = smooth(DataCurvature(:,i),winsize);
end