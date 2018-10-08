function [xnext,ynext] = UpdateNeuronPos(xprev,yprev,search_interval,Intensity_Ratio,Wimage)
% Update the neuron position by its centroid

Cx = zeros(1,search_interval*search_interval);
Cy = zeros(1,search_interval*search_interval);
Ci = zeros(1,search_interval*search_interval);

k = 0;
for x=(xprev-search_interval):(xprev+search_interval)
    for y=(yprev-search_interval):(yprev+search_interval)
         if (x-xprev)^2+(y-yprev)^2 <= (search_interval+1)^2
            k = k+1;
            Cx(k) = max(1, int32(x));
            Cy(k) = max(1, int32(y));
            Ci(k) = Wimage(Cy(k),Cx(k));
         end
    end
end
Pixels_Num = k; % number of pixels in search region (circle with radius search interval)

sort_Ic = sort(Ci,'descend');
Threshold = mean(sort_Ic(1:int32(Pixels_Num*Intensity_Ratio)));% intensity threshold for extracting anchor neuron
UpCx = Cx(1:Pixels_Num);
UpCy = Cy(1:Pixels_Num);
UpCi = Ci(1:Pixels_Num);
expected_pixel_list = (UpCi >= Threshold);

% Update UpAx, UpAy and UpIa
UpCx = double(UpCx(expected_pixel_list));
UpCy = double(UpCy(expected_pixel_list));
UpCi = double(UpCi(expected_pixel_list));

if isempty(find(UpCi>0))
    UpCi = UpCi + 1;
end

% Update center of mass
UpIc_Energy = sum(UpCi);
xnext = sum(UpCx.*UpCi)/UpIc_Energy;
ynext = sum(UpCy.*UpCi)/UpIc_Energy;
% disp(['Center_x = ',num2str(Center_x),' Center_y = ',num2str(Center_y)]);
end