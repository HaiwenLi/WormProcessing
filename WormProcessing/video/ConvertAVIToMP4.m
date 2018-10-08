function ConvertAVIToMP4(video_name)
% Using ffmpeg to post-process the video
%
% Input parameters:
% video_name: the name of video needed to be post-processed
% https://cn.mathworks.com/matlabcentral/fileexchange/42296-ffmpeg-toolbox

% Check the video format is avi
if ~isempty(strfind(video_name,'.avi'))
	new_videoname = strrep(video_name,'.avi','.mp4');
    system(['ffmpeg.exe -i ' video_name ' ' new_videoname ' -y']); 
else
	disp('Only convert avi video into mp4 format')
end

end