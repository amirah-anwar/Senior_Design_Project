function varargout = bmi(varargin)
% BMI MATLAB code for bmi.fig
%      BMI, by itself, creates a new BMI or raises the existing
%      singleton*.
%
%      H = BMI returns the handle to a new BMI or the handle to
%      the existing singleton*.
%
%      BMI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BMI.M with the given input arguments.
%
%      BMI('Property','Value',...) creates a new BMI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bmi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bmi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bmi

% Last Modified by GUIDE v2.5 09-May-2014 02:14:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bmi_OpeningFcn, ...
                   'gui_OutputFcn',  @bmi_OutputFcn, ...
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


% --- Executes just before bmi is made visible.
function bmi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bmi (see VARARGIN)

% Choose default command line output for bmi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bmi wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bmi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.pushbutton2, 'Enable', 'off')
set(handles.pushbutton7, 'Enable', 'off')
set(handles.pushbutton3, 'Enable', 'off')
set(handles.pushbutton8, 'Enable', 'off')
set(handles.pushbutton5, 'Enable', 'off')
set(handles.pushbutton9, 'Enable', 'off')


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData traindata testdata
myData=uiimport('-file');
for i=1:myData.noOfIterations(1)
    if myData.mrk.y(i)==1
        trainEvnt{i}='right';trainLat{i}=myData.mrk.pos(i);
    end
    if myData.mrk.y(i)==2
        trainEvnt{i}='left';trainLat{i}=myData.mrk.pos(i);
    end
end
events1 = struct('type',trainEvnt,'latency',trainLat);
traindata = set_new('data',myData.dataTrain, 'srate',100, 'chanlocs',struct('labels',{'FP1','FP2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','Cz','Fz','Pz','Oz'}), 'event',events1);
for i=(myData.noOfIterations(1)+1):myData.noOfIterations(2)
    if myData.mrk.y(i)==1
        testEvnt{i-myData.noOfIterations(1)}='right';testLat{i-myData.noOfIterations(1)}=myData.mrk.pos(i)-myData.offset;
    end
    if myData.mrk.y(i)==2
        testEvnt{i-myData.noOfIterations(1)}='left';testLat{i-myData.noOfIterations(1)}=myData.mrk.pos(i)-myData.offset;
    end
end
events2 = struct('type',testEvnt,'latency',testLat);
testdata = set_new('data',myData.dataTest, 'srate',100, 'chanlocs',struct('labels',{'FP1','FP2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','Cz','Fz','Pz','Oz'}), 'event',events2);
set(handles.text11, 'String', '16');
set(handles.text18, 'String', '100 Hz');
set(handles.text26, 'String', num2str(myData.noOfIterations(2)));

set(handles.pushbutton2, 'Enable', 'on')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData traindata lastmodel
myapproach = {'SpecCSP' 'SignalProcessing',{'EpochExtraction',[0.5 3]}};
[trainloss,lastmodel,laststats] = bci_train('Data',traindata,'Approach',myapproach,'TargetMarkers',{'right','left'});
set(handles.text21, 'String', num2str(myData.noOfIterations(1)));
set(handles.text20, 'String', '2');
set(handles.pushbutton7, 'Enable', 'on')
set(handles.pushbutton3, 'Enable', 'on')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData testdata prediction targets lastmodel
[prediction,loss,teststats,targets] = bci_predict(lastmodel,testdata);

set(handles.text19, 'String', num2str(myData.noOfIterations(2)-myData.noOfIterations(1)));
set(handles.text22, 'String', [num2str(loss*100,3) '%']);
set(handles.pushbutton8, 'Enable', 'on')
set(handles.pushbutton5, 'Enable', 'on')
set(handles.pushbutton9, 'Enable', 'on')


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myData prediction targets
set(handles.pushbutton1, 'Enable', 'off')
set(handles.pushbutton2, 'Enable', 'off')
set(handles.pushbutton7, 'Enable', 'off')
set(handles.pushbutton3, 'Enable', 'off')
set(handles.pushbutton8, 'Enable', 'off')
set(handles.pushbutton5, 'Enable', 'off')
set(handles.pushbutton9, 'Enable', 'off')
%set(handles.radiobutton2, 'Enable', 'off')
p=round(prediction{2}*prediction{3})';t=targets';len=myData.noOfIterations(2)-myData.noOfIterations(1);
p1=zeros(1,len);p2=zeros(1,len);
cla;
axes(handles.axes2)
bar(1:len,t)
    for i=1:len
        if p(i)==t(i)
            p1(i)=p(i);
            axes(handles.axes1)
            bar(1:len,p1,'g')
            hold on
        else
            p2(i)=p(i);
            axes(handles.axes1)
            bar(1:len,p2,'r')
        end
    end

set(handles.pushbutton1, 'Enable', 'on')
set(handles.pushbutton2, 'Enable', 'on')
set(handles.pushbutton7, 'Enable', 'on')
set(handles.pushbutton3, 'Enable', 'on')
set(handles.pushbutton8, 'Enable', 'on')
set(handles.pushbutton5, 'Enable', 'on')
set(handles.pushbutton9, 'Enable', 'on')




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traindata
pop_eegplot(exp_eval(traindata));

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testdata
pop_eegplot(exp_eval(testdata));


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prediction targets
p=round(prediction{2}*prediction{3})';t=targets';
p=p-1;t=t-1;
figure;
plotconfusion(t,p)
