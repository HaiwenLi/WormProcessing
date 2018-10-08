function ComputeCrossCorr(data1,data2,delta_t,corr_time)
% Compute cross correlation between data1 and data2
% Input:
% 
cross_corr = crosscorr(data1, data2, floor(corr_time/delta_t));
time = ((1:length(cross_corr)) - (length(cross_corr)+1)/2)*delta_t;
plot(time,cross_corr,'LineWidth',2,'Color','k');
% axis([-corr_time-0.1 corr_time+0.1 min(cross_corr)-0.2 max(cross_corr)+0.2]);

xlabel('Time (s)');
set(gca,'FontSize',14);

end