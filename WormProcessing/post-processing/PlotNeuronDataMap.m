function PlotNeuronDataMap(neuron_activity,names)
% plot multiple neurons' activities

frame_rate = 24;
font_size = 14;

imagesc(neuron_activity);colormap(jet);
colorbar;

ylabel('\Delta R/R_0','FontSize',font_size);
xlabel('Time (s)','FontSize',font_size);
set(gca,'ytick',1:length(names));
set(gca,'yticklabel',names);
set(gca,'xtick',0:10*frame_rate:length(neuron_activity));
set(gca,'xticklabel',0:10:(length(neuron_activity)/frame_rate));
set(gca,'FontSize',font_size);

end