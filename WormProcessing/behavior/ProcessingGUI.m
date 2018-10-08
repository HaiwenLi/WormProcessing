function varargout = ProcessingGUI(varargin)
% PROCESSINGGUI MATLAB code for ProcessingGUI.fig
%      PROCESSINGGUI, by itself, creates a new PROCESSINGGUI or raises the existing
%      singleton*.
%
%      H = PROCESSINGGUI returns the handle to a new PROCESSINGGUI or the handle to
%      the existing singleton*.
%
%      PROCESSINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESSINGGUI.M with the given input arguments.
%
%      PROCESSINGGUI('Property','Value',...) creates a new PROCESSINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProcessingGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProcessingGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProcessingGUI

% Last Modified by GUIDE v2.5 25-Sep-2018 21:00:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProcessingGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ProcessingGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ProcessingGUI is made visible.
function ProcessingGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProcessingGUI (see VARARGIN)

% Data Definition by user
global ImgFolder;
global SegmentParam;
global ImageNum;
global HeadPos;

ImgFolder = '';
SegmentParam = 0.5;
ImageNum = 0;
HeadPos = [nan, nan];

% Choose default command line output for ProcessingGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProcessingGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ProcessingGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
%% Get Segmentation Parameters (In Adaptive Segementation)
global SegmentParam;
SegmentParam = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Image Segment Button Callback
% The segmented image starts from 1!
global ImgFolder;
global SegmentParam;
global ImageNum;

% parameter initialization
image_format = '.tiff';
 worm_area = 1400;
sensitivity = SegmentParam;
    
if ~isempty(ImgFolder)
    res_seq = GetImageSeq(Image_Folder, image_format);
    prefix = res_seq.image_name_prefix;
    time = res_seq.image_time;
    
    ImageNum = length(time);
    OutFolder = [ImgFolder 'region'];
    if ~exist(OutFolder, 'dir')
        mkdir(OutFolder);
    end
    OutFolder = [OutFolder '\'];
    
    for i=1:length(time)
        image_name = [prefix num2str(time(i)) '.tiff'];
        disp(image_name);
        img = imread([Image_Folder image_name]);
        [binary_whole,worm_area] = WormSeg_Contour(img, worm_area, sensitivity);
        imwrite(uint8(binary_whole*255),[OutFolder num2str(i) image_format]);
    end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Export Error Images Button Callback
global ImgFolder;

if ~isempty(ImgFolder)
    % make some directories
    if ~exist([ImgFolder 'error'], 'dir')
        mkdir([ImgFolder 'error']);
    end
    if ~exist([ImgFolder 'error\Image'],'dir')
        mkdir([ImgFolder 'error\Image']);
    end
    if ~exist([ImgFolder 'error\backbone'],'dir')
        mkdir([ImgFolder 'error\backbone']);
    end
    if ~exist([ImgFolder 'error\centerline'],'dir')
        mkdir([ImgFolder 'error\centerline']);
    end
    if ~exist([ImgFolder 'error\region'],'dir')
        mkdir([ImgFolder 'error\region']);
    end
    if ~exist([ImgFolder 'error\error'],'dir')
        mkdir([ImgFolder 'error\error']);
    end
    
    ExportErrorImages(ImgFolder,'');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Compute Centerline Button Callback
global ImgFolder;
global ImageNum;
global HeadPos;

if ImageNum == 0
    disp('Please segment the images before compute centerline');
end

if ~isempty(ImgFolder)
    backbone_folder = [ImgFolder 'backbone\'];
    centerline_folder = [ImgFolder 'centerline\'];
    
    % mkdir backbone and centerline folders
    if ~exist(backbone_folder, 'dir')
        mkdir(backbone_folder);
    end
    backbone_folder = [backbone_folder '\'];
    
    if ~exist(centerline_folder, 'dir')
        mkdir(centerline_folder);
    end
    
    % calculte centerline
    CalculateCenterline([ImgFolder 'region\'],backbone_folder, 1, ImageNum);
    clc;
    Get_Centerline(ImgFolder, HeadPos);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Load Button Callback
% load image folder and make some folders
global ImgFolder;

ImgFolder = uigetdir;
ImgFolder = [ImgFolder '\'];
set(handles.edit1,'String',ImgFolder);

if ~exist([ImgFolder 'Image'], 'dir')
    disp('There no Image folder in current dirtectory, please check!');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Draw Centerline Button Callback
global ImgFolder;
global ImageNum;

if ImageNum == 0
    disp('Please segment the images before compute centerline');
end
if ~isempty(ImgFolder)
    DrawCenterline_Fig(ImgFolder, 1:ImageNum);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Update Centerline Button Callback
global ImgFolder;

if ~isempty(ImgFolder)
    error_folder = [ImgFolder 'error'];
    if ~exist(error_folder, 'dir')
       disp('No centerline to be updated');
       return;
    end
    error_folder = [error_folder '\'];
    
    % make sure the ImgFolder is the upper folder!!!
    UpdateCenterline_ByHand(error_folder);
    disp('All centerlines have been updated');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Combine Centerline Button Callback
global ImgFolder;

if ~isempty(ImgFolder)
    error_folder = [ImgFolder 'error'];
    if ~exist(error_folder, 'dir')
       disp('No centerline to be updated');
       return;
    end
    error_folder = [error_folder '\'];
    
    % make sure the ImgFolder is the upper folder!!!
    CombineCenterlines(error_folder, ImgFolder);
    disp('Centerlines have been combined');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Clear Folder Button Callback
global ImgFolder;

if ~isempty(ImgFolder)
    % make some directories
    if exist([ImgFolder 'error\Image'],'dir')
        rmdir([ImgFolder 'error\Image'],'s');
    end
    if exist([ImgFolder 'error\backbone'],'dir')
        rmdir([ImgFolder 'error\backbone'],'s');
    end
    if exist([ImgFolder 'error\centerline'],'dir')
        rmdir([ImgFolder 'error\centerline'],'s');
    end
    if exist([ImgFolder 'error\region'],'dir')
        rmdir([ImgFolder 'error\region'],'s');
    end
    if exist([ImgFolder 'error\error'],'dir')
        rmdir([ImgFolder 'error\error'],'s');
    end
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
%% HeadPos - x
global HeadPos;
HeadPos(2) = floor(str2double(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
%% HeadPOs - y
global HeadPos;
HeadPos(1) = floor(str2double(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
