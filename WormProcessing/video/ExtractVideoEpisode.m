function ExtractVideoEpisode(video_name,start_time,end_time)
% Use ffmpeg to extract video episode
%
% Input parameters:
% video_name: AVI video name
% start_time, end_time: seconds

if ~isempty(strfind(video_name,'.avi'))
    index = strfind(video_name,'.avi');
    new_video_name = [video_name(1:index-1) '_episode.avi'];
    str_start_time = ConvertTimeToString(start_time);
    str_end_time = ConvertTimeToString(end_time);
	command = ['ffmpeg.exe -i ' video_name ' -vcodec copy -acodec copy -ss '...
        str_start_time ' -to ' str_end_time ' ' new_video_name ' -y'];
    system(command);
    
%     % Convert video into avi format
%     ConvertAVIToavi(new_video_name);
else
	disp('Only process avi video');
end

end
