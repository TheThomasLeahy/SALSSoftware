function varargout = SALSPipelineUI(varargin)
% SALSPIPELINEUI MATLAB code for SALSPipelineUI.fig
%      SALSPIPELINEUI, by itself, creates a new SALSPIPELINEUI or raises the existing
%      singleton*.
%
%      H = SALSPIPELINEUI returns the handle to a new SALSPIPELINEUI or the handle to
%      the existing singleton*.
%
%      SALSPIPELINEUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SALSPIPELINEUI.M with the given input arguments.
%
%      SALSPIPELINEUI('Property','Value',...) creates a new SALSPIPELINEUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SALSPipelineUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SALSPipelineUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SALSPipelineUI

% Last Modified by GUIDE v2.5 25-Sep-2017 11:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SALSPipelineUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SALSPipelineUI_OutputFcn, ...
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


% --- Executes just before SALSPipelineUI is made visible.
function SALSPipelineUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SALSPipelineUI (see VARARGIN)

% Choose default command line output for SALSPipelineUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SALSPipelineUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SALSPipelineUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('MassSalsAnalysis/MassSALSAnalysis.m');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('Transmural/TransmuralAnalysis.m');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('newFiji/newFiji.m');
