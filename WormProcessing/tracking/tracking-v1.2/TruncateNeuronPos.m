function TruncateNeuronPos(Folder,tracking_index,FlouType,origin_start,frame_seq)
% Repeat the neuron position for the length of frame_seq times
% neuron pos format: [x,y]

% Set pos folder
posFolder = [Folder 'neuron_pos\' FlouType '\'];

Tracking_Length = length(frame_seq);
neuron_num = length(tracking_index);
Pos = zeros(Tracking_Length, 2);

% ��Ҫע�⣺��ʱ���е���Ԫλ���Ѿ��õ������ܲ�����ӷ�ʽд�ĵ�������ֱ�Ӷ�ȡ�ĵ�
% �޸��������
for i=1:neuron_num
    output_name = [posFolder,sprintf('neuron %02d',tracking_index(i)),'.txt'];
    origin_neurons_pos = load(output_name);
    pos_start = frame_seq(1)-origin_start+1;
    pos_end = frame_seq(end)-origin_start+1;
    Pos(:,1) = origin_neurons_pos(pos_start:pos_end,1);
    Pos(:,2) = origin_neurons_pos(pos_start:pos_end,2);
    write_neuronpos(posFolder,tracking_index(i),Pos(:,1),Pos(:,2),'w');
end

end