function PlotData(Folder,name)
% plot neuron activity and curvature by using yyaxis

line_width = 2;
font_size = 12;

load([Folder '\curvature_data\' name '.mat']);
load([Folder '\neuron_data\' name '.mat']);

total_time = (1:length(curvature))/24;

yyaxis left
plot(total_time,neuron_activity,'LineWidth',line_width);hold on;
ylabel('\Delta R/R_0','FontSize',font_size);
legend(name);

yyaxis right
plot(total_time,curvature,'LineWidth',line_width);hold on;
ylabel('Curvature','FontSize',font_size);

xlabel('Time (s)','FontSize',font_size);
set(gca,'FontSize',font_size);
% saveas(h,'DA4-.fig');
% print(h,'-djpeg','-r200','DA4-');
end


