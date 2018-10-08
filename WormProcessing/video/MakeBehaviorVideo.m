function MakeBehaviorVideo(Image_Folder,frame_seq,freq,outputname)

Image_Format = '.tiff';

writerObj = VideoWriter([exportFolder outputname '.mp4'],'MPEG-4');
writerObj.FrameRate = freq;
open(writerObj);

for i=1:length(frame_seq)
	image_index = frame_seq(i);
    image_name = [Image_Folder num2str(image_index) Image_Format];
    image = imread(image_name);
    writeVideo(writerObj, image);
end

close(writerObj);
end

