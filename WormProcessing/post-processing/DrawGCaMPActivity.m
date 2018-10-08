function DrawGCaMPActivity(activity, draw_index, multi_ax, frame_rate, output_name)
% Load activity data and draw figures

close all;
font_size = 18;
line_width = 2;

load(activity);
T = size(GCaMP_Ca,2);
% T = floor(101*frame_rate);
time = (1:T)/frame_rate;
bp = 3*frame_rate;

names = {'DB2','DB1','VA2','VB3','DB3','VA3','VB4','DA3','VA4','DB4','VB6','DA4','VA6','VA8','VB9','DB6','DA6','VA9','VB10','VA10'};

p = 0.1; % compute R0
c= [0,64,128]/256;
for i=1:length(draw_index)
    index = draw_index(i);
    R = GCaMP_Ca(index,1:T)./(eps + RFP_Ca(index,1:T));
    R = RemoveOutlier(R);
%     R_sorted = sort(R);
    R_0 = min(R);
%     R_0 = mean(R_sorted(1:floor(p*length(R))));
    R = (R-R_0)/(eps + R_0);
%     R = detrend(R, 'linear', bp);

    Smooth_R = SmoothNeuronActivity(R);
    
    % Calculate cross correlation
    % corr_name = [output_name '_corrlation_neuron_' num2str(i)];
    % res = NeuronActivityProcess(F,Curvature(i,:),1/frame_rate,['Neuron ' num2str(i)],corr_name);
    
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
    h = figure;
    if multi_ax == 0
        hold on;
        plot(time, R, 'LineWidth', 1.5);
        plot(time, Smooth_R, 'LineWidth', line_width);
        box off;
        set(gca,'xtick',0:10:max(time));
        
        axis([0 max(time)+0.1 0 max(R)+0.2]);
%         ylabel('\Delta R/R_0','Color','k');
    else
        subplot(length(draw_index),1,i);
        plot(time, R, 'LineWidth', 1.5);
        plot(time, Smooth_R, 'LineWidth', line_width);hold off;
    end
    
    if i == length(draw_index)
        xlabel('Time (s)','Color','k');
        ylabel(char(names{i}),'Color','k');
    else
        title('\Delta R/R_0','Color','k');
        set(gca,'xticklabel','');
        ylabel('','Color','k');
    end
%     title(['Neuron ' num2str(index)]);
    set(gca,'FontSize',font_size);
    set(gcf,'Position',[1,1,1265/2,413/2],'color','w');
    
    figure_name = [output_name 'N-' num2str(index)];
%     saveas(h,[figure_name '.eps']);
%     print(h,'-depsc2',figure_name);
    hold off;
end

% title(['Neuron ' num2str(i)]);

end