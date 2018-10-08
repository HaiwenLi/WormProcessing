function PlotNeuronData(neuron_activity,names)
% plot multiple neurons' activities

line_width = 2;
font_size = 12;

figure;hold on;
for i = 1:length(names)
%     name = char(names{i});
%     load([Folder '\neuron_data\' name '.mat']);
    if i==1
        total_time = (1:length(neuron_activity))/24;
    end
    plot(total_time,neuron_activity,'LineWidth',line_width);
    
end
hold off;
ylabel('\Delta R/R_0','FontSize',font_size);
xlabel('Time (s)','FontSize',font_size);
set(gca,'FontSize',font_size);
legend(names);
end


