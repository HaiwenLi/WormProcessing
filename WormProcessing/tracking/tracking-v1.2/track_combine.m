function track_combine(Folder,output_name)
% Combine all tracked neuron positions into one signle file

Neuron_Files = dir([Folder 'neuron*.txt']);
Neuron_Num = length(Neuron_Files);

% Load all neuorn positions
for i=1:Neuron_Num
    neuron_file = [Folder Neuron_Files(i).name];
    neuron_pos = load(neuron_file);
    if i==1
        Tracking_Length = length(neuron_pos);
        X_Pos = zeros(Tracking_Length, Neuron_Num);
        Y_Pos = zeros(Tracking_Length, Neuron_Num);
    end
    X_Pos(:,i) = neuron_pos(:,1);
    Y_Pos(:,i) = neuron_pos(:,2);
end

% Write all neuron positions into file
fid = fopen(output_name,'wt');
for n = 1:Tracking_Length
    for i = 1:Neuron_Num
        fprintf(fid,'%d    %d\n',X_Pos(n,i),Y_Pos(n,i));
    end
end
fclose(fid);
disp(['Has combined neuron positions in ' Folder]);
