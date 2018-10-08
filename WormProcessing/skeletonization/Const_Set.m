function CONST_VALUE = Const_Set()

CONST_VALUE = struct('IMAGE_TAG'        , '',...  % 文件名称前缀
                     'IMAGE_INDEX'      , 0 ,...% 数组顺序存储所有待处理图片的序号
                     'PIC_NUM'          , 1     ,...    % 待处理图片数量
                     'IMAGE_SIZE'       , [0, 0],...    % 图像尺寸
                     'ROI_section'      , [10 6 8],...  % 标示感兴趣区域在中心线上的比例
                     'PARTITION_NUM'    , 100   ,...    % 将线虫中心线等分的份数
                     'SHOW_IMAGE'       , 'on'  ,...    % 程序是否显示中间图像
                     'SAVE_DATA'        , 'on' ,...    % 程序是否保存数据
                     'EDGE_SHRUNK'      , 3     ,...    % 取线虫边缘的参数，到外部距离小于此值的点被作为边缘
                     'AREA_THRESHOLD_1' , 1000  ,...    % 二值化后面积小于此值的1值连通区域会被筛选掉，以保留图像中线虫的部分
                     'AREA_THRESHOLD_2' , 100   ,...    % 二值化后面积小于此值的0值连通区域会被筛选掉，以去除线虫内因二值化阈值过小而导致的空隙
                     'BINARY_THRESHOLD' , 35    ,...    % 区分线虫与背景的阈值，取所有值小于它的点形成线虫区域
                     'RAP_THRESHOLD'    , 0.6   ,...    % 宽度大于线虫平均宽度的该倍数时，认为线虫发生了粘连
                     'LAPLACIAN_THRESHOLD',-0.3 ,...    % 对距离做laplacian变换后的矩阵中小于此值的点被取为中心线候选点
                     'NEARBY_DIST'      , 100     ,...    % 骨架化时距离平方小于此值的点被认为是相邻的
                     'METRICS_MAX'      , 300    ,...    % 骨架化时搜索
                     'ANGLE_THRESHOLD_NAN', pi/3,...    % 骨架化时若找不到相邻点则在前方该角度内进行搜索
                     'ALPHA'            , 1     ,...    % 骨架化时若找不到相邻点进行搜索时的参数，alpha越大表示优先选择角度不变的元素
                     'ANGLE_ERROR'      , 1E-6  ,...
                     'DEGREE_MAX'       , 5     ,...    % 注意！！！！尽管应该不会出现点度数大于该数的情况，但程序中没有对此检查！！！！
                     'STORAGE_MAX'      , 20,...
                     'MAX_END_NODE_NUM', 5);

% CONST_VALUE.IMAGE_INDEX(36:39) = [];
% CONST_VALUE.PIC_NUM = length(CONST_VALUE.IMAGE_INDEX);
% % -------------------------------获取图片尺寸-----------------------------------
% image_info = imfinfo(strcat(CONST_VALUE.IMAGE_TAG,num2str(CONST_VALUE.IMAGE_INDEX(1)),'.tiff'));
% CONST_VALUE.IMAGE_SIZE(1) = image_info.Height;
% CONST_VALUE.IMAGE_SIZE(2) = image_info.Width;
% save('data/CONST_VALUE.mat','CONST_VALUE');
end