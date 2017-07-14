function varargout = gradients_GUI(varargin)
% GRADIENTS_GUI MATLAB code for gradients_GUI.fig
%      GRADIENTS_GUI, by itself, creates a new GRADIENTS_GUI or raises the existing
%      singleton*.
%
%      H = GRADIENTS_GUI returns the handle to a new GRADIENTS_GUI or the handle to
%      the existing singleton*.
%
%      GRADIENTS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRADIENTS_GUI.M with the given input arguments.
%
%      GRADIENTS_GUI('Property','Value',...) creates a new GRADIENTS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gradients_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gradients_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gradients_GUI

% Last Modified by GUIDE v2.5 18-Jun-2015 16:51:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gradients_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @gradients_GUI_OutputFcn, ...
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


% --- Executes just before gradients_GUI is made visible.
function gradients_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gradients_GUI (see VARARGIN)

% Choose default command line output for gradients_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gradients_GUI wait for user response (see UIRESUME)
% uiwait(handles.uipanel);


% --- Outputs from this function are returned to the command line.
function varargout = gradients_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OICheck.
function OICheck_Callback(hObject, eventdata, handles)
% hObject    handle to OICheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OICheck


% --- Executes on button press in PDCheck.
function PDCheck_Callback(hObject, eventdata, handles)
% hObject    handle to PDCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PDCheck


% --- Executes on button press in HCheck.
function HCheck_Callback(hObject, eventdata, handles)
% hObject    handle to HCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HCheck


% --- Executes on button press in fileOut.
function fileOut_Callback(hObject, eventdata, handles)
% hObject    handle to fileOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in closeProgram.
function closeProgram_Callback(hObject, eventdata, handles)
% hObject    handle to closeProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
