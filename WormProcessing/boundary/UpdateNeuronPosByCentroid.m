function neuron_pos = UpdateNeuronPosByCentroid(fluo_img,np,radius,intensity_ratio)
% Compute neuron position (centroid)
% Input:
%        np: the rough neuron position (need to be updated)
%        radius: neuron size
%        fluo_img: fluorescence image
%        intensity_ratio: the ratio of intensity in neuron region, which can
%        be used to calculate theshold
% Output:neuron_pos the updated neuron position

[height,width] = size(fluo_img);

Nx = zeros(int32(2*radius+1),int32(2*radius+1));
Ny = zeros(int32(2*radius+1),int32(2*radius+1));
NI = zeros(int32(2*radius+1),int32(2*radius+1));

% Read the intensity and x/y positions around the anchor point
 Pixels_Num = 0;
 for x = (np(1)-radius):(np(1)+radius)
    for y = (np(2)-radius):(np(2)+radius)
        if ((x-np(1))^2 + (y-np(2))^2) <= radius^2
            Pixels_Num = Pixels_Num + 1;
            int_x = int32(x);
            int_y = int32(y);
            
            % check x
            if (int_x <= 0) 
                Nx(Pixels_Num) = 1;
            elseif (int_x >= width) 
                Nx(Pixels_Num) = width;
            else
                Nx(Pixels_Num) = int_x;
            end
            
            % check y
            if (int_y <= 0)
                Ny(Pixels_Num) = 1;
            elseif (int_y >= height)
                Ny(Pixels_Num) = height;
            else
                Ny(Pixels_Num) = int_y;
            end
            NI(Pixels_Num) = fluo_img(Ny(Pixels_Num),Nx(Pixels_Num));
        end
    end
 end

% Use intensity threshold to update neuron position
sort_NI = sort(NI,'descend');
Threshold = mean(sort_NI(1:int32(Pixels_Num*intensity_ratio)));% intensity threshold for extracting anchor neuron
Nx = Nx(1:Pixels_Num);
Ny = Ny(1:Pixels_Num);
NI = NI(1:Pixels_Num);
expected_pixel_list = (NI >= Threshold);

% Update UpAx, UpAy and UpIa
Nx = double(Nx(expected_pixel_list));
Ny = double(Ny(expected_pixel_list));
NI = double(NI(expected_pixel_list));

% Update anchor point in this frame
NI_Energy = sum(NI);
neuron_pos = [0,0];
neuron_pos(1) = sum(Nx.*NI)/NI_Energy;
neuron_pos(2) = sum(Ny.*NI)/NI_Energy;
end