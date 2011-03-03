function varargout = fretopt(varargin)
% FRETOPT M-file for fretopt.fig
%      FRETOPT, by itself, creates a new FRETOPT or raises the existing
%      singleton*.
%
%      H = FRETOPT returns the handle to a new FRETOPT or the handle to
%      the existing singleton*.
%
%      FRETOPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRETOPT.M with the given input arguments.
%
%      FRETOPT('Property','Value',...) creates a new FRETOPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fretopt_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fretopt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fretopt

% Last Modified by GUIDE v2.5 30-Aug-2004 09:56:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fretopt_OpeningFcn, ...
                   'gui_OutputFcn',  @fretopt_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fretopt is made visible.
function fretopt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fretopt (see VARARGIN)

% Choose default command line output for fretopt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fretopt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fretopt_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function bitdepth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bitdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function bitdepth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bitdepth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bitdepth_edit as text
%        str2double(get(hObject,'String')) returns contents of bitdepth_edit as a double


% --- Executes during object creation, after setting all properties.
function threshold_const_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_const_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function threshold_const_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_const_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_const_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_const_edit as a double


% --- Executes during object creation, after setting all properties.
function threshold_frac_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_frac_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function threshold_frac_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_frac_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_frac_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_frac_edit as a double

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FRET_OPTIONS.bitdepth=str2double(get(handles.bitdepth_edit,'String'));
FRET_OPTIONS.threshold_const=str2double(get(handles.threshold_const_edit,'String'));
FRET_OPTIONS.threshold_frac=str2double(get(handles.threshold_frac_edit,'String'));
methods = get(handles.bkgd_method,'String');
FRET_OPTIONS.bkgd_method=methods{get(handles.bkgd_method,'Value')};
assignin('base','FRET_OPTIONS',FRET_OPTIONS);


% --- Executes during object creation, after setting all properties.
function bkgd_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bkgd_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in bkgd_method.
function bkgd_method_Callback(hObject, eventdata, handles)
% hObject    handle to bkgd_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns bkgd_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bkgd_method


