% worm body motor neurons class
classdef WormMNs
    properties
        VA_MNs = {'VA1','VA2','VA3','VA4','VA5','VA6','VA7','VA8','VA9','VA10','VA11','VA12'}; % 12 VA motor neurons
        DA_MNs = {'DA1','DA2','DA3','DA4','DA5','DA6','DA7','DA8'};% 9 DA motor neurons
        VB_MNs = {'VB1','VB2','VB3','VB4','VB5','VB6','VB7','VB8','VB9','VB10','VB11'};% 11 VB motor neurons
        DB_MNs = {'DB1','DB2','DB3','DB4','DB5','DB6','DB7'}; % 7 DB VA motor neurons
        VC_MNs = {'VC1','VC2','VC3','VC4','VC5','VC6'};% 6 VC motor neurons
    end % end of properties
    
    methods
        function neuron_index = GetNeuronIndex(obj, neuron_list, neuron_type)
            % neuron list must be cell
            neuron_type = upper(neuron_type);
            found_type = 0;
            if strcmp(neuron_type, 'A') == 1
                Neuron_Names = [obj.VA_MNs, obj.DA_MNs];
                found_type = 1;
            elseif strcmp(neuron_type, 'B') == 1
                Neuron_Names = [obj.VB_MNs, obj.DB_MNs];
                found_type = 1;
            elseif (strcmp(neuron_type, 'C') == 1) || (strcmp(neuron_type, 'VC') == 1)
                Neuron_Names = obj.VC_MNs;
                found_type = 1;
            elseif strcmp(neuron_type, 'VA') == 1
                Neuron_Names = obj.VA_MNs;
                found_type = 1;
            elseif strcmp(neuron_type, 'DA') == 1
                Neuron_Names = obj.DA_MNs;
                found_type = 1;
            elseif strcmp(neuron_type, 'VB') == 1
                Neuron_Names = obj.VB_MNs;
                found_type = 1;
            elseif strcmp(neuron_type, 'DB') == 1
                Neuron_Names = obj.DB_MNs;
                found_type = 1;
            else
                disp('No such neuron type');
            end
            
            if (found_type)
                neuron_index = obj.FindIndex(Neuron_Names,neuron_list);
            end
        end
        
        function index = FindIndex(obj,names,list)
            index = zeros(1,length(list));
            len = 0;
            for i=1:length(list)
                for j=1:length(names)
                    if strcmp(char(names{j}), char(list{i})) == 1
                        len = len+1;
                        index(len) = i;
                        break;
                    end
                end
            end
            index = index(1:len);
        end
        
    end % end of methods
end