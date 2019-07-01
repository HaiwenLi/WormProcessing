function neuron_names = ReadNeuronNames(filename,neuron_num)

fid = fopen(filename,'r');
neuron_names = cell(1,neuron_num);
for i=1:neuron_num
    neuron_names(i) = textscan(fid,'%s\n');
    neuron_names(i) = neuron_names{i};
end
fclose(fid);
end