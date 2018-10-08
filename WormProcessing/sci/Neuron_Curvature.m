function Neuron_Curvature(FluoData)
% Curvature and Neuron Activities Deconvolution
%

close all;

% parameters
frame_rate = 24;
font_size = 14;

% data preparation
neuron_names = FluoData.neuron_names;
curvature = FluoData.Neuron_Curvature;
neuron_activity = FluoData.GCaMP_activities ./ FluoData.RFP_activities;

% denoise the neuron activities
for i=1:length(neuron_names)
    neuron_activity(i,:) = RemoveOutlier(neuron_activity(i,:));
%     neuron_activity(i,:) = SmoothNeuronActivity(neuron_activity(i,:));
end

% draw curvature and neuron activities
figure(1);
subplot(2,1,1);
imagesc(curvature);colormap(jet);colorbar;
set(gca,'ytick',1:length(neuron_names));
set(gca,'yticklabel',neuron_names);
set(gca,'xtick',0:10*frame_rate:length(neuron_activity));
set(gca,'xticklabel',0:10:(length(neuron_activity)/frame_rate));

subplot(2,1,2);
imagesc(neuron_activity);colormap(jet);colorbar;
set(gca,'ytick',1:length(neuron_names));
set(gca,'yticklabel',neuron_names);
set(gca,'xtick',0:10*frame_rate:length(neuron_activity));
set(gca,'xticklabel',0:10:(length(neuron_activity)/frame_rate));
% set(gca,'FontSize',font_size);

% deconvolution by fft
% curvature_fft = fft2(curvature);
% neuron_fft = fft2(neuron_activity);
% SNR = 5.0;
% kernel_fft = (conj(neuron_fft).*curvature_fft)./(abs(neuron_fft).^2 + SNR);
% max_kernel_energy = max(max(abs(kernel_fft)));
% kernel_fft(abs(kernel_fft) < 0.2*max_kernel_energy | abs(kernel_fft) > 0.8*max_kernel_energy) = 0;
% kernel = ifft2(kernel_fft);

kernel = zeros(size(curvature));
r = zeros(size(curvature));
% matlab deconv code is not proper for this problem
for i=1:length(neuron_names)
%     [kernel(i,:), r(i,:)] = deconv(curvature(i,:),neuron_activity(i,:));
%     [kernel(i,1:end-1), r(i,1:end-1)] = deconv(neuron_activity(i,2:end),curvature(i,1:end-1));
end

% show kernel
figure(2);
imagesc(kernel);colormap(jet);colorbar;
set(gca,'ytick',1:length(neuron_names));
set(gca,'yticklabel',neuron_names);
set(gca,'xtick',0:10*frame_rate:length(neuron_activity));
set(gca,'xticklabel',0:10:(length(neuron_activity)/frame_rate));

figure(3);
imagesc(r);colormap(jet);colorbar;
imagesc(kernel);colormap(jet);colorbar;
set(gca,'ytick',1:length(neuron_names));
set(gca,'yticklabel',neuron_names);
set(gca,'xtick',0:10*frame_rate:length(neuron_activity));
set(gca,'xticklabel',0:10:(length(neuron_activity)/frame_rate));

s = kernel(:,1);
s(12) = nan;
figure(4);plot(s,'-o');
set(gca,'xtick',1:length(neuron_names));
set(gca,'xticklabel',neuron_names);

end