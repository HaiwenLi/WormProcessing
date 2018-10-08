function ExtractNeuronData(neuron_data,seq,OutFolder)

if ~isempty(seq)
	if ~exist(OutFolder,'dir')
	    mkdir(OutFolder);
	end
	OutFolder = [OutFolder '\'];

	for i=1:size(seq,1)
		range = [num2str(seq(i,1)) '-' num2str(seq(i,end))];
		data = load(neuron_data);

		GCaMP_Ca = data.GCaMP_Ca(:,seq(i,1):seq(i,end));
		GCaMP_Ba = data.GCaMP_Ba(:,seq(i,1):seq(i,end));
		RFP_Ca = data.RFP_Ca(:,seq(i,1):seq(i,end));
		RFP_Ba = data.RFP_Ba(:,seq(i,1):seq(i,end));
		Curvature = data.Curvature(:,seq(i,1):seq(i,end));
		frame_seq = [seq(i,1):seq(i,end)];

		% save neuron data
		save([OutFolder range '.mat'],'GCaMP_Ca','GCaMP_Ba','RFP_Ca','RFP_Ba','Curvature','frame_seq');
	end
end

end