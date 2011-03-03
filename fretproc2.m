function varargout = fretproc2(varargin)
% FRET M-file for FRET.fig
%      FRET, by itself, creates a new FRET or raises the existing
%      singleton*.
%
%      H = FRET returns the handle to a new FRET or the handle to
%      the existing singleton*.
%
%      FRET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRET.M with the given input arguments.
%
%      FRET('Property','Value',...) creates a new FRET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FRET_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FRET_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FRET

% Last Modified by GUIDE v2.5 22-Sep-2004 17:56:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FRET_OpeningFcn, ...
    'gui_OutputFcn',  @FRET_OutputFcn, ...
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


% --- Executes just before FRET is made visible.
function FRET_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FRET (see VARARGIN)

% Choose default command line output for FRET
handles.output = hObject;
update_variables(handles);
exp_types=get_exp_type('list');
set(handles.exp_type_box,'String',exp_types);

%define image type lists for filedef
handles.params.filetypes={'ignore';'other (enter at right)';'donor';'acceptor';'fret';'dic'};
handles.params.dv_filetypes={'ignore';'other (enter at right)';'donor excitation';'acceptor excitation';'dic'};

%set default options if necessary
if ~evalin('base','exist(''FRET_OPTIONS'')')
    set_default_fret_options;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FRET wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FRET_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function dir_sets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in dir_sets.
function dir_sets_Callback(hObject, eventdata, handles)
% hObject    handle to dir_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dir_sets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dir_sets


% --- Executes during object creation, after setting all properties.
function loaded_sets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loaded_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in loaded_sets.
function loaded_sets_Callback(hObject, eventdata, handles)
% hObject    handle to loaded_sets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns loaded_sets contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loaded_sets


% --- Executes during object creation, after setting all properties.
function dir_to_load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_to_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function dir_to_load_Callback(hObject, eventdata, handles)
% hObject    handle to dir_to_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dir_to_load as text
%        str2double(get(hObject,'String')) returns contents of dir_to_load as a double

%read directory and display metamorph image sets in listbox
directory=get(hObject,'String');
[imnames, fileformat] = fp_parse_directory(directory);
set(handles.dir_sets,'String',imnames);
handles.params.fileformat = fileformat;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in type_donor.
function type_donor_Callback(hObject, eventdata, handles)
% hObject    handle to type_donor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_donor

mutual_exclude([handles.type_acceptor,handles.type_both]);
guidata(hObject, handles);

% --- Executes on button press in type_acceptor.
function type_acceptor_Callback(hObject, eventdata, handles)
% hObject    handle to type_acceptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_acceptor

mutual_exclude([handles.type_both,handles.type_donor]);
guidata(hObject, handles);

% --- Executes on button press in type_both.
function type_both_Callback(hObject, eventdata, handles)
% hObject    handle to type_both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of type_both

mutual_exclude([handles.type_acceptor,handles.type_donor]);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function exp_type_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_type_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in exp_type_box.
function exp_type_box_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns exp_type_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from exp_type_box


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.type_donor,'Value'))
    samp_type='D';
elseif (get(handles.type_acceptor,'Value'))
    samp_type='A';
elseif (get(handles.type_both,'Value'))
    samp_type='B';
else
    errordlg('Select a sample type','error')
    return;
end

imdir=get(handles.dir_to_load,'String');
set_list=get(handles.dir_sets,'String');
set_idx=get(handles.dir_sets,'Value');
exp_strings=get(handles.exp_type_box,'String');
exp_val=get(handles.exp_type_box,'Value')
exp_type=exp_strings(exp_val);

switch(handles.params.fileformat)
    case 'metamorph'
        separator='_1_';
    case 'niselements'
        separator='xy1';
end

for n=1:max(size(set_idx))
    set_name=set_list{set_idx(n)};
    %get file extension mapping
    %build a structure array: wavemap(n).name; wavemap(n).type
    %want to keep master list (above) but also need to keep list for set
    %we're currently loading
    dir_struct=dir(fullfile(imdir,strcat(set_name,separator,'*.tif')));    %get all tif files from image1 of set1
    i=1;
    j=1;
    for n=1:size(dir_struct,1)          %iterate over all tiff files to identify wavelengths
        [s,f,t]=regexpi(dir_struct(n).name,strcat('.+?',separator,'(.+)\.tif'));  %file name is name_1_wavelength.tif - we want the wavelength string
        t=cell2mat(t);
        currwave{j}=dir_struct(n).name(t(1):t(2));
        waveexist=0;
        if isfield(handles,'wavemap') && isfield(handles.wavemap,'name')
            for n=1:max(size(handles.wavemap))
                waveexist = waveexist | strcmp(handles.wavemap(n).name, currwave{j});
            end
        end
        if waveexist
            j=j+1;
            continue
        else
            waves2test{i}=currwave{j};
            i=i+1;
            j=j+1;
        end
    end

    if exist('waves2test')
        if (get(handles.dv_checkbox,'Value')==get(handles.dv_checkbox,'Min'))
            wavematches=filedef(waves2test,handles.params.filetypes);       %call filedef to get user assigned wavelength types
        else
            wavematches=filedef(waves2test,handles.params.dv_filetypes);    %same, with dualview parameters
        end

        close(findobj('Name','filedef'))
        if isfield(handles, 'wavemap')
            n_existwaves=max(size(handles.wavemap));
        else
            n_existwaves=0;
        end
        for n=1:max(size(wavematches))
            handles.wavemap(n+n_existwaves).name=waves2test{n};
            handles.wavemap(n+n_existwaves).type=wavematches{n};
        end
    end
    %now build matching array of types for currwave
    for n=1:max(size(currwave))
        for m=1:max(size(handles.wavemap))
            if strcmpi(handles.wavemap(m).name,currwave{n})
                currtype{n}=handles.wavemap(m).type;
            end
        end
    end
    if get(handles.dv_checkbox,'Value')
        image_set=load_dv_images(imdir,set_name,currwave,currtype,samp_type,exp_type);
    else
        image_set=load_fret_images(imdir,set_name,currwave,currtype,samp_type,exp_type,handles.params.fileformat);
    end
    image_set.autofluor=get_autofluor(handles);
    assignin('base',set_name,image_set)        %update setname in base workspace
    update_variables(handles);
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in xtalk_button.
function xtalk_button_Callback(hObject, eventdata, handles)
% hObject    handle to xtalk_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_list=get(handles.loaded_sets,'String');
set_idx=get(handles.loaded_sets,'Value');
for n=1:max(size(set_idx))
    xtalk_sets{n}=set_list{set_idx(n)};
end
handles.xtalk=xtalk_gui(xtalk_sets);
close(findobj('Name','xtalk_gui'))
close(findobj('Name','Overall fit'))

set(handles.xtalk1,'String',num2str(handles.xtalk.fit(1)));
set(handles.xtalk2,'String',num2str(handles.xtalk.fit(2)));
set(handles.xtalk3,'String',num2str(handles.xtalk.fit(3)));

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function xtalk1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xtalk1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function xtalk1_Callback(hObject, eventdata, handles)
% hObject    handle to xtalk1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xtalk1 as text
%        str2double(get(hObject,'String')) returns contents of xtalk1 as a double
handles.xtalk.fit(1)=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xtalk2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xtalk2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function xtalk2_Callback(hObject, eventdata, handles)
% hObject    handle to xtalk2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xtalk2 as text
%        str2double(get(hObject,'String')) returns contents of xtalk2 as a double
handles.xtalk.fit(2)=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xtalk3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xtalk3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function xtalk3_Callback(hObject, eventdata, handles)
% hObject    handle to xtalk3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xtalk3 as text
%        str2double(get(hObject,'String')) returns contents of xtalk3 as a double
handles.xtalk.fit(3)=str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes on button press in FRETc_button.
function FRETc_button_Callback(hObject, eventdata, handles)
% hObject    handle to FRETc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_list=get(handles.loaded_sets,'String');
set_idx=get(handles.loaded_sets,'Value');
for n=1:max(size(set_idx))
    fretc_sets{n}=set_list{set_idx(n)};
end
calc_FRETc(fretc_sets,handles.xtalk);


% --- Executes on button press in calc_eff.
function calc_eff_Callback(hObject, eventdata, handles)
% hObject    handle to calc_eff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_list=get(handles.loaded_sets,'String');
set_idx=get(handles.loaded_sets,'Value');
for n=1:max(size(set_idx))
    eff_sets{n}=set_list{set_idx(n)};
end
eff_gui(eff_sets);
close(findobj('Name','eff_gui'));

% --- Executes on button press in exp_images.
function exp_images_Callback(hObject, eventdata, handles)
% hObject    handle to exp_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_list=get(handles.loaded_sets,'String');
set_idx=get(handles.loaded_sets,'Value');
for n=1:max(size(set_idx))
    export_sets{n}=set_list{set_idx(n)};
end
dirname=uigetdir('Z:\','Directory to write files to?');

for set_idx=1:max(size(export_sets))
    set=evalin('base',export_sets{set_idx});         %pass in structure from base workspace
    setname=export_sets{set_idx};
    for n=1:size(set.image,2)       %loop over all images
        %write donor, bkgd sub
        I=uint16(max(0,set.image(n).donor));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_donor.tif'));
        imwrite(I,filename,'tif');
        %write dic, bkgd sub
        I=uint16(max(0,set.image(n).dic));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_dic.tif'));
        imwrite(I,filename,'tif');
        %write acceptor, bkgd sub
        I=uint16(max(0,set.image(n).acceptor));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_acceptor.tif'));
        imwrite(I,filename,'tif');
        %write fret, bkgd sub
        I=uint16(max(0,set.image(n).fret));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_fretraw.tif'));
        imwrite(I,filename,'tif');
        %write FRETc
        I=uint16(max(0,set.image(n).FRETc));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_fretc.tif'));
        imwrite(I,filename,'tif');
        %write E
        I=uint8(255*double(min(1,(max(0,set.image(n).E)))));
        filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_E.tif'));
        imwrite(I,filename,'tif');
        %write E_err
        %I=uint8(255*double(min(1,(max(0,set.image(n).E)))));
        %filename=fullfile(dirname,strcat(setname,'_',sprintf('%d',n),'_E_err.tif'));
        %imwrite(I,filename,'tif');
    end
end

% --- Executes on button press in dv_checkbox.
function dv_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to dv_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dv_checkbox

function auto_D_Callback(hObject, eventdata, handles)
% hObject    handle to auto_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auto_D as text
%        str2double(get(hObject,'String')) returns contents of auto_D as a double

%--- Executes during object creation, after setting all properties.
function auto_D_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function auto_A_Callback(hObject, eventdata, handles)
% hObject    handle to auto_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auto_A as text
%        str2double(get(hObject,'String')) returns contents of auto_A as a double

% --- Executes during object creation, after setting all properties.
function auto_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function auto_F_Callback(hObject, eventdata, handles)
% hObject    handle to auto_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auto_F as text
%        str2double(get(hObject,'String')) returns contents of auto_F as a double

% --- Executes during object creation, after setting all properties.
function auto_F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Apply_AF.
function Apply_AF_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_AF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AF=get_autofluor(handles);
set_list=get(handles.loaded_sets,'String');
set_idx=get(handles.loaded_sets,'Value');
for n=1:max(size(set_idx))
    set_name=set_list{set_idx(n)};
    curr_set=evalin('base',set_name);         %pass in structure from base workspace
    curr_set.autofluor=AF;
    assignin('base',set_name,curr_set);        %update setname in base workspace
end
guidata(hObject, handles);

%---------------------------
%end of callbacks
%---------------------------
function mutual_exclude(off)
set(off,'Value',0)

function AF=get_autofluor(handles)
AF(1)=str2double(get(handles.auto_D,'String'));
AF(2)=str2double(get(handles.auto_A,'String'));
AF(3)=str2double(get(handles.auto_F,'String'));

%get list of variables from the workspace
function update_variables(handles)
variables=evalin('base','whos');
image_list={};
for n=1:size(variables,1)
    if strcmpi(variables(n).class, 'struct')
        if evalin('base',['isfield( ', variables(n).name, ', ''image'')'])
            image_list=cat(1,image_list,{variables(n).name});
        end
    end
end
set(handles.loaded_sets,'String',image_list);

function image_set=load_fret_images(imdir,set_name,waves,types,samp_type,exp_type,fileformat)
%LOAD_SET(SET_NAME, EXP_TYPE, SAMPLE_TYPE, {XTALK}): Loads a FRET data set.
%This program will load all images of the form SETNAME_#_suffix.
%SAMPLE_TYPE is one of 'D' (donor only), 'A' (acceptor only), or 'B' (both)

%get bitdepth
options=evalin('base','FRET_OPTIONS');
bitdepth=options.bitdepth;
maxval=(2^bitdepth)-1;

image_set.bitdepth=bitdepth;
image_set.exp_type=exp_type;
image_set.bkgd_method='mode';
image_set.sample_type=samp_type;
image_set.exp_time=[];

for n=1:50
    switch fileformat
        case 'metamorph'
            fname=strcat(set_name,'_',sprintf('%d',n),'_',waves{1},'.tif')
        case 'niselements'
            fname=strcat(set_name,'xy',sprintf('%d',n),waves{1},'.tif')
    end
    path=fullfile(imdir, fname);
    if (~exist (path, 'file'))
        break;
    end
    for i=1:max(size(waves))

        %skip 'ignore'd images
        if strcmp(types{i},'ignore')
            continue
        end

        %construct path
        switch fileformat
            case 'metamorph'
                fname=strcat(set_name,'_',sprintf('%d',n),'_',waves{i},'.tif');
            case 'niselements'
                fname=strcat(set_name,'xy',sprintf('%d',n),waves{i},'.tif');
        end
        path=fullfile(imdir, fname);

        bkgd_method=evalin('base','FRET_OPTIONS.bkgd_method');
        %load images
        if strcmp(types{i},'dic')
            Imstruct=imload(path, 'none', fileformat);     %don't background subtract DIC
        else
            Imstruct=imload(path, bkgd_method, fileformat);
        end

        %record exposure time and check that all images in set have same
        %exposure times
        if isfield(image_set.exp_time,types{i})
            if (image_set.exp_time.(types{i}) ~= Imstruct.exp_time)
                warning('Images in same set have different exposure times')
            end
        else
            image_set.exp_time.(types{i})=Imstruct.exp_time;
        end

        %check that bitdepth agrees with previously set
        if (Imstruct.bitdepth ~= image_set.bitdepth)
            warning('Image bitdepth differs from set bitdepth')
        end

        %check for saturated pixels
        eval([strcat(types{i},'_satpixels'),'=Imstruct.Iraw >= maxval;']);

        %save image
        image_set.image(n).(types{i}) = int16(Imstruct.I);
    end
    %Superimpose CFP and YFP images onto FRET image
    donor_offset=register_images(image_set.image(n).fret, image_set.image(n).donor,[0 0], 2)
    acceptor_offset=register_images(image_set.image(n).fret, image_set.image(n).acceptor,[0 0], 2)
    [fret, donor, acceptor] = overlay_images(image_set.image(n).fret, image_set.image(n).donor, ...
        image_set.image(n).acceptor, donor_offset, acceptor_offset);
    [fret_satpixels, donor_satpixels, acceptor_satpixels] = overlay_images(fret_satpixels, ...
        donor_satpixels, acceptor_satpixels, donor_offset, acceptor_offset);
    image_set.image(n).satpixels=sparse(fret_satpixels | donor_satpixels | acceptor_satpixels);
    image_set.image(n).fret=int16(fret);
    image_set.image(n).donor=int16(donor);
    image_set.image(n).acceptor=int16(acceptor);
    if (isfield(image_set.image(n),'dic'))
        [dic, junk, junk]=overlay_images(image_set.image(n).dic, image_set.image(n).dic, image_set.image(n).dic, donor_offset, acceptor_offset);
        image_set.image(n).dic=int16(dic);
    end
end

function image_set=load_dv_images(imdir,set_name,waves,types,samp_type,exp_type)
%LOAD_SET(SET_NAME, EXP_TYPE, SAMPLE_TYPE, {XTALK}): Loads a FRET data set.
%This program will load all images of the form SETNAME_#_suffix.
%SAMPLE_TYPE is one of 'D' (donor only), 'A' (acceptor only), or 'B' (both)

%right now use hard-coded mapping of left and right channels.

%assume 14-bit bitdepth
options=evalin('base','FRET_OPTIONS');
bitdepth=options.bitdepth;
maxval=(2^bitdepth)-1;

bkgd_method=options.bkgd_method;

image_set.bitdepth=bitdepth;
image_set.exp_type=exp_type;
image_set.bkgd_method='mode';
image_set.sample_type=samp_type;
image_set.exp_time=[];

border=6;   %allow 6 pixel border to take bleedover into account

for n=1:50
    fname=strcat(set_name,'_',sprintf('%d',n),'_',waves{1},'.tif')
    path=fullfile(imdir, fname);
    if (~exist (path))
        break;
    end
    for i=1:max(size(waves))
        if strcmp(types{i},'ignore')
            continue                %skip 'ignore'd images
        end
        fname=strcat(set_name,'_',sprintf('%d',n),'_',waves{i},'.tif');
        path=fullfile(imdir, fname);
        Imstruct=imload(path,'none');

        %check that bitdepth agrees with previously set
        if (Imstruct.bitdepth ~= image_set.bitdepth)
            warning('Image bitdepth differs from set bitdepth')
        end

        boundary=size(Imstruct.Iraw,2)/2;
        switch types{i}
            case 'donor excitation'
                donor=Imstruct.Iraw(:,1:boundary-border);
                d_satpixels=donor >= maxval;
                fret=Imstruct.Iraw(:,boundary+border+1:end);
                f_satpixels=donor >= maxval;
                switch bkgd_method
                    case 'median'
                        donor=donor-median(donor(find(donor<maxval)));
                        fret=fret-median(fret(find(fret<maxval)));
                    case 'regional'
                        donor=donor-imopen(donor,strel('disk',40));
                        fret=fret-imopen(fret,strel('disk',40));
                    case 'mode'
                        a=tabulate(donor(find(donor<maxval)));
                        donor=donor-mean(a(find(a(:,2)==(max(a(:,2)))),1));
                        a=tabulate(fret(find(fret<maxval)));
                        fret=fret-mean(a(find(a(:,2)==(max(a(:,2)))),1));
                end
                %record exposure time and check that all images in set have same
                %exposure times
                if isfield(image_set.exp_time,'donor')
                    if (image_set.exp_time.donor ~= Imstruct.exp_time)
                        warning('Images in same set have different exposure times')
                    end
                else
                    image_set.exp_time.donor = Imstruct.exp_time;
                end
                if isfield(image_set.exp_time,'fret')
                    if (image_set.exp_time.fret ~= Imstruct.exp_time)
                        warning('Images in same set have different exposure times')
                    end
                else
                    image_set.exp_time.fret = Imstruct.exp_time;
                end

            case 'acceptor excitation'
                acceptor=Imstruct.Iraw(:,boundary+border+1:end);
                a_satpixels=acceptor >= maxval;
                switch bkgd_method
                    case 'median'
                        acceptor=acceptor-median(acceptor(find(acceptor<maxval)));
                    case 'regional'
                        acceptor=acceptor-imopen(acceptor,strel('disk',40));
                    case 'mode'
                        a=tabulate(acceptor(find(acceptor<maxval)));
                        acceptor=acceptor-mean(a(find(a(:,2)==(max(a(:,2)))),1));
                end

                %record exposure time and check that all images in set have same
                %exposure times
                if isfield(image_set.exp_time,'acceptor')
                    if (image_set.exp_time.acceptor ~= Imstruct.exp_time)
                        error('Images in same set have different exposure times')
                    end
                else
                    image_set.exp_time.acceptor = Imstruct.exp_time;
                end

            case 'dic'
                dic=Imstruct.Iraw(:,boundary+border+1:end);
                %record exposure time and check that all images in set have same
                %exposure times
                if isfield(image_set.exp_time,'dic')
                    if (image_set.exp_time.dic ~= Imstruct.exp_time)
                        error('Images in same set have different exposure times')
                    end
                else
                    image_set.exp_time.dic = Imstruct.exp_time;
                end
        end
    end
    %Superimpose CFP and YFP images onto FRET image
    switch samp_type
        case 'D'
            donor_offset=register_images(fret,donor,[0 border],2)
            acceptor_offset=register_images(fret,acceptor,[0 0],1)
        case 'A'
            donor_offset=register_images(fret,donor,[0 border],1)
            acceptor_offset=register_images(fret,acceptor,[0 0],2)
        case 'B'
            donor_offset=register_images(fret,donor,[0 border],2)
            acceptor_offset=register_images(fret,acceptor,[0 0],2)
    end
    [fret, donor, acceptor] = overlay_images(fret, donor, acceptor, donor_offset, acceptor_offset);
    %transform saturated pixel images appropriately
    [f_satpixels, d_satpixels, a_satpixels] = overlay_images(f_satpixels, d_satpixels, a_satpixels, donor_offset, acceptor_offset);
    image_set.image(n).satpixels=sparse(f_satpixels | d_satpixels | a_satpixels);
    image_set.image(n).fret=int16(fret);
    image_set.image(n).donor=int16(donor);
    image_set.image(n).acceptor=int16(acceptor);
    [dic, junk, junk]=overlay_images(dic, dic, dic, donor_offset, acceptor_offset);
    image_set.image(n).dic=int16(dic);
end