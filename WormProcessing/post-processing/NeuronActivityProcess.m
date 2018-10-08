function res = NeuronActivityProcess(activity,curvature, delta_time, title_name, output_name)
% Neuron activity processing. Compute calcium activity information and
% correlations among them and curvatures
%
% Input parameters
% activity: one neuron activity
% curvature: the curvature along time in the neuron position
% delta_time: the sampling interval in activity

curvature = curvature';
font_size = 18;
line_width = 1.5;

% Compute the frequency of activity
freq = ComputeFrequency(activity,delta_time);

% Compute the max, min, mean, and ratio
max_activity = max(activity);
min_activity = min(activity);
mean_activity = mean(activity);
var_activity = var(activity);
ratio_activity = (max_activity - min_activity)/(min_activity + eps);

% Calculate the correlation between each neuron activity and corresponding
% curvature
corr_ac = corr(activity, curvature); % use pearson correlation (linear)
cross_corr = crosscorr(activity, curvature, floor(5/delta_time));
time = ((1:length(cross_corr)) - (length(cross_corr)+1)/2)*delta_time;

h = figure;
plot(time,cross_corr,'LineWidth',line_width);
xlabel('Time (s)','FontSize',font_size);
ylabel('Cross Correlation','FontSize',font_size);
title(title_name,'FontSize',font_size);
set(gca,'FontSize',font_size);
print(h,'-djpeg','-r200',output_name);

% Return processed results
res.freq = freq;
res.max_signal = max_activity;
res.min_signal = min_activity;
res.mean_signal = mean_activity;
res.var_signal = var_activity;
res.ratio_signal = ratio_activity;
res.corr_ac = corr_ac;
end