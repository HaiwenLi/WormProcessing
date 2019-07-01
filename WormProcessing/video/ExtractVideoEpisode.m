function ExtractVideoEpisode(video_name,start_time,end_time)
% Use ffmpeg to extract video episode
%
% Input parameters:
% video_name: AVI video name
% start_time, end_time: seconds

format = '.avi';
if ~isempty(strfind(video_name, format))
    index = strfind(video_name, format);
    new_video_name = [video_name(1:index-1) '_episode' format];
    str_start_time = ConvertTimeToString(start_time);
    str_end_time = ConvertTimeToString(end_time);
	command = ['ffmpeg.exe -i ' video_name ' -vcodec copy -acodec copy -ss '...
        str_start_time ' -to ' str_end_time ' ' new_video_name ' -y'];
    system(command);
    ConvertAVIToMP4(new_video_name);
else
	disp('Only process avi video');
end

end
