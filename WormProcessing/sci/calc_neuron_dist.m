function neuron_dist = calc_neuron_dist(pos,neuron_pairs,interval)

N = size(pos,1)/interval;
P = size(neuron_pairs,1);
frame_rate = 24;

neuron_dist = zeros(P,N);
for i=1:P
    for j=1:N
        p1 = pos((j-1)*interval + neuron_pairs(i,1),:);
        p2 = pos((j-1)*interval + neuron_pairs(i,2),:);
        neuron_dist(i,j) = sum((p1-p2).^2)^0.5; % calculate the distance
    end
end

% plot distance
line_width = 1.5;
font_size = 14;
color = [0.6,0.6,0.6];
figure;hold on;
time = (1:size(neuron_dist,2))/frame_rate;
for i=1:size(neuron_dist,1)
    neuron_dist(i,:) = neuron_dist(i,:)/max(neuron_dist(i,:));
    plot(time,neuron_dist(i,:),'linewidth',line_width,'color',color);
%     text(max(time)-0.1,normalized_part_r(i,end)+0.01,num2str(inx(i)));
end
% legend(neuron_names);
mean_r = mean(neuron_dist);
plot(time, mean_r,'linewidth',line_width,'color','r');
hold off;
xlabel('Time (s)');
ylabel('Normalized Neuron Dist');
set(gca,'fontsize',font_size);
axis([0 max(time)+0.1 min(neuron_dist(:))-0.05 max(neuron_dist(:)+0.05)]);

end