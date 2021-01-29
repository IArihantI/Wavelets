function varargout = AudioCompression2(varargin)





gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioCompression2_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioCompression2_OutputFcn, ...
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
% End initialization code 


% --- Executes just before AudioCompression2 is made visible.
function AudioCompression2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.


% Choose default command line output for AudioCompression2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AudioCompression2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AudioCompression2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)


% handles    structure with handles and user data (see GUIDATA)
global file_name;
%guidata(hObject,handles)
file_name=uigetfile({'*.wav'},'Select an Audio File');
fileinfo = dir(file_name);
SIZE = fileinfo.bytes;
Size = SIZE/1024;
[x,Fs,bits] = wavread(file_name);
xlen=length(x);
t=0:1/Fs:(length(x)-1)/Fs;
set(handles.text12,'string',Size);
%plot(t,x);
axes(handles.axes1) % Select the proper axes
plot(t,x)
set(handles.axes1,'XMinorTick','on')
grid on

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

% handles    structure with handles and user data (see GUIDATA)
global file_name;
if(~ischar(file_name))
   errordlg('Please select Audio first');
else
[Data,Fs,bits] = wavread(file_name);
[Data, Fs, bits] = wavread('Windows XP Startup.wav');

%chosing a block size 
windowSize = 8192;

%changing compression  percentages
samplesHalf = windowSize / 2;
samplesQuarter = windowSize / 4;
samplesEighth = windowSize / 8;

%initializing compressed matrice
DataCompressed2 = [];
DataCompressed4 = [];
DataCompressed8 = [];

%actual compression
for i=1:windowSize:length(Data)-windowSize
    windowDCT = dct(Data(i:i+windowSize-1));
    DataCompressed2(i:i+windowSize-1) = idct(windowDCT(1:samplesHalf), windowSize);
    DataCompressed4(i:i+windowSize-1) = idct(windowDCT(1:samplesQuarter), windowSize);
    DataCompressed8(i:i+windowSize-1) = idct(windowDCT(1:samplesEighth), windowSize);
end

wavwrite(DataCompressed2,Fs,bits,'output3.wav')
[x,Fs,bits] = wavread('output3.wav');
fileinfo = dir('output3.wav');
SIZE = fileinfo.bytes;
Size = SIZE/1024;
xlen=length(x);
t=0:1/Fs:(length(x)-1)/Fs;
set(handles.text14,'string',Size);
%plot(t,x);
axes(handles.axes2) % Select the proper axes
plot(t,x)
set(handles.axes2,'XMinorTick','on')
grid on

wavwrite(DataCompressed4,Fs,bits,'output4.wav')
[x,Fs,bits] = wavread('output4.wav');
fileinfo = dir('output4.wav');
SIZE = fileinfo.bytes;
Size = SIZE/1024;
xlen=length(x);
t=0:1/Fs:(length(x)-1)/Fs;
set(handles.text16,'string',Size);
%plot(t,x);
axes(handles.axes3) % Select the proper axes
plot(t,x)
set(handles.axes3,'XMinorTick','on')
grid on

wavwrite(DataCompressed8,Fs,bits,'output5.wav')
[x,Fs,bits] = wavread('output5.wav');
fileinfo = dir('output5.wav');
SIZE = fileinfo.bytes;
Size = SIZE/1024;
xlen=length(x);
t=0:1/Fs:(length(x)-1)/Fs;
set(handles.text18,'string',Size);
%plot(t,x);
axes(handles.axes4) % Select the proper axes
plot(t,x)
set(handles.axes4,'XMinorTick','on')
grid on


[y1,fs1, nbits1,opts1]=wavread(file_name);
[y2,fs2, nbits2,opts2]=wavread('output3.wav');
[c1x,c1y]=size(y1);
[c2x,c2y]=size(y1);
if c1x ~= c2x
    disp('dimeonsions do not agree');
 else
 R=c1x;
 C=c1y;
  err = (sum(y1(2)-y2).^2)/(R*C);
 MSE=sqrt(err);
 MAXVAL=255;
   PSNR = 20*log10(MAXVAL/MSE); 
  MSE= num2str(MSE);
if(MSE > 0)
  PSNR= num2str(PSNR);
   else
PSNR = 99;
end
fileinfo = dir(file_name);
SIZE = fileinfo.bytes;
Size = SIZE/1024;
fileinfo1 = dir('output3.wav');
SIZE1 = fileinfo1.bytes;
Size1 = SIZE1/1024;

CompressionRatio = Size/Size1;

  set(handles.text21,'string',PSNR)
  set(handles.text23,'string',MSE)
  set(handles.text24,'string',CompressionRatio)
end
end