F = 'L:\BehaviorImages\Images-2018\20180516\B3\';

video_name = [F 'processed.mp4'];
readObj = VideoReader(video_name);
folder = [F 'fig\'];
k = 1;
while hasFrame(readObj)
    img = readFrame(readObj);
%    if size(img,3) > 1
%        img = rgb2gray(img);
%    end
    imwrite(img, [folder num2str(k) '.tiff']);
    k = k+1;
end