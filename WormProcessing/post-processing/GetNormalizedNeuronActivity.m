function normalized_r = GetNormalizedNeuronActivity(GCaMP_activity, RFP_activity, data_range)
% calculate the normalized ratio

start_index = data_range(1);
end_index = data_range(2);

r = GCaMP_activity ./ (eps + RFP_activity);
r = r(:,start_index:end_index);
normalized_r = zeros(size(r));

for i=1:size(r,1)
    R_0 = min(r(i,:));
    normalized_r(i,:) = (r(i,:)-R_0)/(eps + R_0); % delta_R / R_0
end

end