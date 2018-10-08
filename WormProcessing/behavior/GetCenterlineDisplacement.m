function displacement = GetCenterlineDisplacement(Res_Folder)
% displacement: [y,x]

worm_pos = GetWormPos(Res_Folder,'');
displacement(:,1) = worm_pos(:,1) - worm_pos(1,1);
displacement(:,2) = worm_pos(:,2) - worm_pos(1,2);

end