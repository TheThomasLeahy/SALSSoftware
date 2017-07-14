function varargout = MegaSalsaGUI(varargin)
% MEGASALSAGUI MATLAB code for MegaSalsaGUI.fig
%      MEGASALSAGUI, by itself, creates a new MEGASALSAGUI or raises the existing
%      singleton*.
%
%      H = MEGASALSAGUI returns the handle to a new MEGASALSAGUI or the handle to
%      the existing singleton*.
%
%      MEGASALSAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEGASALSAGUI.M with the given input arguments.
%
%      MEGASALSAGUI('Property','Value',...) creates a new MEGASALSAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MegaSalsaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MegaSalsaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MegaSalsaGUI

% Last Modified by GUIDE v2.5 13-Jul-2017 17:40:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MegaSalsaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MegaSalsaGUI_OutputFcn, ...
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


stopDeleting = 0;

% End initialization code - DO NOT EDIT


% --- Executes just before MegaSalsaGUI is made visible.
function MegaSalsaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MegaSalsaGUI (see VARARGIN)

handles.data = varargin{1};
handles.imageFolder = varargin{2};
handles.sectionNames = varargin{3};
handles.sectionNumber = handles.popupmenu1.Value;
handles.display = handles.popupmenu3.Value;
handles.threshold = 0;
handles = buildColorMap(handles);
handles.threshby = 1;

handles.stopDeleting = 1;

% Choose default command line output for MegaSalsaGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes MegaSalsaGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = buildColorMap(handles)
hold on
handles.sectionNumber = handles.popupmenu1.Value;
handles.display = handles.popupmenu3.Value;

sectionData = handles.data{handles.sectionNumber};

xVals = sort(unique([sectionData(:).x]));
yVals = sort(unique([sectionData(:).y]));
display = handles.display;

data = zeros(length(yVals),length(xVals));
index = 1;

for j = 1:length(yVals)
    for i = 1:length(xVals)
        if display == 1
            %Display PrefD
            data(i,j) = sectionData(index).mean_odf;
        elseif display ==2 
            %Display OI
            data(i,j) = sectionData(index).oi_odf;
        elseif display == 3
            %Display Skew
            data(i,j) = sectionData(index).skew_odf;
        elseif display == 4
            %Display kurtosis
            data(i,j) = sectionData(index).kurtosis_odf;
        elseif display ==5
            %Display MaxInt
            data(i,j) = max(sectionData(index).intensity_data);
        else
            %Display MinInt
            data(i,j) = min(sectionData(index).intensity_data);
        end
        index = index + 1;
    end
end

if display == 1
    stats = [-90 90];
    data = data*(180/pi);
    for i = 1:size(data,1)
        for j = 1:size(data,2)
            if data(i,j) > max(stats)
                data(i,j) = data(i,j) - 180;
            end
        end
    end
elseif display == 2
    stats = [0 50];
elseif display == 3
    stats = [-5 5];
elseif display == 4
    stats = [-10 10];
elseif display == 5
    stats = [0 70000];
else
    stats = [0 70000];
end

if display == 1
string = 'hsv';
else
    string = 'jet';
end


dataMap = num2colormap(data,string,stats);

index = 1;
for j = 1:length(yVals)
    for i = 1:length(xVals)
        if sectionData(index).tissue_flag == 0
            dataMap(i,j,:) = [0 0 0];
        end
        index = index + 1;
    end
end

handles.currentMap = dataMap;
imagesc(dataMap);
set(gca,'YDir','normal');
colormap(string);
caxis(stats);
c = colorbar;
c.Ticks = linspace(stats(1),stats(2),10);


%Add Quiver
xData = ones(length(xVals),length(yVals));
yData = ones(length(xVals),length(yVals));
xQuiver = ones(length(xVals),length(yVals));
yQuiver = ones(length(xVals),length(yVals));
index = 1;
for j = 1:length(yVals)
    for i = 1:length(xVals)
        xData(i,j) = i;
        yData(i,j) = j; 
        % rotate 90 degrees
        xQuiver(i,j) = -sectionData(index).PrefDVector(2);
        yQuiver(i,j) = sectionData(index).PrefDVector(1);
        index = index + 1;
    end
end
axes1 = handles.axes1;
quiver(axes1,yData,xData,yQuiver,xQuiver,'black','ShowArrowHead','off');

xlim([1 j]);
ylim([1 i]);
hold off


function thresholdData(handles)
threshold = handles.threshold;
sectionData = handles.data{handles.sectionNumber};

handles.threshby = handles.popupmenu4.Value;
if ~isequal(handles.threshby,1)
    threshold = threshold * 700;
end
    

for i = 1:length(sectionData)
    if handles.threshby == 1
        if sectionData(i).oi_odf < threshold
            sectionData(i).tissue_flag = 0;
        else
            sectionData(i).tissue_flag = 1;
        end
    elseif handles.threshby == 2
        if max(sectionData(i).intensity_data) < threshold
            sectionData(i).tissue_flag = 0;
        else
            sectionData(i).tissue_flag = 1;
        end
    else
        if min(sectionData(i).intensity_data) < threshold
            sectionData(i).tissue_flag = 0;
        else
            sectionData(i).tissue_flag = 1;
        end
    end
end
handles.data{handles.sectionNumber} = sectionData;
handles = buildColorMap(handles);



    
   


% --- Outputs from this function are returned to the command line.
function varargout = MegaSalsaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
waitfor(handles.figure1);
varargout{1} = handles.data;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject,'Value');
value = round(100*value);
handles.threshold = value;
handles.threshby = handles.popupmenu4.Value;
edit4_Callback(hObject,eventdata,handles);
handles.sectionNumber = handles.popupmenu1.Value;
thresholdData(handles);



% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(hObject,'Value');

if value > length(handles.data)
    %This section does not exist
    string = strcat({'The last section is number '},num2str(length(handles.data)));
    questdlg(string, 'Section does not exist!','OK','OK');
else
    %Update the displayed section
    handles.sectionNumber = value;
    handles = buildColorMap(handles);
end



% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global stopDeleting;
if (stopDeleting)
    stopDeleting = 0;
    set(handles.pushbutton1,'string','Delete Points');
else
    stopDeleting = 1;
    set(handles.pushbutton1,'string','Stop Deleting');
end

global getrect_do
getrect_do = stopDeleting;
while getrect_do
    % rubberand selection.
    try
    % using try to catch user clicking something else, and then repeating getrect call
        r = getrect(gca);
    catch
        continue
    end
    if getrect_do
        % user did mark a rectangle!
        [xPoints,yPoints] = findPoints(r);
        handles = InsertDelete(handles,xPoints,yPoints,1);
        handles = buildColorMap(handles);
    else
        % user abort. while loop will terminate
    end
end
% force getrect to end
global GETRECT_H1
getrect_do = false;
set(GETRECT_H1, 'UserData', 'Completed');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global stopInserting;
if (stopInserting)
    stopInserting = 0;
    set(handles.pushbutton2,'string','Insert Points');
else
    stopInserting = 1;
    set(handles.pushbutton2,'string','Stop Inserting');
end

global getrect_do
getrect_do = stopInserting;
while getrect_do
    % rubberand selection.
    try
    % using try to catch user clicking something else, and then repeating getrect call
        rect = getrect(gca);
    catch
        continue
    end
    if getrect_do
        % user did mark a rectangle!
        [xPoints,yPoints] = findPoints(rect);
        handles = InsertDelete(handles,xPoints,yPoints,0);
        handles = buildColorMap(handles);
    else
        % user abort. while loop will terminate
    end
end
% force getrect to end
global GETRECT_H1
getrect_do = false;
set(GETRECT_H1, 'UserData', 'Completed');




function handles = InsertDelete(handles,xPoints,yPoints,InsDel)
%InsDel = 0 -> Insert; InsDel = 1 -> Delete
handles.sectionNumber = handles.popupmenu1.Value;
sectionData = handles.data{handles.sectionNumber};

xVals = sort(unique([sectionData(:).x]));
yVals = sort(unique([sectionData(:).y]));

index = 1;
for j = 1:length(yVals)
    for i = 1:length(xVals)
        if any(xPoints == i) && any(yPoints == j)
            if InsDel == 1
            sectionData(index).tissue_flag = 0;
            else
                sectionData(index).tissue_flag = 1;
            end
        end
        index = index + 1;
    end
end
handles.data{handles.sectionNumber} = sectionData;




function [xPoints,yPoints] = findPoints(rect)
xD = [rect(1); rect(1)+rect(3)];
yD = [rect(2); rect(2)+rect(4)];

xPoints = linspace(xD(1), xD(2),round(abs(xD(2)-xD(1)))+1);
yPoints = linspace(yD(1), yD(2),round(abs(yD(2)-yD(1)))+1);
xPoints = unique(round(xPoints));
yPoints = unique(round(yPoints));
temp = xPoints;
xPoints = yPoints;
yPoints = temp;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);



% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(hObject,'Value');
handles.display = value;
handles = buildColorMap(handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit3_Callback(hObject, eventdata, handles,value)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = handles.threshold;
if ~isequal(handles.threshby,1)
    value = value*700;
end
string = strcat({'Threshold: '},num2str(value));
handles.edit4.String = string;


% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
value = get(hObject,'Value');
handles.threshby=value;




% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes1 = handles.axes1;
image = getimage(axes1);

handles.sectionNumber = handles.popupmenu1.Value;
handles.display = handles.popupmenu3.Value;

sectionData = handles.data{handles.sectionNumber};

display = handles.display;
imageStr = '';
if display == 1
        %Display PrefD
        imageStr = 'PrefD';
    elseif display ==2 
        %Display OI
        imageStr = 'OI';
    elseif display == 3
        %Display Skew
        imageStr = 'Skew';
    elseif display == 4
        %Display kurtosis
        imageStr = 'Kurtosis';
    elseif display ==5
        %Display MaxInt
        imageStr = 'MaxIntensity';
    else
        %Display MinInt
        imageStr = 'MinIntensity';
end
sectionName = handles.sectionNames(handles.sectionNumber);
C = {handles.imageFolder,'/',sectionName{1},'_',imageStr,'.png'};
export_fig(handles.axes1, strjoin(C,''));


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
