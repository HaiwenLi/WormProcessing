frame_rate = 24;
T = floor(101*frame_rate);
delta_t = 1/24;
% v_r_corr = zeros(3,20);
for i = 1:20
    figure;
     R = GCaMP_Ca(i,1:T)./(eps + RFP_Ca(i,1:T));
    R = RemoveOutlier(R);
%     R_sorted = sort(R);
    R_0 = min(R);
%     R_0 = mean(R_sorted(1:floor(p*length(R))));
    R = (R-R_0)/(eps + R_0);
%     R = (R-R_0);
%     R = detrend(R, 'linear', bp);

    Smooth_R = SmoothNeuronActivity(R);  
    
cross_corr_f1 = crosscorr(Smooth_R(forward_1),smooth_speed(forward_1) , floor(length(forward_1)-1));
time = ((1:length(cross_corr_f1)) - (length(cross_corr_f1)+1)/2)*delta_t;
time_index = find(abs(cross_corr_f1)==max(abs(cross_corr_f1)));
v_r_corr(1,i) = time(time_index(1));
plot(time,cross_corr_f1);hold on;

cross_corr_f2 = crosscorr(Smooth_R(forward_2),smooth_speed(forward_2) , floor(length(forward_2)-1));
time = ((1:length(cross_corr_f2)) - (length(cross_corr_f2)+1)/2)*delta_t;
time_index = find(abs(cross_corr_f2)==max(abs(cross_corr_f2)));
v_r_corr(2,i) = time(time_index(1));
plot(time,cross_corr_f2);hold on;

cross_corr_b = crosscorr(Smooth_R(backward),smooth_speed(backward) , floor(length(backward)-1));
time = ((1:length(cross_corr_b)) - (length(cross_corr_b)+1)/2)*delta_t;
time_index = find(abs(cross_corr_b)==max(abs(cross_corr_b)));
v_r_corr(3,i) = time(time_index(1));
plot(time,cross_corr_b);hold on;

legend('forward 1','forward 2','backward');
title(['Neuron ',num2str(i)]);

end

