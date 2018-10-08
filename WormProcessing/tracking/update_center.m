function [xnext,ynext] = update_center(xprev,yprev,search_interval,Intensity_Ratio,Wimage)
        Cx = zeros(1,search_interval*search_interval);
        Cy = zeros(1,search_interval*search_interval);
        Ic = zeros(1,search_interval*search_interval);
        % Update center of mass
        Pixels_Num = 0; k = 0;
        image_size = size(Wimage);
        for x = min(max(1,xprev-search_interval),image_size(2)):min(max(1,xprev+search_interval),image_size(2))
            for y = min(max(1,yprev-search_interval),image_size(1)):min(max(1,yprev+search_interval),image_size(1))
                 if (x-xprev)^2+(y-yprev)^2 <= (search_interval+1)^2
                    k = k+1;
                    Cx(k) = x;
                    Cy(k) = y;
                    Ic(k) = Wimage(int32(y),int32(x));
                 end
            end
        end
         Pixels_Num = k; % number of pixels in search region (circle with radius search interval)
    
    %     Ax=double(Ax);
    %     Ay=double(Ay);
        sort_Ic = sort(Ic,'descend');
        Threshold = mean(sort_Ic(1:int32(Pixels_Num*Intensity_Ratio)));% intensity threshold for extracting anchor neuron
        UpCx = Cx(1:Pixels_Num);
        UpCy = Cy(1:Pixels_Num);
        UpIc = Ic(1:Pixels_Num);
        expected_pixel_list = (UpIc >= Threshold);

        % Update UpAx, UpAy and UpIa
        UpCx = double(UpCx(expected_pixel_list));
        UpCy = double(UpCy(expected_pixel_list));
        UpIc = double(UpIc(expected_pixel_list));
        
        if isempty(find(UpIc>0))
            UpIc = UpIc + 1;
        end

        % Update center of mass
        UpIc_Energy = sum(UpIc);
        xnext = sum(UpCx.*UpIc)/UpIc_Energy;
        ynext = sum(UpCy.*UpIc)/UpIc_Energy;
%         disp(['Center_x = ',num2str(Center_x),' Center_y = ',num2str(Center_y)]);
end