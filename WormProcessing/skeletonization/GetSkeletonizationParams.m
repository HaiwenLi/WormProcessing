function PARAMS = GetSkeletonizationParams()
PARAMS = struct('NEARBY_DIST'      , 40  ,...    % 骨架化时距离平方小于此值的点被认为是相邻的
                'METRICS_MAX'      , 60  ,...    % 骨架化时搜索
                'ANGLE_THRESHOLD_NAN', pi/3,...    % 骨架化时若找不到相邻点则在前方该角度内进行搜索
                'ALPHA'            , 1    ,...    % 骨架化时若找不到相邻点进行搜索时的参数，alpha越大表示优先选择角度不变的元素
                'ANGLE_ERROR'      , 1E-6 ,...
                'DEGREE_MAX'       , 5    ,...    % 注意！！！！尽管应该不会出现点度数大于该数的情况，但程序中没有对此检查！！！！
                'STORAGE_MAX'      , 20,...
                'MAX_END_NODE_NUM', 5);
end