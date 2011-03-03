function varargout = get_dv_regions(varargin)
% GET_DV_REGIONS M-file for get_dv_regions.fig
%      GET_DV_REGIONS, by itself, creates a new GET_DV_REGIONS or raises the existing
%      singleton*.
%
%      H = GET_DV_REGIONS returns the handle to a new GET_DV_REGIONS or the handle to
%      the existing singleton*.
%
%      GET_DV_REGIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GET_DV_REGIONS.M with the given input arguments.
%
%      GET_DV_REGIONS('Property','Value',...) creates a new GET_DV_REGIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before get_dv_regions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to get_dv_regions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help get_dv_regions

% Last Modified by GUIDE v2.5 11-May-2004 13:37:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @get_dv_regions_OpeningFcn, ...
    'gui_OutputFcn',  @get_dv_regions_OutputFcn, ...
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


% --- Executes just before get_dv_regions is made visible.
function get_dv_regions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to get_dv_regions (see VARARGIN)

%get list of variables from the workspace
variables=evalin('base','whos');
image_list={};
for n=1:size(variables,1)
    if strcmpi(variables(n).class, 'struct')
        if evalin('base',['isfield( ', variables(n).name, ', ''image'')'])
            image_list=cat(1,image_list,{variables(n).name});
        end
    end
end
set(handles.image_sets,'String',image_list);
handles.dataset=evalin('base',image_list{1}); %select first set in listbox
handles.curr_image=1;
update_slider_range(handles)


% Choose default command line output for get_dv_regions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes get_dv_regions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = get_dv_regions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FRETc.
function FRETc_Callback(hObject, eventdata, handles)
% hObject    handle to FRETc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FRETc
display_image(handles);


% --- Executes on button press in Donor.
function Donor_Callback(hObject, eventdata, handles)
% hObject    handle to Donor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Donor
display_image(handles);

% --- Executes on button press in Acceptor.
function Acceptor_Callback(hObject, eventdata, handles)
% hObject    handle to Acceptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Acceptor
display_image(handles);

% --- Executes on button press in dic.
function DIC_Callback(hObject, eventdata, handles)
% hObject    handle to dic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display_image(handles);


% --- Executes during object creation, after setting all properties.
function image_sets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in image_sets.
function image_sets_Callback(hObject, eventdata, handles)
% hObject    handle to image_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(hObject,'String'); %returns image_sets contents as cell array
name = contents{get(hObject,'Value')} %returns selected item from image_sets
handles.dataset=evalin('base',name);
handles.curr_image=1;
update_slider_range(handles)
display_image(handles)

% Choose default command line output for get_dv_regions
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function image_num_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_num_slider (see GCBO)
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


% --- Executes on slider movement.
function image_num_slider_Callback(hObject, eventdata, handles)
% hObject    handle to image_num_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.curr_image = get(hObject, 'Value');
update_slider_value(handles)
display_image(handles)

% Choose default command line output for get_dv_regions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function image_num_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_num_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
[filename,pathname]=uiputfile('image.tif','Name of file to write');
s=regexp(filename,'.tif')
if s
    f=fullfile(pathname,filename)
else
    f=fullfile(pathname,strcat(filename,'.tif'))
end
Im=create_image(handles);
imwrite(Im,f,'tiff');
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--- function to create an image, reading current settings from GUI ---%
function Im=create_image(handles)
if get(handles.DIC, 'Value') == get(handles.DIC, 'Max')
    dic=double(handles.dataset.image(handles.curr_image).dic);
    dic=dic/(2*max(dic(:)));
    Im=cat(3,dic,dic,dic);
    if get(handles.Donor, 'Value') == get(handles.Donor, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).donor));
        temp=temp/max(temp(:));
        Im(:,:,3)=min(1,Im(:,:,3)+temp);
    end
    if get(handles.Acceptor, 'Value') == get(handles.Acceptor, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).acceptor));
        temp=temp/max(temp(:));
        Im(:,:,2)=min(1,Im(:,:,2)+temp);
    end
    if get(handles.FRETc, 'Value') == get(handles.FRETc, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).FRETc));
        temp=temp/max(temp(:));
        Im(:,:,1)=min(1,Im(:,:,1)+temp);
    end
else
    Im=zeros( [size(double(handles.dataset.image(handles.curr_image).dic)) 3]);
    if get(handles.Donor, 'Value') == get(handles.Donor, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).donor));
        temp=temp/max(temp(:));
        Im(:,:,3)=temp;
    end
    if get(handles.Acceptor, 'Value') == get(handles.Acceptor, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).acceptor));
        temp=temp/max(temp(:));
        Im(:,:,2)=temp;
    end
    if get(handles.FRETc, 'Value') == get(handles.FRETc, 'Max')
        temp=max(0,double(handles.dataset.image(handles.curr_image).FRETc));
        temp=temp/max(temp(:));
        Im(:,:,1)=temp;
    end
end


%--- function to display an image, reading current settings from GUI ---%
function display_image(handles)
Im=create_image(handles);
imshow(Im)


%--- function to update slider range ---%
function update_slider_range(handles)
slider_max=max(size(handles.dataset.image));
slider_min=1;
slider_step(1)=1/(slider_max-slider_min);
slider_step(2)=1/(slider_max-slider_min);
slider_value=handles.curr_image;
set(handles.image_num_slider, 'sliderstep', slider_step, 'max', slider_max, 'min', slider_min, ...
    'Value', slider_value);
curr_image_str=num2str(slider_value,'%2d');
set(handles.image_num_text, 'String', curr_image_str);

%--- function to update slider value ---%
function update_slider_value(handles)
set(handles.image_num_slider, 'Value', handles.curr_image);
set(handles.image_num_text, 'String', num2str(handles.curr_image, '%2d'));


% --- Executes on button press in L_donor.
function L_donor_Callback(hObject, eventdata, handles)
% hObject    handle to L_donor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of L_donor


% --- Executes on button press in L_acceptor.
function L_acceptor_Callback(hObject, eventdata, handles)
% hObject    handle to L_acceptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of L_acceptor


% --- Executes on button press in R_donor.
function R_donor_Callback(hObject, eventdata, handles)
% hObject    handle to R_donor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of R_donor


% --- Executes on button press in R_acceptor.
function R_acceptor_Callback(hObject, eventdata, handles)
% hObject    handle to R_acceptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of R_acceptor


