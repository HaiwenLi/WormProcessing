function BoundaryBasedTracking(Folder, FluoType)
% Tracking neurons by boundary

% Tracking Parameters Setting


% Set image, extracted neuron and boundary folder
if strcmp(FluoType,'red')
    ImageFolder = [Folder '\RFP\'];
    NeuronFolder = [Folder '\RFP_Neuron\'];
elseif strcmp(FluoType,'green')
    ImageFolder = [Folder '\GCaMP\'];
    NeuronFolder = [Folder '\GCaMP_Neuron\'];
end
BoundaryFolder = [Folder '\Boundary\'];

% First, use boundary to rearrange the neuron sequences

% Second, use neuron positions, intensities, offsets to track neuron

% Third, save neuron positions

end