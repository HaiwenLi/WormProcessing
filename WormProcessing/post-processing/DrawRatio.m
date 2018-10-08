function DrawRatio(neuron_seq)
neuron_activity = load('L:\NeuronData\20180123\F14\neuron_activity_radium3.mat');
GCaMP_Ca = neuron_activity.GCaMP_Ca;
RFP_Ca = neuron_activity.RFP_Ca;
smooth_span = 8;
T = 2352;

neuron_name =  string({'DB3 ';'VA3 ';'VB4 ';'VB5 ';'DB4 ';'VA5 ';'VB6 ';'VB7 ';'VA8 ';'VB9 ';'DB6 ';'VA9 ';'VB10';'VA10';'VB11';'DB7';'DA7';'VA11';});
F = zeros(2,T);
% neuron_seq = [1,2;2,8;2,10;4,8;14,18;10,18;10,14;9,10;10,12;4,6;1,2;];
for j = 1:length(neuron_seq(:,1))
    h = figure;
    for i = 1:length(neuron_seq(j,:))
            neuron_index = neuron_seq(j,i); 
            R = GCaMP_Ca(neuron_index,:)./(RFP_Ca(neuron_index,:)+eps);
            R0 = min(R);
            F(i,:) = (R - R0)/(R0 + eps);
%             R = GCaMP_Ca(neuron_index,:);
%             R0 = min(R);
%             F(i,:) = (R - R0)/(R0 + eps);
            F(i,:) = smooth(F(i,:),smooth_span/T,'rloess');
            
            plot((1:T)/24,F(i,:),'linewidth',1.5);hold on;

    end
    plot((1:T)/24,F(1,:)./F(2,:),'linewidth',1.5)
    legend(neuron_name(neuron_seq(j,1)),neuron_name(neuron_seq(j,2)),...
    [char(neuron_name(neuron_seq(j,1))),'/',char(neuron_name(neuron_seq(j,2)))])

    line([0,2005/24],[0,0],'color','m','linewidth',1.5)
    line([2143/24,2352/24],[0,0],'color','m','linewidth',1.5)
    line([0,2352/24],[1,1],'color','k','linewidth',1.5)
%     saveas(h,['L:\NeuronData\20180123\F14\figure\',char(neuron_name(neuron_seq(j,1))),char(neuron_name(neuron_seq(j,2))),'.fig'])
end
end
