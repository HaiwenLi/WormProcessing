function DrawNeuronsActivity(activity, data_range, neuron_names, multi_ax, output_name)
% Load activity data and draw figures

close all;
font_size = 18;
line_width = 2;
frame_rate = 24;
figure_height = min(0.1, 0.9/length(neuron_names));

load(activity);
T = size(GCaMP_activities,2);
time = (1:T)/frame_rate;

start_index = data_range(1);
end_index = data_range(2);

h = figure;
for i=1:length(neuron_names)
    R = GCaMP_activities(i,start_index:end_index)./(eps + RFP_activities(i,start_index:end_index));
    R = RemoveOutlier(R);
    R_0 = min(R);
    % R_0 = mean(R_sorted(1:floor(p*length(R))));
    R = (R-R_0)/(eps + R_0); % delta_R / R_0
    
    %Smooth_R = SmoothNeuronActivity(R);
    
    %%%%% Calculate cross correlation
    % corr_name = [output_name '_corrlation_neuron_' num2str(i)];
    % res = NeuronActivityProcess(F,Curvature(i,:),1/frame_rate,['Neuron ' num2str(i)],corr_name);
    
    %%%%% Draw curvature
    % Curvature(i,:) = smooth(Curvature(i,:),smooth_span);
    % h = figure;
    % plot(time,Curvature(i,:),'LineWidth',line_width);
    % set(gca,'FontSize',font_size);
    % title(['Neuron ' num2str(i)],'FontSize',font_size);
    % xlabel('Time (s)','FontSize',font_size);
    % ylabel('Curvature','FontSize',font_size);
    % figure_name = [output_name '_curvature_' num2str(i)];
    % saveas(h,[figure_name '.fig']);
    % print(h,'-djpeg','-r200',figure_name);

    if multi_ax == 0
        hold on;
        plot(time(start_index:end_index), R, 'LineWidth', 1.5);
        plot(time(start_index:end_index), Smooth_R, 'LineWidth', line_width);
        box off;
        set(gca,'xtick',time(start_index):10:time(end_index));
        axis([0 time(end_index)+0.1 0 max(R)+0.2]);
%         ylabel('\Delta R/R_0','Color','k');
    else
        position_vec = [0.05 figure_height*i 0.9 figure_height*0.95];
        subplot('Position', position_vec);
        plot(time(start_index:end_index), R, 'LineWidth', 1.5);
        box off;
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        % plot(time, Smooth_R, 'LineWidth', line_width);hold off;
    end
    
    if i == length(neuron_names)
        xlabel('Time (s)','Color','k');
        ylabel(char(neuron_names{i}),'Color','k');
    end
%     title(['Neuron ' num2str(index)]);
    set(gca,'FontSize',font_size);
    
%     saveas(h,[figure_name '.eps']);
%     print(h,'-depsc2',figure_name);
    hold off;
end

% title(['Neuron ' num2str(i)]);

end