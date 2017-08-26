function varargout = robot(varargin)
% ROBOT MATLAB code for robot.fig
%      ROBOT, by itself, creates a new ROBOT or raises the existing
%      singleton*.
%
%      H = ROBOT returns the handle to a new ROBOT or the handle to
%      the existing singleton*.
%
%      ROBOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOT.M with the given input arguments.
%
%      ROBOT('Property','Value',...) creates a new ROBOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before robot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to robot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help robot

% Last Modified by GUIDE v2.5 10-Jun-2014 21:24:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @robot_OpeningFcn, ...
                   'gui_OutputFcn',  @robot_OutputFcn, ...
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


% --- Executes just before robot is made visible.
function robot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to robot (see VARARGIN)

% Choose default command line output for robot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes robot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = robot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global myData
myData=load('Classifier.mat');
set(handles.leftButton, 'Enable', 'off')
set(handles.rightButton, 'Enable', 'off')
set(handles.stopButton, 'Enable', 'off')
% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bt
bt=Bluetooth('RNBT-3170',1);
fclose(bt);
fopen(bt);
fwrite(bt,uint8('F'));
set(handles.leftButton, 'Enable', 'on')
set(handles.rightButton, 'Enable', 'on')
set(handles.stopButton, 'Enable', 'on')
set(handles.startButton, 'Enable', 'off')
axes(handles.axes1)
I=imread('Forward.jpg');
imshow(I);
%--- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bt
fwrite(bt,uint8('S'));fwrite(bt,uint8('S'));fwrite(bt,uint8('S'));fwrite(bt,uint8('S'));
fclose(bt);
set(handles.startButton, 'Enable', 'on')
set(handles.leftButton, 'Enable', 'off')
set(handles.rightButton, 'Enable', 'off')
set(handles.stopButton, 'Enable', 'off')


% --- Executes on button press in rightButton.
function rightButton_Callback(hObject, eventdata, handles)
% hObject    handle to rightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData bt
[prediction,loss,teststats,targets] = bci_predict(myData.lastmodel,myData.rightTest);
result=round(prediction{2}*prediction{3})';
if result==1
    fwrite(bt,uint8('R'));
elseif result==2
    fwrite(bt,uint8('L'));
end
axes(handles.axes1)
I=imread('Right.jpg');
imshow(I);
pause on
pause(0.5);
fwrite(bt,uint8('F'));
axes(handles.axes1)
I=imread('Forward.jpg');
imshow(I);

% --- Executes on button press in leftButton.
function leftButton_Callback(hObject, eventdata, handles)
% hObject    handle to leftButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData bt
[prediction,loss,teststats,targets] = bci_predict(myData.lastmodel,myData.leftTest);
result=round(prediction{2}*prediction{3})';
if result==1
    fwrite(bt,uint8('R'));
elseif result==2
    fwrite(bt,uint8('L'));
end
axes(handles.axes1)
I=imread('Left.jpg');
imshow(I);
pause on
pause(0.5);
fwrite(bt,uint8('F'));
axes(handles.axes1)
I=imread('Forward.jpg');
imshow(I);
% --- Executes on button press in leftPlot.
function leftPlot_Callback(hObject, eventdata, handles)
% hObject    handle to leftPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData
pop_eegplot(exp_eval(myData.leftTest));

% --- Executes on button press in plotRight.
function plotRight_Callback(hObject, eventdata, handles)
% hObject    handle to plotRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData
pop_eegplot(exp_eval(myData.rightTest));
