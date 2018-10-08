function Draw_Neuron_Activity(folder)
% Draw neuron activities in folder

% Parameters for drawing
line_width = 2;
font_size = 12;

% load neuron names
frame_rate = 24;
load([folder 'neuron_names.mat']);% the data name is 'names' (cell struc)

neuron_num = length(dir([folder 'neuron_data\*.mat']));
h = figure;
for i=1:neuron_num
    data = load([folder 'neuron_data\' char(neuron_names{i}) '.mat']);
    time = (1:length(data.neuron_activity))/frame_rate;
    
    subplot(neuron_num,1,i);
    plot(time,data.neuron_activity,'LineWidth',line_width);
    set(gca,'FontSize',font_size);
    if i == neuron_num
        ylabel('\Delta R/R_0','FontSize',font_size);
        xlabel('Time (s)','FontSize',font_size);
    else
        set(gca,'XTick',[]);
    end
    legend(char(neuron_names{i}));
    box off;
end

saveas(h,[folder 'neuron_activity.fig']);
    
end