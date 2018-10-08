function ExtractNeurons(Folder,OutFolder,frame_seq)
% Extract neurons from image in Folder

image_format = 'tiff';
image_names = dir([Folder '*.' image_format]);

if strcmp(frame_seq, 'all') == 1
    frame_seq = 1:length(image_names);
end

tic
for i=1:length(frame_seq)
	image_name = image_names(frame_seq(i)).name;
    disp([num2str(frame_seq(i)) ': ' image_name]);
    
	img = imread([Folder image_name]);

	% Extract neurons in image
	[worm_region,neurons,intensities] = ExtractNeuronInImage(img);

	% Save the neurons data
	output_name = [OutFolder image_name '.mat'];
	save(output_name, 'worm_region', 'neurons','intensities');

% 	% Update neuron intensity threshold
% 	if i~=1
% 		Neuron_Intensity = min(intensities)*0.95;
% 	end
end
time = toc;
disp(['Total time cost: ' num2str(time) ' s']);
end