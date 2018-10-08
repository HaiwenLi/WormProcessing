function preload_neuron(posFile,neuron_num,frame_index)
% Preload neuron positions from one file, which usually is manully created,
% and the tracking neurons are determined by hand
%
% Input parameters:
% posFile: the file contais positiond of tracking neurons
%
% Output parameters:
% neuronIntensity: the intensities of neurons
% neuronDist: the distance between two neurons
% neuronOffset: the offset of one neuron between two frames

neuronPos = load(posFile);

end