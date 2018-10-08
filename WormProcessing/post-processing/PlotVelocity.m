function PlotVelocity(worm_speed, crop_range, reverse_index)

worm_speed(reverse_index) = -worm_speed(reverse_index);
frame_rate = 24;
smooth_speed = smooth(worm_speed(crop_range), 2*frame_rate);

plot(1:length(smooth_speed),zeros(1,length(smooth_speed)),'k-','linewidth',2);hold on;
plot(smooth_speed,'k--','LineWidth',2);
ylabel('Velocity (um/s)');
xlabel('Time (s)');
set(gca,'xtick',0:10*frame_rate:length(smooth_speed));
set(gca,'xticklabel',0:10:(length(smooth_speed)/frame_rate));
set(gca,'FontSize',14);
axis([0 length(smooth_speed)+0.1 min(smooth_speed)-10 max(smooth_speed)+10]); 
box off;
hold off;

end