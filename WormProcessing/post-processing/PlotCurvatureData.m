function PlotCurvatureData(Folder,names)
% plot multiple neurons' curvatures

line_width = 2;
font_size = 12;
figure;
for i = 1:length(names)
    name = char(names{i});
    load([Folder '\curvature_data\' name '.mat']);
    if i==1
        total_time = (1:length(curvature))/24;
    end
    plot(total_time,curvature,'LineWidth',line_width);hold on;
    
end
ylabel('Curvature','FontSize',font_size);
xlabel('Time (s)','FontSize',font_size);
set(gca,'FontSize',font_size);
legend(names);
end


