function DrawNeuronActivity(activity,frame_rate,output_name)
% Load activity data and draw figures

close all;
font_size = 12;

load(activity);
Neuron_Num = size(GCaMP_Ca,1);
T = size(GCaMP_Ca,2);
time = (1:T)/frame_rate;

R = GCaMP_Ca./(eps + RFP_Ca);
smooth_span = 5;
for i=9:10
%     R(i,:) = smooth(R(i,:),smooth_span);
    plot(time,R(i,:));hold on;
    set(gca,'FontSize',font_size);
    title(['Neuron ' num2str(i)]);
    xlabel('Time (s)');
    ylabel('R');
%     figure_name = [output_name '_neuron_' num2str(i)];
%     saveas(h,[figure_name '.fig']);
%     print(h,'-djpeg','-r100',figure_name);
    
%     h = figure;
%     Curvature(i,:) = smooth(Curvature(i,:),smooth_span);
%     plot(time,Curvature(i,:));
%     set(gca,'FontSize',font_size);
%     title(['Neuron ' num2str(i)]);
%     xlabel('Time (s)');
%     ylabel('Curvature');
%     figure_name = [output_name '_curvature_' num2str(i)];
%     saveas(h,[figure_name '.fig']);
%     print(h,'-djpeg','-r100',figure_name);
end

end