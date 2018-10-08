function curvature = GetNeuronCurvature(Img_Folder,RFP_Pos_File,Neuron_Num,reverse,data_outputName)
% Calculate calcium transient of neurons

Src_Folder = 'K:\FluoImages\';
Neuoron_Pos_Folder = 'K:\NeuronData\';
Boundary_Folder = [Src_Folder Img_Folder 'Boundary\'];

% Load neuron positions from the file
RFP_Neuron_Pos = load([Neuoron_Pos_Folder RFP_Pos_File]);
disp('Load RFP neuron positions');

boundary_files = dir([Boundary_Folder '*.mat']);
total_num = length(boundary_files);

fine_arc_length = 5;
curvature_region = 0;
L = 2*curvature_region+1;
curvature = zeros(Neuron_Num*L,total_num);
mapped_pos = zeros(Neuron_Num,total_num);

for i=1:total_num
    disp(['Processing: ' num2str(i) '/' num2str(total_num)]);
    
%     %%%%% JUST for TEST!
%     image_name = [Src_Folder Img_Folder 'RFP\' boundary_files(i).name(1:end-4)];
%     img = imread(image_name);
%     %%%%%
     
    boundary_file = [Boundary_Folder boundary_files(i).name];
    data = load(boundary_file);
    if reverse
        data.boundary = data.boundary(end:-1:1,:);
    end
    
    rfp_pos = RFP_Neuron_Pos((i-1)*Neuron_Num+1:i*Neuron_Num,:);
    new_boundary = Boundary_Smooth(data.boundary,fine_arc_length);
    search_interval = 60;

    boundary_curvature = Compute_Curvature(new_boundary);
    boundary_points_num = length(new_boundary);
    for j=1:Neuron_Num
        % Extract fluorescence energy and background
        [~,map_index] = MapNeuronToBoundary([rfp_pos(j,2) rfp_pos(j,1)],new_boundary,search_interval);
        
        mapped_pos(j,i) = map_index;
        curvature_list = map_index-curvature_region:map_index+curvature_region;
        curvature_list(curvature_list<1) = 1;
        curvature_list(curvature_list>boundary_points_num) = boundary_points_num;
        curvature((j-1)*L+1:j*L,i) = boundary_curvature(curvature_list);
    end
    
%     % Draw mapped position
%     imagesc(img);axis image;hold on;
%     plot(new_boundary(:,2),new_boundary(:,1),'b.-');
%     for j=1:Neuron_Num
%         plot([rfp_pos(j,1) new_boundary(mapped_pos(j,i),2)],...
%             [rfp_pos(j,2) new_boundary(mapped_pos(j,i),1)],'r-');
%     end
%     hold off;
end

% Save the neuron activities
save([data_outputName '.mat'],'curvature','curvature_region','Neuron_Num',...
    'mapped_pos');

end


