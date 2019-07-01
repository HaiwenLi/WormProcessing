function out = ConvertRedIndex2Green(Fluo_Sync_Struc,frame_seq)
% convert frame index in red channel to green channel

out = zeros(size(frame_seq));
match_index = Fluo_Sync_Struc.match_index;

out(1) = find(match_index == frame_seq(1),1);
for i=2:length(frame_seq)
    si = out(i-1);
    while match_index(si) < frame_seq(i) % green image is more than red image
        si = si + 1;
    end
    out(i) = start;
end
end