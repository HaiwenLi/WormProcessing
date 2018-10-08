function smooth_activity = ComputeSmoothGCaMPActivity(activity,crop_range)

% Load activity data and draw figures
load(activity);

% T = size(GCaMP_Ca,2);
% T = floor(101*frame_rate);
T = length(crop_range);

N = size(GCaMP_Ca,1); % neuron number
smooth_activity = zeros(N,T);
for i=1:N
    R = GCaMP_Ca(i,crop_range)./(eps + RFP_Ca(i,crop_range));
    R = RemoveOutlier(R);
    R_0 = min(R);
    R = (R-R_0)/(eps + R_0);
    Smooth_R = SmoothNeuronActivity(R);
    
    smooth_activity(i,:) = Smooth_R;
end

end