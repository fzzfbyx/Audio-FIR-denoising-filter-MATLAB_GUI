function varargout = yanshou(varargin)
% YANSHOU M-file for yanshou.fig
%      YANSHOU, by itself, creates a new YANSHOU or raises the existing
%      singleton*.
%
%      H = YANSHOU returns the handle to a new YANSHOU or the handle to
%      the existing singleton*.
%
%      YANSHOU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YANSHOU.M with the given input arguments.
%
%      YANSHOU('Property','Value',...) creates a new YANSHOU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before yanshou_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to yanshou_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help yanshou

% Last Modified by GUIDE v2.5 23-Apr-2020 14:20:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @yanshou_OpeningFcn, ...
                   'gui_OutputFcn',  @yanshou_OutputFcn, ...
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


% --- Executes just before yanshou is made visible.
function yanshou_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to yanshou (see VARARGIN)

% Choose default command line output for yanshou
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes yanshou wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = yanshou_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in open_pushbutton1.
function open_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to open_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;  %文件
global Fs; %采样频率
global tl; 
global x2;
[filename, pathname] = uigetfile('*.wav', '选择音频文件');
if isequal(filename,0)
   disp('User selected Cancel')
else
   path = fullfile(pathname, filename);
   [handles.x,handles.Fs]=audioread(path);
   x=handles.x;
   Fs=handles.Fs;
   axes(handles.axes1);
   tl=[0:1/Fs:(length(handles.x)-1)/Fs];  %时间尺度
   plot(tl,handles.x);
   title('语音时域波形');
   xlabel('时间/s');
   grid on;
   
   N=length(handles.x);
   df=Fs/N;
   w=[0:df:df*(N-1)] - Fs/2; %频率尺度
   X=fft(handles.x);
   X=fftshift(X);
   axes(handles.axes2);
   plot(w,abs(X)/max(abs(X)));
   axis([-10000,10000,0,1]);
   title('语音频谱');
   xlabel('频率/Hz');
   grid on;
   x2=x;
end



% --- Executes on button press in play_pushbutton2.
function play_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to play_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x2;
global Fs;
sound(x2,Fs);


% --- Executes on button press in add_pushbutton3.
function add_pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to add_pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
global tl;
global x2;
axes(handles.axes1);
size(x);
t=0:1/Fs:(length(x)-1)/Fs;%将所加噪声信号的点数调整到与原始信号相同
Au=0.07;
fn =  get(handles.noise_edit2,'string');       %噪声频率
fn = str2double(fn);
noise=Au*cos(2*pi*fn*t)';     %噪声为频率
x=x+noise;
plot(tl,x);
title('加入噪声后语音时域波形');
xlabel('时间/s');
grid on;
N=length(x);
df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x);
X=fftshift(X);
axes(handles.axes2);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('加入噪声后语音频谱');
xlabel('频率/Hz');
grid on;    
x2=x;

% --- Executes on button press in low_pushbutton5.
function low_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to low_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
global Fs;
global tl;
global x2;

x1=x;
% fp=1000;
% fs = 1000;
% Wp = 2*fp/Fs;
% Ws = 2*fs/Fs;
% if(Wp >= 1)
%     Wp = 0.99;
% end
% if(Ws >= 1)
%     Ws = 0.99;  
% end
fp =  get(handles.edit3,'string');     
fp = str2double(fp)*2;
if get(handles.radiobutton1,'value')
    [n, Wn]=buttord(Wp,Ws, 2, 15);
    [b, a]=butter(n, Wn,'low');
    axes(handles.axes3);
    [h,w]=freqz(b,a);
    plot(w/pi*Fs/2,abs(h)); 
    x1=filter(b,a,x1);        %调用函数滤波
elseif get(handles.radiobutton4,'value')
    b2=fir1(30, fp/Fs, boxcar(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton5,'value')
    b2=fir1(30, fp/Fs, triang(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton6,'value')
    b2=fir1(30, fp/Fs, hamming(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton7,'value')
    b2=fir1(30, fp/Fs, hanning(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton8,'value')
    b2=fir1(30, fp/Fs, blackman(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton9,'value')
    b2=fir1(30,fp/Fs, kaiser(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
end;
axes(handles.axes5);
plot(tl,x1);
title('滤除噪声后语音时域波形');
xlabel('时间/s');
N=length(x1);
df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x1);
X=fftshift(X);
axes(handles.axes6);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('滤除噪声后语音频谱');
xlabel('频率/Hz');
grid on;
x2=x1;




% --- Executes during object creation, after setting all properties.
function low_pushbutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to low_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.



function noise_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to noise_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_edit2 as text
%        str2double(get(hObject,'String')) returns contents of noise_edit2 as a double


% --- Executes during object creation, after setting all properties.
function noise_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function add_pushbutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to add_pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in guass_pushbutton8.
function guass_pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to guass_pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
global tl;
global x2;
N=length(x);
axes(handles.axes1);
%x = awgn(x,15);
noise=(max(x(:,1))/5)*randn(N,2);
x=x+noise;
plot(tl,x);
title('加入噪声后语音时域波形');
xlabel('时间/s');
grid on;

df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x);
X=fftshift(X);
axes(handles.axes2);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('加入噪声后语音频谱');
xlabel('频率/Hz');
grid on;    
x2=x;


function high_pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to high_pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
global tl;
global x2;

x1=x;
% fp = 3000;
% fs = fp-300;
% Wp = 2*fp/Fs;
% Ws = 2*fs/Fs;
% if(Wp >= 1)
%     Wp = 0.99;
% end
% if(Ws >= 1)
%     Ws = 0.99;  
% end
fp =  get(handles.edit3,'string');     
fp = str2double(fp)*2;
if get(handles.radiobutton1,'value')
    [n, Wn]=buttord(Wp,Ws, 2, 15);
    [b, a]=butter(n, Wn,'high');
    axes(handles.axes3);
    [h,w]=freqz(b,a);
    plot(w/pi*Fs/2,abs(h)); 
    x1=filter(b,a,x1);        %调用函数滤波
elseif get(handles.radiobutton4,'value')
    b2=fir1(30, fp/Fs,'high',boxcar(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton5,'value')
    b2=fir1(30, fp/Fs,'high', triang(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton6,'value')
    b2=fir1(30,fp/Fs,'high', hamming(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton7,'value')
    b2=fir1(30, fp/Fs, 'high',hanning(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton8,'value')
    b2=fir1(30, fp/Fs, 'high',blackman(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton9,'value')
    b2=fir1(30,fp/Fs,'high', kaiser(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
end;
axes(handles.axes5);
plot(tl,x1);
title('滤除噪声后语音时域波形');
xlabel('时间/s');
N=length(x1);
df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x1);
X=fftshift(X);
axes(handles.axes6);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('滤除噪声后语音频谱');
xlabel('频率/Hz');
grid on;
x2=x1;

% --- Executes on button press in bandpass_pushbutton10.
function bandpass_pushbutton10_Callback(~, eventdata, handles)
% hObject    handle to bandpass_pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
global tl;
global x2;

x1=x;
% fp = [2000,3000];
% fs = [1800,3300];
%  Wp = 2*fp/Fs;
% Ws = 2*fs/Fs;
% if(Wp >= 1)
%     Wp = 0.99;
% end
% if(Ws >= 1)
%     Ws = 0.99;  
% end
fp =  get(handles.edit3,'string');     
fp = str2double(fp)*2;
fs =  get(handles.edit4,'string');     
fs = str2double(fs)*2;
if get(handles.radiobutton1,'value')
    [n, Wn]=buttord(Wp,Ws, 2, 15);
    [b, a]=butter(n, Wn,'bandpass');
    axes(handles.axes3);
    [h,w]=freqz(b,a);
    plot(w/pi*Fs/2,abs(h)); 
    x1=filter(b,a,x1);
elseif get(handles.radiobutton4,'value')
    b2=fir1(30,[fp/Fs fs/Fs],boxcar(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton5,'value')
    b2=fir1(30,[fp/Fs fs/Fs], triang(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton6,'value')
    b2=fir1(30,[fp/Fs fs/Fs],hamming(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton7,'value')
    b2=fir1(30,[fp/Fs fs/Fs],hanning(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton8,'value')
    b2=fir1(30,[fp/Fs fs/Fs],blackman(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton9,'value')
    b2=fir1(30,[fp/Fs fs/Fs],kaiser(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
end;
axes(handles.axes5);
plot(tl,x1);
title('滤除噪声后语音时域波形');
xlabel('时间/s');
N=length(x1);
df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x1);
X=fftshift(X);
axes(handles.axes6);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('滤除噪声后语音频谱');
xlabel('频率/Hz');
grid on;
x2=x1;

% --- Executes on button press in stop_pushbutton11.
function stop_pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to stop_pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
global tl;
global x2;

x1=x;
% fp = [1200,3300];
% fs = [1500,3000];
% Wp = 2*fp/Fs;
% Ws = 2*fs/Fs;
% if(Wp >= 1)
%     Wp = 0.99;
% end
% if(Ws >= 1)
%     Ws = 0.99;  
% end
fp =  get(handles.edit3,'string');     
fp = str2double(fp)*2;
fs =  get(handles.edit4,'string');     
fs = str2double(fs)*2;
if get(handles.radiobutton1,'value')
    [n, Wn]=buttord(Wp,Ws, 2, 15);
    [b, a]=butter(n, Wn,'stop');
    axes(handles.axes3);
    [h,w]=freqz(b,a);
    plot(w/pi*Fs/2,abs(h)); 
    x1=filter(b,a,x1);        
elseif get(handles.radiobutton4,'value')
    b2=fir1(30,[fp/Fs fs/Fs],'stop',boxcar(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton5,'value')
    b2=fir1(30, [fp/Fs fs/Fs],'stop', triang(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton6,'value')
   b2=fir1(30, [fp/Fs fs/Fs],'stop', triang(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton7,'value')
    b2=fir1(30, [fp/Fs fs/Fs], 'stop',hanning(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton8,'value')
    b2=fir1(30, [fp/Fs fs/Fs], 'stop',blackman(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
    elseif get(handles.radiobutton9,'value')
    b2=fir1(30, [fp/Fs fs/Fs],'stop',kaiser(31)); 
    axes(handles.axes3);
    [h,w]=freqz(b2, 1,512); 
    plot(w/pi*Fs/2,20*log(abs(h))); 
    x1=fftfilt(b2,x1);
end;
axes(handles.axes5);
plot(tl,x1);
title('滤除噪声后语音时域波形');
xlabel('时间/s');
N=length(x1);
df=Fs/N;
w=[0:df:df*(N-1)] - Fs/2; %频率尺度
X=fft(x1);
X=fftshift(X);
axes(handles.axes6);
plot(w,abs(X)/max(abs(X)));
axis([-10000,10000,0,1]);
title('滤除噪声后语音频谱');
xlabel('频率/Hz');
grid on;
x2=x1;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in invert_pushbutton12.
function invert_pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to invert_pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global x2;

N=length(x);
for i=1:1:N
    x2(i)= x(N-i+1);
end;



% --- Executes on button press in save_pushbutton16.
function save_pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x2;
global Fs;
[filename, pathname] = uiputfile('*.wav', '保存音频文件');
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
    path= fullfile(pathname, filename);
    audiowrite(x2,Fs,path); 
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9



function edit3_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 new_f_handle=figure('visible','off'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes1,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    [filename pathname fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        msgbox('          图线已成功保存！','完成！');
    end
        new_f_handle=figure('visible','off'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes2,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    [filename pathname fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        msgbox('          图线已成功保存！','完成！');
    end
        new_f_handle=figure('visible','off'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes3,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    [filename pathname fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        msgbox('          图线已成功保存！','完成！');
    end
        new_f_handle=figure('visible','off'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes5,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    [filename pathname fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        msgbox('          图线已成功保存！','完成！');
    end
    new_f_handle=figure('visible','off'); %新建一个不可见的figure
    new_axes=copyobj(handles.axes6,new_f_handle); %axes1是GUI界面内要保存图线的Tag，将其copy到不可见的figure中
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    [filename pathname fileindex]=uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');
    if  filename~=0%未点“取消”按钮或未关闭
        file=strcat(pathname,filename);
        switch fileindex %根据不同的选择保存为不同的类型        
            case 1
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        msgbox('          图线已成功保存！','完成！');
    end
