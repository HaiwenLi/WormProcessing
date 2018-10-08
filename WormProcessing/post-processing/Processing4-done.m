ND_Folder = 'H:\NeuronData\'; % Neuron Data Folder
Img_Folder =  'H:\FluoImages\';

% Get neuron activities of the latest data

%% 20180807
GetNeuronActivity_V1([Img_Folder '20180807\F1\'], [ND_Folder '20180807\F1\'], 11, 1:2880, [ND_Folder '20180807\F1\Neuron_Activity']);

GetNeuronActivity_V1([Img_Folder '20180807\F5\'], [ND_Folder '20180807\F5\'], 20, 902:3839, [ND_Folder '20180807\F5\Neuron_Activity']);

GetNeuronActivity_V1([Img_Folder '20180807\F6\'], [ND_Folder '20180807\F6\'], 20, 1502:3204, [ND_Folder '20180807\F6\Neuron_Activity']);

%% 20180813-P2
GetNeuronActivity_V1([Img_Folder '20180813-P2\F8\'], [ND_Folder '20180813-P2\F8\'], 12, 2176:3594, [ND_Folder '20180813-P2\F8\Neuron_Activity']);

GetNeuronActivity_V1([Img_Folder '20180813-P2\F9\'], [ND_Folder '20180813-P2\F9\'], 8, 1891:3665, [ND_Folder '20180813-P2\F9\Neuron_Activity']);

GetNeuronActivity_V1([Img_Folder '20180813-P2\F10\'], [ND_Folder '20180813-P2\F10\'], 13, 2056:3161, [ND_Folder '20180813-P2\F10\Neuron_Activity']);

GetNeuronActivity_V1([Img_Folder '20180813-P2\F14\'], [ND_Folder '20180813-P2\F14\'], 20, 1:3000, [ND_Folder '20180813-P2\F14\Neuron_Activity']);
