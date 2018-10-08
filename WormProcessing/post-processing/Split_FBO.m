function Split_FBO(Folder, neuron_data, split_patten)
% 按照Forward，Backward，Omega分割神经元数据
%
% Input Parametrs:
% neuron_data: data filename
% 

Forward_Folder = [Folder 'forward'];
Backward_Folder = [Folder 'backward'];
Omega_Folder = [Folder 'omega'];

forward_seq = split_patten.forward;
backwrad_seq = split_patten.backward;
omega_seq = split_patten.omega;

ExtractNeuronData(neuron_data, forward_seq, Forward_Folder);
ExtractNeuronData(neuron_data, backward_seq, Backward_Folder);
ExtractNeuronData(neuron_data, omega_seq, Omega_Folder);

end

