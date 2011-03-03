function varargout = mask_gui(varargin)
% MASK_GUI M-file for mask_gui.fig
%      MASK_GUI, by itself, creates a new MASK_GUI or raises the existing
%      singleton*.
%
%      H = MASK_GUI returns the handle to a new MASK_GUI or the handle to
%      the existing singleton*.
%
%      MASK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASK_GUI.M with the given input arguments.
%
%      MASK_GUI('Property','Value',...) creates a new MASK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mask_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mask_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mask_gui

% Last Modified by GUIDE v2.5 28-Mar-2005 18:27:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mask_gui_OpeningFcn, ...
    'gui_OutputFcn',  @mask_gui_OutputFcn, ...
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
end


% --- Executes just before mask_gui is made visible.
function mask_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mask_gui (see VARARGIN)

handles.setname=varargin{1};
handles.imnum=1;       %need to loop over all images
handles.set=evalin('base',handles.setname);         %pass in structure from base workspace

%get name for new mask
if ~isfield(handles.set,'maskname')
    newmaskname=inputdlg({'Name for this mask'});
    nmasks=0
else
    newmaskname=inputdlg({'Name for this mask'});
    %check to see if mask name is already used
    if any(strcmp(newmaskname, handles.set.maskname))
        while (1)
            newmaskname=inputdlg({'That name is already used.  Name for this mask'});
            if ~any(strcmp(newmaskname, handles.set.maskname))
                break
            end
        end
    end
    nmasks=max(size(handles.set.maskname));
end
handles.set.maskname{nmasks+1}=newmaskname{1};
handles.mask_idx=nmasks+1;
handles.set.maskname{nmasks+1}=newmaskname{1};
handles.mask_idx=nmasks+1;

handles.scaleval=(2^handles.set.bitdepth)-1;
handles=load_images(handles);

%LOCAL THRESHOLDING PARAMETERS
handles.H=fspecial('average',str2double(get(handles.neighborhood_edit,'String')));

% Choose default command line output for mask_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
display_image(handles)

% UIWAIT makes mask_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = mask_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
end

% --- Executes during object creation, after setting all properties.
function threshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
end

% --- Executes on slider movement.
function threshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.threshold_text,'String',num2str(get(hObject,'Value')));
display_image(handles);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function threshold_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
end

function threshold_text_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_text as text
%        str2double(get(hObject,'String')) returns contents of threshold_text as a double

set(handles.threshold_slider,'Value',str2double(get(hObject,'String')));
display_image(handles);
guidata(hObject, handles);
end

% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.set.image(handles.imnum).mask(handles.mask_idx).mask=calc_mask(handles);
if (handles.imnum < max(size(handles.set.image)))
    handles.imnum = handles.imnum+1;
    handles = load_images(handles);
    if (isfield(handles,'roi'))
        handles=rmfield(handles,'roi');
    end
    guidata(hObject, handles);
    display_image(handles);
elseif (handles.imnum == max(size(handles.set.image)))
    %copy set back into base workspace
    assignin('base',handles.setname,handles.set)        %update setname in base workspace
    uiresume
else
    error('We should not be here')
end
guidata(hObject, handles);
end

% --- Executes on button press in abs_threshold.
function abs_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to abs_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of abs_threshold
mutual_exclude(handles.local_threshold);
if get(hObject, 'Value') == get(hObject, 'Min')
    set(handles.threshold_slider,'Enable','off');
    set(handles.threshold_text,'Enable','off');
    set(handles.Donor_button,'Enable','off');
    set(handles.Acceptor_button,'Enable','off');
    display_image(handles);
else
    set(handles.threshold_slider,'Enable','on');
    set(handles.threshold_text,'Enable','on');    
    set(handles.Donor_button,'Enable','on');
    set(handles.Acceptor_button,'Enable','on');
    display_image(handles);
end
guidata(hObject, handles);
end

% --- Executes on button press in local_threshold.
function local_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to local_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutual_exclude(handles.abs_threshold);
if get(hObject, 'Value') == get(hObject, 'Min')
    set(handles.threshold_slider,'Enable','off');
    set(handles.threshold_text,'Enable','off');
    set(handles.Donor_button,'Enable','off');
    set(handles.Acceptor_button,'Enable','off');
    display_image(handles);
else
    set(handles.threshold_slider,'Enable','on');
    set(handles.threshold_text,'Enable','on');    
    set(handles.Donor_button,'Enable','on');
    set(handles.Acceptor_button,'Enable','on');
    display_image(handles);
end
guidata(hObject, handles);
end

% --- Executes on button press in exclude_roi.
function exclude_roi_Callback(hObject, eventdata, handles)
% hObject    handle to exclude_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 new_roi=~(roipoly);
if (isfield(handles,'roi'))
    handles.roi = handles.roi & new_roi;
else
    handles.roi = new_roi;
end
display_image(handles);
guidata(hObject, handles);
uiwait;
end

% --- Executes on button press in include_roi.
function include_roi_Callback(hObject, eventdata, handles)
% hObject    handle to include_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

new_roi=roipoly;
if (isfield(handles,'roi'))
    handles.roi = handles.roi | new_roi;
else
    handles.roi = new_roi;
end
display_image(handles);
guidata(hObject, handles);
end

% --- Executes on button press in Donor_button.
function Donor_button_Callback(hObject, eventdata, handles)
% hObject    handle to Donor_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Donor_button
mutual_exclude(handles.Acceptor_button);
display_image(handles);
guidata(hObject, handles);
end

% --- Executes on button press in Acceptor_button.
function Acceptor_button_Callback(hObject, eventdata, handles)
% hObject    handle to Acceptor_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mutual_exclude(handles.Donor_button);
display_image(handles);
guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function neighborhood_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighborhood_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
end

function neighborhood_edit_Callback(hObject, eventdata, handles)
% hObject    handle to neighborhood_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighborhood_edit as text
%        str2double(get(hObject,'String')) returns contents of neighborhood_edit as a double
handles.H=fspecial('average',str2double(get(handles.neighborhood_edit,'String')));
display_image(handles);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function min_size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
end

function min_size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to min_size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_size_edit as text
%        str2double(get(hObject,'String')) returns contents of min_size_edit as a double
display_image(handles);
guidata(hObject, handles);
end

%----------------------------------------------------------------
%End of callbacks

function mutual_exclude(off)
set(off,'Value',0)
return
end

function display_image(handles)
scaleval=handles.scaleval;
min_struct_size=str2double(get(handles.min_size_edit,'String'));
maskI=0.5;
if (isfield(handles,'DIC'))
    temp=handles.DIC/(2*max(handles.DIC(:)));
else
    temp = zeros(size(handles.A));
end
RGB=cat(3,temp,temp,temp);

Ib=calc_mask(handles);
RGB(:,:,1)=min(1,RGB(:,:,1)+maskI*Ib);

if ~(strcmpi(handles.set.sample_type,'D'))
    RGB(:,:,2)=min(1,RGB(:,:,2)+handles.A/max(handles.A(:)));
end
if ~(strcmpi(handles.set.sample_type,'A'))
    RGB(:,:,3)=min(1,RGB(:,:,3)+handles.D/max(handles.D(:)));
end
axes(handles.axes1);
imshow(RGB)
drawnow
end

function Ib=calc_mask(handles)
scaleval=handles.scaleval;
%CONTROL PARAMETERS
min_struct_size=str2double(get(handles.min_size_edit,'String'));
if (get(handles.local_threshold,'Value') == get(handles.local_threshold,'Max'))
    threshold=get(handles.threshold_slider,'Value');
    if (get(handles.Donor_button,'Value') == get(handles.Donor_button,'Max'))
        Ifilt=imfilter(handles.D,handles.H);
        Ib=im2bw((handles.D-Ifilt)/scaleval,threshold/scaleval);
    else
        Ifilt=imfilter(handles.A,handles.H);
        Ib=im2bw((handles.A-Ifilt)/scaleval,threshold/scaleval);
    end
    Ib=imclearborder(Ib); %remove objects at edge of image
    Ib=bwareaopen(Ib,min_struct_size); %remove structures smaller than min_struct_size pixels
    if (isfield(handles,'roi'))
        Ib = Ib.*double(handles.roi);
    end
elseif (get(handles.abs_threshold,'Value') == get(handles.abs_threshold,'Max'))
    threshold=get(handles.threshold_slider,'Value');
    if (get(handles.Donor_button,'Value') == get(handles.Donor_button,'Max'))
        Ib=im2bw(handles.D/scaleval,threshold/scaleval);
    else
        Ifilt=imfilter(handles.A,handles.H);
        Ib=im2bw(handles.A/scaleval,threshold/scaleval);
    end
    Ib=imclearborder(Ib); %remove objects at edge of image
    Ib=bwareaopen(Ib,min_struct_size); %remove structures smaller than min_struct_size pixels
    if (isfield(handles,'roi'))
        Ib = Ib.*double(handles.roi);
    end
else
    if (isfield(handles,'roi'))
        Ib = handles.roi;
    else
        Ib = ones(size(handles.D));
    end
end
Ib=logical(Ib);
end

function handles = load_images(handles)
handles.D=max(0,double(handles.set.image(handles.imnum).donor));
handles.A=max(0,double(handles.set.image(handles.imnum).acceptor));
if isfield(handles.set.image(handles.imnum),'dic')
    handles.DIC=double(handles.set.image(handles.imnum).dic);
end
end





