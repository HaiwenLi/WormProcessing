%%%%% Claculate Correlation Between Neuron Activities

% data smooth
NNum = size(r,1); % neuron number, r is neuron activities (GCaMP/RFP)
T = size(r,2);

smooth_r = zeros(size(r));
smooth_type = 'moving';

for iNeuron = 1:NNum
	smooth_r(iNeuron, :) = smooth_data(r(iNeuron, :), smooth_type);
end
figure;
imagesc(smooth_r);axis image; % show smooth neuron activities

% calculate the correlation between each pair of neuron activities
neuron_corr = zeros(NNum, NNum);
for iNeuron = 1:NNum
	for jNeuron = 1:NNum
		if jNeuron < iNeuron
			neuron_corr(iNeuron, jNeuron) = neuron_corr(jNeuron, iNeuron);
		else
			neuron_corr(iNeuron, jNeuron) = corr(smooth_r(iNeuron, :), smooth_r(jNeuron, :));
		end
	end
end