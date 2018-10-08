function PARAMS = GetSkeletonizationParams()
PARAMS = struct('NEARBY_DIST'      , 40  ,...    % �Ǽܻ�ʱ����ƽ��С�ڴ�ֵ�ĵ㱻��Ϊ�����ڵ�
                'METRICS_MAX'      , 60  ,...    % �Ǽܻ�ʱ����
                'ANGLE_THRESHOLD_NAN', pi/3,...    % �Ǽܻ�ʱ���Ҳ������ڵ�����ǰ���ýǶ��ڽ�������
                'ALPHA'            , 1    ,...    % �Ǽܻ�ʱ���Ҳ������ڵ��������ʱ�Ĳ�����alphaԽ���ʾ����ѡ��ǶȲ����Ԫ��
                'ANGLE_ERROR'      , 1E-6 ,...
                'DEGREE_MAX'       , 5    ,...    % ע�⣡����������Ӧ�ò�����ֵ�������ڸ������������������û�жԴ˼�飡������
                'STORAGE_MAX'      , 20,...
                'MAX_END_NODE_NUM', 5);
end