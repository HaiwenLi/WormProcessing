function curve = blind_curve_fit(x,y)
% Planar curve fit points cloud
% 
% Output parameters:
% curve: nx2 array,format:[y,x]

% Use PCA to find two principle direction
data = [x;y]';
[coeff,score] = pca(data);
mapped_x = score(:,1);
mapped_y = score(:,2);

% % test
% mapped_data = score*coeff' + repmat(mean(data),length(data),1);
% plot(data(:,1),data(:,2),'b.');hold on;
% plot(mapped_data(:,1),mapped_data(:,2),'rs');hold off;

% sort mapped x
[~,Idx] = sort(mapped_x);
mapped_x = mapped_x(Idx);
mapped_y = mapped_y(Idx);

% process multivalue case

% return image space
output = coeff*[mapped_x;mapped_y] + repmat(mean(data),1,length(data));
curve = [output(:,2);output(:,1)]';
end