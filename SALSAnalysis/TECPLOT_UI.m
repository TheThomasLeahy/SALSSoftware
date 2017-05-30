function varargout = TECPLOT_UI(varargin)
% TECPLOT_UI MATLAB code for TECPLOT_UI.fig
%      TECPLOT_UI, by itself, creates a new TECPLOT_UI or raises the existing
%      singleton*.
%
%      H = TECPLOT_UI returns the handle to a new TECPLOT_UI or the handle to
%      the existing singleton*.
%
%      TECPLOT_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TECPLOT_UI.M with the given input arguments.
%
%      TECPLOT_UI('Property','Value',...) creates a new TECPLOT_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TECPLOT_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TECPLOT_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TECPLOT_UI

% Last Modified by GUIDE v2.5 29-Jul-2014 11:02:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TECPLOT_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @TECPLOT_UI_OutputFcn, ...
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


% --- Executes just before TECPLOT_UI is made visible.
function TECPLOT_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TECPLOT_UI (see VARARGIN)

% Choose default command line output for TECPLOT_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TECPLOT_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TECPLOT_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bmpReg.
function bmpReg_Callback(hObject, eventdata, handles)
% hObject    handle to bmpReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in xyReg.
function xyReg_Callback(hObject, eventdata, handles)
% hObject    handle to xyReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addTec.
function addTec_Callback(hObject, eventdata, handles)
% hObject    handle to addTec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in appendTec.
function appendTec_Callback(hObject, eventdata, handles)
% hObject    handle to appendTec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in createTec.
function createTec_Callback(hObject, eventdata, handles)
% hObject    handle to createTec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sampName_Callback(hObject, eventdata, handles)
% hObject    handle to sampName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampName as text
%        str2double(get(hObject,'String')) returns contents of sampName as a double


% --- Executes during object creation, after setting all properties.
function sampName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
