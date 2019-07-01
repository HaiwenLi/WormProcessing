%%%%% Claculate Frequency of Neuron Activities
frame_rate = 24;

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

% calculate data frequency
frequency = zeros(NNum, 1);
for iNeuron = 1:NNum
	frequency(i) = ComputeFrequency(smooth_r(iNeuron, :));
end

% draw results
figure;
plot(frequency,'ks-');
set(gca, 'xtick', 1:length(neuron_names));
set(gca, 'xticklabel', neuron_names);

% calculate data frequency in continuous moving window
window_size = 10*frame_rate;
moving_frequency = zeros(NNum, T - ceil(window_size) + 1);

for iNeuron = 1:NNum
	for time = 1:(T-ceil(window_size)+1)
		window_r = smooth_r(iNeuron, time:(time+window_size));
		moving_frequency(iNeuron, time) = ComputeFrequency(window_r);
	end
end

% draw results
figure;
imagesc(moving_frequency);axis image;

