function varargout = eff_gui(varargin)
% EFF_GUI M-file for eff_gui.fig
%      EFF_GUI, by itself, creates a new EFF_GUI or raises the existing
%      singleton*.
%
%      H = EFF_GUI returns the handle to a new EFF_GUI or the handle to
%      the existing singleton*.
%
%      EFF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EFF_GUI.M with the given input arguments.
%
%      EFF_GUI('Property','Value',...) creates a new EFF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eff_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eff_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eff_gui

% Last Modified by GUIDE v2.5 28-May-2004 16:33:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @eff_gui_OpeningFcn, ...
    'gui_OutputFcn',  @eff_gui_OutputFcn, ...
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


% --- Executes just before eff_gui is made visible.
function eff_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eff_gui (see VARARGIN)

% Choose default command line output for eff_gui
handles.output = hObject;

%eff_gui should get called with a cell array of the names of datasets to
%analyze (to be read from the workspace).  First we need to save this list.

handles.setnames=varargin{1};
handles.total_sets=max(size(handles.setnames));
handles=initialize_set(handles,1);
set(handles.name_edit,'String',[handles.setnames{1},'_eff']);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eff_gui wait for user response (see UIRESUME)
 uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = eff_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function mask_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mask_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Mask_list.
function mask_list_Callback(hObject, eventdata, handles)
% hObject    handle to Mask_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Mask_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Mask_list

% --- Executes on button press in new_mask.
function new_mask_Callback(hObject, eventdata, handles)
% hObject    handle to new_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLA
% handles    structure with handles and user data (see GUIDATA)

mask_gui(handles.setnames{handles.setnum});
close(findobj('Name','mask_gui'))
%need to reread mask list
handles=initialize_set(handles,handles.setnum);

% --- Executes on button press in go_button.
function go_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

masknum=get(handles.mask_list,'Value');
maskstring=get(handles.mask_list,'String');
maskname=maskstring{masknum};

if (isfield(handles,'eff_struct'))
    eff_struct=handles.eff_struct;
    a=max(size((eff_struct.Fc_mean)))+1;
else
    a=1;
end

struct_name=get(handles.name_edit,'String');
set(handles.name_edit,'Enable','off')

anal_set=evalin('base',handles.setnames{handles.setnum});         %pass in structure from base workspace
scaleval=(2^anal_set.bitdepth)-1;    
AF=anal_set.autofluor;
for n=1:size(anal_set.image,2) 
    D=double(anal_set.image(n).donor)-AF(1);
    A=double(anal_set.image(n).acceptor)-AF(2);
    FRETc=double(anal_set.image(n).FRETc)-AF(3);
    satpixels=anal_set.image(n).satpixels;
    fret=double(anal_set.image(n).fret);
    if (strcmpi(maskname,'None'))
        mask = ones(size(F));
    else
        mask=full(double(anal_set.image(n).mask(masknum).mask));
    end
    
    [L,num]=bwlabel(mask);
    for i=1:num
        
        pix=find(L==i);
        %if skip_object_radio is true and there are saturated pixels in
        %this region, skip it.
        if get(handles.skip_object_radio,'Value') && any(satpixels(pix))
            continue;
        end
        %otherwise just ignore saturated pixels in the region
        pix=find(L==i & ~satpixels);
        eff_struct.Fc_mean(a)=mean(FRETc(pix));
        eff_struct.F_mean(a)=mean(fret(pix));
        eff_struct.A_mean(a)=mean(A(pix));
        eff_struct.D_mean(a)=mean(D(pix));
        imnum(a)=n;
        a=a+1;
    end
end

%get exposure times
donor_exp=anal_set.exp_time.donor;
acceptor_exp=anal_set.exp_time.acceptor;
fret_exp=anal_set.exp_time.fret;

G=get_exp_type('G',anal_set.exp_type);
eff_struct.E=((eff_struct.Fc_mean/fret_exp)*G)./((eff_struct.Fc_mean/fret_exp)*G+(eff_struct.D_mean/donor_exp));

handles.eff_struct=eff_struct;
assignin('base',struct_name,eff_struct)        %update setname in base workspace
if (handles.setnum == max(size(handles.setnames)))
    %we're done
    uiresume;
else
    handles=initialize_set(handles, handles.setnum+1);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_edit as text
%        str2double(get(hObject,'String')) returns contents of name_edit as a double

% --- Executes on button press in skip_object_radio.
function skip_object_radio_Callback(hObject, eventdata, handles)
% hObject    handle to skip_object_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutual_exclude(handles.skip_pixel_radio);

% --- Executes on button press in skip_pixel_radio.
function skip_pixel_radio_Callback(hObject, eventdata, handles)
% hObject    handle to skip_pixel_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutual_exclude(handles.skip_object_radio);

%---------------------------
%end of callbacks
%---------------------------

function mutual_exclude(off)
set(off,'Value',0)
return

function handles=initialize_set(handles,setnum)
%set up gui with parameters from handles.setnames{setnum}.
handles.setnum=setnum;
setname=handles.setnames{setnum};
if (evalin('base',['isfield(',setname,',''maskname'')']))
    masknames=evalin('base',[setname,'.maskname']);
    masknames{size(masknames,2)+1}='None';
else
    masknames={'None'};
end
if (get(handles.mask_list,'Value') > max(size(masknames)))
    set(handles.mask_list,'Value',max(size(masknames)));
end
set(handles.mask_list,'String',masknames);
set(handles.go_button,'String',['Analyze ',setname]);