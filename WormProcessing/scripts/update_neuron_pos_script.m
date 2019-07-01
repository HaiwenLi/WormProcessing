
%%%%% update neuron pos %%%%%
private_update('', ); % 


function private_update(Folder, frame_seq)
% private function for this script
% update neuron positions

update_positions([Folder 'RFP\'], frane_seq(1), frame_seq, [Folder 'neuron_pos\red.txt']);
update_positions([Folder 'GCaMP\'], frane_seq(1), frame_seq, [Folder 'neuron_pos\green.txt']);

end