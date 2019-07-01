%Jesse Marshall
%April 20 2015


%% Example of a rose (polar histogram) plot with colored, shaded areas
%change default figure background from an annoying gray
set(0,'defaultfigurecolor','w')
%change plot background color (this is the default)
whitebg(0,'w')

%Generate data for plotting
num_wedges = 30;
wedge_centers = 0:(2*pi)/num_wedges:(2*pi);

% generate colormaps
num_cmaps = 3;
cmap = cell(1,3);
cmap{2} = parula(num_wedges);
cmap{1} = flipud(lbmap(num_wedges,'RedBlue'));
cmap{3} = cbrewer('div','RdYlGn',num_wedges);

view_list{1} = [90 -90];
view_list{2} = [180 -90];
view_list{3} = [270 -90];


for kk =1:num_cmaps
for ll=num_wedges:(-1):1
%generate a separate figure for each wedge    
hf = figure(1);
%use subplot tight to keep tight spacing between objects
subplot_tight(1,num_cmaps,kk)

set(hf,'Color','w') %change figure background again

%draw the rose
hfig= rose(repmat(wedge_centers(ll),ll,1),wedge_centers);
if(ll ==num_wedges)
    hold on
end

%turn off the edges
set(hfig,'Linestyle','none')
%make the patches (tricky -- I had to google how to do this!)
hpatch = patch( get(hfig,'XData'), get(hfig,'YData'), cmap{kk}(ll,:),'EdgeColor','none');
%change the opacity
alpha(hpatch, 0.5) 
%turn off the extraneous lines in the plot (tricky again)
delete(findall(ancestor(hfig,'figure'),'HandleVisibility','off','type','line','-or','type','text'));
end
hold off
%change the perspective
view(view_list{kk})
end

%Changing the alpha changed the renderer, so we have to use svg to export
plot2svg('Rose_Example.svg',hf,'png' )



%% Example of a bad rose plots
hf = figure(5)
%change default figure background from an annoying gray
set(0,'defaultfigurecolor','w')
%change plot background color (this is the default)
whitebg(0,'w')

%Generate data for plotting
num_wedges = 30;
wedge_centers = 0:(2*pi)/num_wedges:(2*pi);
wedge_heights = [];
for ll=1:num_wedges
    wedge_heights=cat(1,wedge_heights,repmat(wedge_centers(ll),ll,1));
end


%demonstrate normal plotting
rose(wedge_heights,wedge_centers)
print('-dpng','Rose_Example_bad.png' )




%% Plot examples of a poorly plotted and a well-plotted matrix
%poorly plotted
color_matrix = (1:100)'*(1:100);
figure(5)
set(gcf,'Color',[0.8 0.8 0.8])

subplot(1,2,1)
imagesc(color_matrix)
colormap(jet)

subplot(1,2,2)
imagesc(color_matrix)
colormap(hot)
print('-dpng','example_colormaps_bad.png')

%well plotted
color_matrix = (1:100)'*(1:100);
figure(6)
%set the default color as white
set(gcf,'Color','w')

subplot_tight(1,2,1)
imagesc(color_matrix)
colormap(jet)

%these keep the axes tight and turn off the unneeded ticks
axis off
axis tight

%this file-exchange function 
freezeColors

subplot_tight(1,2,2)
imagesc(color_matrix)
colormap(hot)
axis off
axis tight
print('-depsc','example_colormaps_good.eps')
print('-dpng','example_colormaps_good.png')





%% Plot examples of different color matricies
% First generate a matrix of data
color_matrix = (1:100)'*(1:100);
num_plots = 5;

%I use FEX function subplot_tight to minimize whitespace
figure(2)
subplot_tight(1,num_plots,1)
%change figure background to white
set(gcf,'Color','w')
imagesc(color_matrix)

axis off %turn off the axes
axis tight %make the axes square
colormap(jet)

%Typically figures are limited to one colormap, this FEX function lets you
%use multiple colormaps in different subplots
freezeColors

% repeat for other examples
subplot_tight(1,num_plots,2)
imagesc(color_matrix)
axis off
cmap = cbrewer('seq','YlGn',100);
colormap(cmap)
freezeColors

subplot_tight(1,num_plots,3)
imagesc(color_matrix)
axis off
colormap(parula) %MATLAB's new default!
freezeColors

subplot_tight(1,num_plots,4)
imagesc(color_matrix)
axis off

%the colorbrewer FEX
cmap = cbrewer('div','PuOr',100);
colormap(flipud(cmap))
freezeColors

subplot_tight(1,num_plots,5)
imagesc(color_matrix)
axis off

%the lbmap FEX
cmap = lbmap(100,'RedBlue');
colormap(flipud(cmap))
freezeColors

%% print to both vector (.eps) and bitmap (.png) formats
print('-depsc','example_colormaps.eps')
print('-dpng','example_colormaps.png')



%% Demonstrate some other example plots
numpts = 50;
rand_x = 2+randn(numpts ,1);
rand_y = -0.4+2*randn(numpts ,1);
marker_sizes = abs(300+100*randn(numpts,1));

colors = lbmap(50,'RedBlue');

figure(10)
subplot(1,2,1)
violin([rand_x rand_y],'facecolor',[[1 0 0];[0 0 1]],'medc','','mc','k')
legend off
box off
axis off

subplot(1,2,2)
scatter(rand_x,rand_y,marker_sizes,colors,'filled')
alpha(0.8)
axis off
box off
print('-dpng','example_violin_bubble.png')


rand_connections = abs(rand(numpts,numpts));
figure(9)
schemaball(rand_connections)
print('-depsc','example_circos.eps')
print('-dpng','example_circos.png')
  %  circularGraph(rand_connections,'Color',colors)