function L = Boundary_Length(start_index,end_index,boundary)
% Calculate the length of boundary from start_index to end_index

arc_len = (boundary(start_index+1:end_index,:)-boundary(start_index:end_index-1,:)).^2;
L = sqrt(sum(arc_len.^2,2));

end
    