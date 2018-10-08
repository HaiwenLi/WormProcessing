function DrawGCaMPActivity_Couple(activity,frame_rate)
% Load activity data and draw figures

close all;
font_size = 18;
line_width = 1.5;

load(activity);
Neuron_Num = size(GCaMP_Ca,1);
T = size(GCaMP_Ca,2);
time = (1:T)/frame_rate;

smooth_span = 5;
colors = {'b','r','g','m','c','k'};
F = zeros(length(GCaMP_Ca),Neuron_Num);
for i=1:Neuron_Num
    % GCaMP ÐÅºÅÂË²¨
    GCaMP_Ca(i,:) = smooth(GCaMP_Ca(i,:),'moving',smooth_span);
    
    Background = min(GCaMP_Ca(i,:));
    F(:,i) = (GCaMP_Ca(i,:) - Background)/(Background + eps);
%     F = smooth(F,smooth_span);
    
    h1 = figure(1);hold on;
    plot(time,F(:,i),'LineWidth',line_width,'Color',char(colors(i)));
    set(gca,'FontSize',font_size);
    xlabel('Time (s)','FontSize',font_size);
    ylabel('\Delta F/F','FontSize',font_size);
    hold off;

%     Curvature(i,:) = smooth(Curvature(i,:),smooth_span);
%     h2 = figure(2);hold on;
%     plot(time,Curvature(i,:),'LineWidth',line_width,'Color',char(colors(i)));
%     set(gca,'FontSize',font_size);
%     xlabel('Time (s)','FontSize',font_size);
%     ylabel('Curvature','FontSize',font_size);
%     hold off;
%     
%     delta_time = 1/frame_rate;
%     cross_corr = crosscorr(F, Curvature(i,:), floor(5/delta_time));
%     time1 = ((1:length(cross_corr)) - (length(cross_corr)+1)/2)*delta_time;
%     
%     h3 = figure(3);hold on;
%     plot(time1,cross_corr,'LineWidth',line_width,'Color',char(colors(i)));
%     xlabel('Time (s)','FontSize',font_size);
%     ylabel('Cross Correlation','FontSize',font_size);   
%     set(gca,'FontSize',font_size);
%     hold off;
end
legend('VA5','DA4', 'DB5/VB7', 'DA6', 'VA9', 'VB10');

% % Save GCaMP
% figure_name = [output_name '_GCaMP_neuron'];
% saveas(h1,[figure_name '.fig']);
% print(h1,'-djpeg','-r200',figure_name);
%     
% % Save Curvature
% figure_name = [output_name '_curvature'];
% saveas(h2,[figure_name '.fig']);
% print(h2,'-djpeg','-r200',figure_name);
% 
% % Save Correlation
% corr_name = [output_name '_corrlation_neuron'];
% set(gca,'FontSize',font_size);
% print(h3,'-djpeg','-r200',corr_name);
end