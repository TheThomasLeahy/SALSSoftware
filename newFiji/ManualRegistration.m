function varargout = ManualRegistration(varargin)
% MANUALREGISTRATION MATLAB code for ManualRegistration.fig
%      MANUALREGISTRATION, by itself, creates a new MANUALREGISTRATION or raises the existing
%      singleton*.
%
%      H = MANUALREGISTRATION returns the handle to a new MANUALREGISTRATION or the handle to
%      the existing singleton*.
%
%      MANUALREGISTRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALREGISTRATION.M with the given input arguments.
%
%      MANUALREGISTRATION('Property','Value',...) creates a new MANUALREGISTRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualRegistration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualRegistration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualRegistration

% Last Modified by GUIDE v2.5 11-Jul-2017 15:05:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualRegistration_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualRegistration_OutputFcn, ...
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


% --- Executes just before ManualRegistration is made visible.
function ManualRegistration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualRegistration (see VARARGIN)

data= varargin{1};

global imagePrevious;
imagePrevious = data{1};
global imageNext;
imageNext = data{2};

showInit(handles, imagePrevious,imageNext);

global tForm;
tForm = [1 0 0 ; 0 1 0; 0 0 1];

global imageNext_New;
imageNext_New = showRegistered(handles, imagePrevious,imageNext,tForm);

% Choose default command line output for ManualRegistration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualRegistration wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function showInit(handles, imagePrevious, imageNext)

axes(handles.axes1);
imshowpair(imagePrevious, imageNext);



function imageNext_New = showRegistered(handles, imagePrevious, imageNext, tForm)

axes(handles.axes2);

T = affine2d(tForm');
imageNext_New = imwarp(imageNext,T, 'OutputView',imref2d(size(imagePrevious)));

imshowpair(imagePrevious, imageNext_New);



function adjustTForm(handles, string, value)

global tForm;

if strcmp(string, 'rot')
    c = cosd(value);
    s = sind(value);
    tForm(1,1) = c; tForm(2,2) = c;
    tForm(1,2) = s; tForm(2,1) = -1*s;
elseif strcmp(string, 'horzshift')
    tForm(1,3) = value;
else
    tForm(2,3) = value;
end

global imagePrevious;
global imageNext;
global imageNext_New;

imageNext_New = showRegistered(handles, imagePrevious, imageNext, tForm);



% --- Outputs from this function are returned to the command line.
function varargout = ManualRegistration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
waitfor(handles.figure1);

global tForm;

global imageNext_New;

data{1} = tForm;
data{2} = imageNext_New;

varargout{1} = data;



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%This is the rotation slider
%Should go from -90 to 90
%Initial value from 0 to 1

value = get(hObject,'Value');
rot = (value-0.5)*360;
handles.edit1.String = [num2str(rot) char(176)];

adjustTForm(handles,'rot',rot);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
hObject.Value = 0.5;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%VERT SHIFT

value = get(hObject,'Value');
shift = (value-0.5)*1000;
handles.edit3.String = [num2str(shift)];

adjustTForm(handles,'vertshift',shift);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
hObject.Value = 0.5;

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%HORZ SHIFT

value = get(hObject,'Value');
shift = (value-0.5)*1000;
handles.edit2.String = [num2str(shift)];

adjustTForm(handles,'horzshift',shift);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
hObject.Value = 0.5;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
string = get(hObject,'String');
index = strfind(string, char(176));
string = string(1:index-1);
rot = str2num(string);

value = (rot/360)+0.5;
handles.slider1.Value = value;

adjustTForm(handles,'rot',rot);

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

hObject.String = ['0' char(176)];




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

%HORZ SHIFT

string = get(hObject,'String');
shift = str2num(string);
value = (shift/1000)+0.5;
handles.slider3.Value = value;

adjustTForm(handles,'horzshift',shift);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

hObject.String = ['0'];



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% VERT SHIFT

string = get(hObject,'String');
shift = str2num(string);
value = (shift/1000)+0.5;
handles.slider2.Value = value;

adjustTForm(handles,'vertshift',shift);

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

hObject.String = ['0'];


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Hope you enjoyed your time at the manual registration station');
close(handles.figure1);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global imagePrevious;
global imageNext_New;
global imageNext;
global tForm;

[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 500;
altTForm = imregtform(imageNext_New,imagePrevious,'rigid',optimizer,metric);
altTForm = altTForm.T';

tForm = tForm*altTForm;

imageNext_New = showRegistered(handles, imagePrevious, imageNext, tForm);

%%update Values

%rot
c = tForm(1,1);
s = tForm(1,2);

rot = atan2d(s,c);

handles.edit1.String = [num2str(rot) char(176)];

value = (rot/360)+0.5;
handles.slider1.Value = value;

%HorzShift
shift = tForm(1,3);

handles.edit2.String = [num2str(shift)];

value = (shift/1000)+0.5;
handles.slider3.Value = value;

%VertShift

shift = tForm(2,3);

handles.edit3.String = [num2str(shift)];

value = (shift/1000)+0.5;
handles.slider2.Value = value;

disp('Auto Touch up complete!');



