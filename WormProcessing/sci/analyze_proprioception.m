function normalized_part_r = analyze_proprioception(r,t)

% time window setting
frame_rate = 24;
pre_interval = 2*frame_rate;
post_interval = 15*frame_rate;
smooth_span = ceil(frame_rate/2); %0.5 second

N = size(r,2);
start_index = max(1,t-pre_interval);
end_index = min(N, t+post_interval);
part_r = r(:,start_index:end_index);

% interested index
inx = 1:size(part_r,1);
inx = setdiff(inx, [12,15,11,6,3,2,20,17,9]);% for 0807-F5 360
inx = sort(inx,'ascend');

% smooth the activity
smooth_part_r = zeros(length(inx),size(part_r,2));
for i=1:length(inx)
    smooth_part_r(i,:) = smooth(part_r(inx(i),:),'moving',smooth_span);
end

% remove the baseline of activity
background_ratio = 0.1;
normalized_part_r = zeros(size(smooth_part_r));
for i=1:size(smooth_part_r,1)
    sorted_data = sort(smooth_part_r(i,:),'ascend');
    baseline = mean(sorted_data(1:ceil(background_ratio * length(sorted_data))));
    normalized_part_r(i,:) = (smooth_part_r(i,:) - baseline)/(baseline + eps);
end

% plot activity
line_width = 1.5;
font_size = 14;
color = [0.6,0.6,0.6];
figure;hold on;
time = (1:size(part_r,2))/frame_rate;
for i=1:size(smooth_part_r,1)
    plot(time, normalized_part_r(i,:),'linewidth',line_width,'color',color);
%     text(max(time)-0.1,normalized_part_r(i,end)+0.01,num2str(inx(i)));
end
% legend(neuron_names);
mean_r = mean(normalized_part_r);
plot(time, mean_r,'linewidth',line_width,'color','r');
hold off;
xlabel('Time (s)');
ylabel('\Delta R / R_0');
set(gca,'fontsize',font_size);
axis([0 max(time)+0.1 min(normalized_part_r(:))-0.05 max(normalized_part_r(:)+0.05)]);

end

