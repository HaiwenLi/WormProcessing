output_name = 'L:\NeuronData\20180412\F1\green\neuron 2.txt';
pos = load(output_name);

wimages = dir(['J:\FluoImages\20180412\F1\GCaMP\','*tiff']);
search_interval = 7;
intensity_ratio = 0.3;
for i = 1:length(pos(:,1))
    worm_image = imread(['J:\FluoImages\20180412\F1\GCaMP\',wimages(i).name]);
    [pos(i,1),pos(i,2)] = update_center(pos(i,1),pos(i,2),search_interval,intensity_ratio,worm_image);
    disp(num2str(i));
end

        for i = 1:length(pos(:,1))     
            fid = fopen(output_name,'a');  
            fprintf(fid,'%d    %d\n',pos(i,1),pos(i,2));
            fclose(fid);        
        end
        