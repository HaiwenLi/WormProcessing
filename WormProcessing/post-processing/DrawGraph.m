function DrawGraph(image_index, uniform)

if isempty(image_index)
    draw1(uniform);
    return;
end
for i = 1:length(image_index)
    a = load(strcat('data/pic_',num2str(image_index(i)),'.mat'));
    figure(1);
    width = (a.worm_coodinate_range(4) - a.worm_coodinate_range(3))*2;
    height = (a.worm_coodinate_range(2) - a.worm_coodinate_range(1))*2;
    set(gcf,'Units','pixels','Position',[200,150,width,height]);
    set(gca,'Units','pixels','Position',[0,0,width,height]);
    draw1(a.graph_after_prune, a.binary_image);
    b = getframe();
    imwrite(b.cdata,strcat('pic1/pic_',num2str(image_index(i)),'.bmp'));
    close 1;
end
end

function draw1(uniform)
set(0,'DefaultFigureVisible', 'on');
l = length(uniform);
for i = 1:l
    for j = 1:uniform{i}.degree
        nb = uniform{i}.adjacent(j);
        plot([uniform{i}.center(2),uniform{nb}.center(2)],[uniform{i}.center(1),uniform{nb}.center(1)],'b-'),hold on;
    end
     if uniform{i}.degree~=2 || mod(i,2) == 1
        text(uniform{i}.center(2), uniform{i}.center(1)-0.35 ,num2str(i));
        plot(uniform{i}.center(2),uniform{i}.center(1), 'b.','MarkerSize',5),hold on;
     end
end
end