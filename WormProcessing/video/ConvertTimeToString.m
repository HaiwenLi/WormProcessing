function s = ConvertTimeToString(time)
% Convert time to string, which can be used in ffmpeg program

hour = floor(time/3600);
minute = floor((time - 3600*hour)/60);
second = mod(time-3600*hour-60*minute,60);

s = [sprintf('%02d',hour) ':' sprintf('%02d',minute) ':' sprintf('%02d',second)];
end