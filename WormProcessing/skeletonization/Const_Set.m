function CONST_VALUE = Const_Set()

CONST_VALUE = struct('IMAGE_TAG'        , '',...  % �ļ�����ǰ׺
                     'IMAGE_INDEX'      , 0 ,...% ����˳��洢���д�����ͼƬ�����
                     'PIC_NUM'          , 1     ,...    % ������ͼƬ����
                     'IMAGE_SIZE'       , [0, 0],...    % ͼ��ߴ�
                     'ROI_section'      , [10 6 8],...  % ��ʾ����Ȥ�������������ϵı���
                     'PARTITION_NUM'    , 100   ,...    % ���߳������ߵȷֵķ���
                     'SHOW_IMAGE'       , 'on'  ,...    % �����Ƿ���ʾ�м�ͼ��
                     'SAVE_DATA'        , 'on' ,...    % �����Ƿ񱣴�����
                     'EDGE_SHRUNK'      , 3     ,...    % ȡ�߳��Ե�Ĳ��������ⲿ����С�ڴ�ֵ�ĵ㱻��Ϊ��Ե
                     'AREA_THRESHOLD_1' , 1000  ,...    % ��ֵ�������С�ڴ�ֵ��1ֵ��ͨ����ᱻɸѡ�����Ա���ͼ�����߳�Ĳ���
                     'AREA_THRESHOLD_2' , 100   ,...    % ��ֵ�������С�ڴ�ֵ��0ֵ��ͨ����ᱻɸѡ������ȥ���߳������ֵ����ֵ��С�����µĿ�϶
                     'BINARY_THRESHOLD' , 35    ,...    % �����߳��뱳������ֵ��ȡ����ֵС�����ĵ��γ��߳�����
                     'RAP_THRESHOLD'    , 0.6   ,...    % ��ȴ����߳�ƽ����ȵĸñ���ʱ����Ϊ�߳淢����ճ��
                     'LAPLACIAN_THRESHOLD',-0.3 ,...    % �Ծ�����laplacian�任��ľ�����С�ڴ�ֵ�ĵ㱻ȡΪ�����ߺ�ѡ��
                     'NEARBY_DIST'      , 100     ,...    % �Ǽܻ�ʱ����ƽ��С�ڴ�ֵ�ĵ㱻��Ϊ�����ڵ�
                     'METRICS_MAX'      , 300    ,...    % �Ǽܻ�ʱ����
                     'ANGLE_THRESHOLD_NAN', pi/3,...    % �Ǽܻ�ʱ���Ҳ������ڵ�����ǰ���ýǶ��ڽ�������
                     'ALPHA'            , 1     ,...    % �Ǽܻ�ʱ���Ҳ������ڵ��������ʱ�Ĳ�����alphaԽ���ʾ����ѡ��ǶȲ����Ԫ��
                     'ANGLE_ERROR'      , 1E-6  ,...
                     'DEGREE_MAX'       , 5     ,...    % ע�⣡����������Ӧ�ò�����ֵ�������ڸ������������������û�жԴ˼�飡������
                     'STORAGE_MAX'      , 20,...
                     'MAX_END_NODE_NUM', 5);

% CONST_VALUE.IMAGE_INDEX(36:39) = [];
% CONST_VALUE.PIC_NUM = length(CONST_VALUE.IMAGE_INDEX);
% % -------------------------------��ȡͼƬ�ߴ�-----------------------------------
% image_info = imfinfo(strcat(CONST_VALUE.IMAGE_TAG,num2str(CONST_VALUE.IMAGE_INDEX(1)),'.tiff'));
% CONST_VALUE.IMAGE_SIZE(1) = image_info.Height;
% CONST_VALUE.IMAGE_SIZE(2) = image_info.Width;
% save('data/CONST_VALUE.mat','CONST_VALUE');
end