
clear all;
Pre_Folder = 'F:\Data\';
% set parameters

% %%% 20180123-F3
% Neuron_Folder = '20180123-F3\';
% neuron_names = {'VA8','VB9','DB6','DA6','VA9','VB10'};

% %%% 20180406-F2
% Neuron_Folder = '20180406-F2\';
% neuron_names = {'VB5','DB4','VA5','VB6','VA6','DB5','VB8','VA8','VB9','DB6','VA9','VB10','VA10','DA7','VA11'};

%%% 20180413-F5
Neuron_Folder = '20180413-F5\';
neuron_names = {'VA6','VB7','DB5','VA7','VB8','VA8','VB9','DB6','DA6','VA9','VB10','VA11'};

% load neuron data
Out_Folder = [Pre_Folder Neuron_Folder];
neuron_data = load([Pre_Folder Neuron_Folder 'neuron_activity.mat']);
save([Pre_Folder Neuron_Folder 'neuron_names.mat'],'neuron_names');

% split data and draw figures
Green_Data = neuron_data.GCaMP_Ca;
Red_Data = neuron_data.RFP_Ca;
R = Green_Data./(Red_Data + eps);
T = size(R,2);
neuron_num = size(R,1);
neuron_activities = zeros(neuron_num,T);

% curvature of neurons
Curvature = neuron_data.Curvature;

% Get single neuron data
for i=1:neuron_num
    d = R(i,:);
    R0 = min(d);
    F = (d - R0)/(R0 + eps);
    neuron_activities(i,:) = F;
    
    neuron_activity = SmoothNeuronActivity(F);
    curvature = SmoothNeuronActivity(Curvature(i,:));
    
    % save neuron activity
    save([Out_Folder 'neuron_data\' char(neuron_names{i}) '.mat'],'neuron_activity');
    
    % save curvature
    save([Out_Folder 'curvature_data\' char(neuron_names{i}) '.mat'],'curvature');
end

