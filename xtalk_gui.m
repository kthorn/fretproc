function varargout = xtalk_gui(varargin)
% XTALK_GUI M-file for xtalk_gui.fig
%      XTALK_GUI, by itself, creates a new XTALK_GUI or raises the existing
%      singleton*.
%
%      H = XTALK_GUI returns the handle to a new XTALK_GUI or the handle to
%      the existing singleton*.
%
%      XTALK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XTALK_GUI.M with the given input arguments.
%
%      XTALK_GUI('Property','Value',...) creates a new XTALK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xtalk_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xtalk_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xtalk_gui

% Last Modified by GUIDE v2.5 25-Jan-2004 21:56:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @xtalk_gui_OpeningFcn, ...
    'gui_OutputFcn',  @xtalk_gui_OutputFcn, ...
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


% --- Executes just before xtalk_gui is made visible.
function xtalk_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xtalk_gui (see VARARGIN)

% Choose default command line output for xtalk_gui
handles.output = hObject;

%xtalk_gui should get called with a cell array of the names of datasets to
%analyze (to be read from the workspace).  First we need to save this list.
%SHOULD DO SANITY CHECKS ON LIST PROVIDED: NO SETS OF TYPE "B", ALL SETS OF
%SAME EXP_TYPE
handles.setnames=varargin{1};
handles.total_sets=max(size(handles.setnames));
handles=initialize_set(handles,1);
set(handles.mask_list,'Value',1)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xtalk_gui wait for user response (see UIRESUME)
 uiwait(handles.xtalk_gui);


% --- Outputs from this function are returned to the command line.
function varargout = xtalk_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in mean_button.
function mean_button_Callback(hObject, eventdata, handles)
% hObject    handle to mean_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mean_button
mutual_exclude(handles.all_button);
guidata(hObject, handles);

% --- Executes on button press in all_button.
function all_button_Callback(hObject, eventdata, handles)
% hObject    handle to all_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_button
mutual_exclude(handles.mean_button);
guidata(hObject, handles);
uiwait;

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

set_idx=handles.setnum;
setnames=handles.setnames;
if (get(handles.all_button,'Value') == get(handles.all_button,'Max'))
    method = 'lsq';
elseif (get(handles.mean_button,'Value') == get(handles.mean_button,'Max'))
    method = 'mean';
else
    errordlg('You must choose a Fit mode before you can proceed')
    return;
end
if (set_idx == -2) %done, return xtalk
    disp('Exiting xtalk_gui')
    handles.output=handles.xtalk_struct;
    guidata(hObject, handles);
    uiresume
    uiresume
    
elseif (set_idx == -1) %do overall fit
    %calculate joint fit of all data
    xtalk_struct.method=method;
    xtalk_struct.source=setnames;
    [F, D, A]=raw_data_cum(handles.raw_data,'D');
    if ~isempty(F)
        disp ('Calculating joint donor fit')
        switch method
            case 'lsq'
                result=lsq_fit(double(D),double(F),'joint donor fit','Donor',handles);
            case 'mean'
                result=mean_fit(double(D),double(F),'joint donor fit','Donor',handles);
        end
        handles.xtalk_struct.D_fit=result; 
    end
    [F, D, A]=raw_data_cum(handles.raw_data,'A');
    if ~isempty(F)
        disp ('Calculating joint acceptor fit')
        switch method
            case 'lsq'
                result=lsq_fit(double(A),double(F),'joint acceptor fit','Acceptor',handles);
            case 'mean'
                result=mean_fit(double(A),double(F),'joint acceptor fit','Acceptor',handles);
        end
        handles.xtalk_struct.A_fit=result; 
    end
    clear F D A 
    
    %CHECK IF BOTH DONOR AND ACCEPTOR SETS ARE PRESENT
    samples=[handles.raw_data.sample_type];
    if (max(samples=='A') & max(samples=='D'))
        disp ('Calculating overall fit for all data')
        %calculate overall fit
        [Fd, Dd, Ad]=raw_data_cum(handles.raw_data,'D');
        [Fa, Da, Aa]=raw_data_cum(handles.raw_data,'A');
        switch method
            case 'lsq'
                result=lsq_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
                handles.xtalk_struct.fit=result;        %joint fit result
            case 'mean'
                result=mean_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
                handles.xtalk_struct.fit=result;        %joint fit result
        end
        figure('Name','Overall fit')
        subplot(4,1,1)
        Fd_calc=result(1)*Dd + result(2)*Ad + result(3);
        plot(Dd,Fd,'.b',Dd,Fd_calc,'.r')
        xlabel('Donor intensity')
        ylabel('FRET intensity')
        subplot(4,1,2)
        plot(Dd,Fd-Fd_calc,'.')
        title('residuals')
        subplot(4,1,3)
        Fa_calc=result(1)*Da + result(2)*Aa + result(3);
        plot(Aa,Fa,'.b',Aa,Fa_calc,'.r')
        xlabel('Acceptor intensity')
        ylabel('FRET intensity')
        subplot(4,1,4)
        plot(Aa,Fa-Fa_calc,'.')
        title('residuals')
        Aresid=double(Fa)-double(Da)*result(1)-double(Aa)*result(2) - result(3);
        Dresid=double(Fd)-double(Dd)*result(1)-double(Ad)*result(2) - result(3);
        meanD=mean(Dresid)
        meanA=mean(Aresid)
    end
else
    curr_set=evalin('base',handles.setnames{handles.setnum});         %pass in structure from base workspace
    maxval=(2^curr_set.bitdepth)-1;
    
    
    masknum=get(handles.mask_list,'Value');
    maskstring=get(handles.mask_list,'String');
    mask_name=maskstring{masknum};
    
    %cumulate data
    cum_data=set_cum(curr_set,mask_name);
    handles.raw_data(set_idx).name=setnames{set_idx};
    handles.raw_data(set_idx).exp_type=curr_set.exp_type;
    handles.raw_data(set_idx).sample_type=curr_set.sample_type;
    handles.raw_data(set_idx).F=int16(cum_data.F);
    handles.raw_data(set_idx).D=int16(cum_data.D);
    handles.raw_data(set_idx).A=int16(cum_data.A);
    
    handles.raw_data(set_idx).fit_type=method;
    sample_type=curr_set.sample_type;
    disp (['fitting ', setnames{set_idx}])
    Y=handles.raw_data(set_idx).F;
    X=handles.raw_data(set_idx).(sample_type);
    switch sample_type
        case 'D'
            xaxis_title='Donor';
        case 'A'
            xaxis_title='Acceptor';
    end
    switch method
        case 'lsq'
            result=lsq_fit(double(X),double(Y),setnames{set_idx},xaxis_title,handles);
            handles.raw_data(set_idx).params=result;
        case 'mean'
            result=mean_fit(double(X),double(Y),setnames{set_idx},xaxis_title,handles);
            handles.raw_data(set_idx).params=result;
    end
    set(handles.result_text,'String',['Slope: ', num2str(result(1),'%8.3g'), ' Intercept: ', num2str(result(2),'%8.3g')]);
end
if (set_idx == handles.total_sets)
    handles=initialize_set(handles,-1);     %do overall fit
elseif (set_idx == -1)          %overall fit complete
    handles=initialize_set(handles,-2);
elseif (set_idx == -2) %figure deleted
    %do nothing
else
    handles=initialize_set(handles,set_idx+1);
end
% Update handles structure
guidata(hObject, handles);

%---------------------------
%end of callbacks
%---------------------------

function mutual_exclude(off)
set(off,'Value',0)
return

function handles=initialize_set(handles,setnum)
if (setnum == -1)   %time to do overall fit
    set(handles.go_button,'String','Overall fit');
    handles.setnum=setnum;
elseif (setnum == -2) %overall fit complete
    set(handles.go_button,'String','Exit');
    handles.setnum=setnum;
else
    %set up gui with parameters from handles.setnames{setnum}.
    handles.setnum=setnum;
    setname=handles.setnames{setnum};
    if (evalin('base',['isfield(',setname,',''maskname'')']))
        masknames=evalin('base',[setname,'.maskname']);
        masknames{size(masknames,2)+1}='None';
    else
        masknames={'None'};
    end
    set(handles.mask_list,'String',masknames);
    set(handles.go_button,'String',['Fit ',setname]);
end

function cum_data=set_cum(set,mask_name)
options=evalin('base','FRET_OPTIONS');
threshold_frac=options.threshold_frac;           %fraction of max intensity to keep for calculation
threshold_const=options.threshold_const;         %minimum intensity to keep for calculation
for n=1:size(set.image,2)                        %loop over all images
    D=double(set.image(n).donor);
    A=double(set.image(n).acceptor);
    F=double(set.image(n).fret);
    if (strcmpi(mask_name,'None'))
        mask = ones(size(F));
    else
        masknum=find(strcmpi(mask_name,set.maskname));
        mask=full(set.image(n).mask(masknum).mask);
    end
    %eliminate saturated pixels
    mask=mask & ~set.image(n).satpixels;
    
    [i]=find(mask);
    if ~exist('Fcum') | isempty(Fcum)
        Fcum=F(i);
        Acum=A(i);
        Dcum=D(i);
    else
        Fcum=cat(1,Fcum,F(i));
        Acum=cat(1,Acum,A(i));
        Dcum=cat(1,Dcum,D(i));
    end 
end

%CONSIDER ELIMINATING THESE ADDITIONAL THRESHOLDS
switch set.sample_type
    case 'A'
        thresh=max(threshold_const,threshold_frac*max(A(:)));
        i=find(Acum>thresh);
    case 'D'
        thresh = max(threshold_const,threshold_frac*max(D(:)));
        i=find(Dcum>thresh);
    case 'B'
        error('You should not try to calculate crosstalk parameters from a sample with both fluors')
end

AF=set.autofluor;
cum_data.F=Fcum(i)-AF(3);
cum_data.A=Acum(i)-AF(2);
cum_data.D=Dcum(i)-AF(1);
%-------------------------------------------------------  
function result = lsq_fit(X,Y,plot_title,xaxis_title,handles)
param0=[0.2 50];
[fresult,resid,J]= nlinfit(X,Y,@lsq2d_n,param0);
fresult
ci = nlparci(fresult,resid,J,.317)
%see how our fit looks
linex=(0:10)*max(X)/10;
liney=fresult(1)*linex+fresult(2);
axes(handles.axes1)
plot(X,Y,'.b',linex,liney,'-r')
title(plot_title)
ylabel('FRET')
xlabel(xaxis_title)
axes(handles.axes2)
plot(X,resid,'.')
title('residuals')
drawnow
result=fresult;

%-------------------------------------------------------  
function result = mean_fit(X,Y,plot_title,xaxis_title,handles)
a=1;
for n=min(X):max(X)
    pix=find(X==n);
    if isempty(pix)
        continue
    end
    Xbin(a)=n;
    Ybin(a)=mean(Y(pix));
    Yerr(a)=std(Y(pix));
    a=a+1;
end
badpix=(find(Yerr==0));
mean_Yerr=mean(Yerr(find(Yerr~=0)));
Yerr(badpix)=mean_Yerr;
N=max(size(Ybin));
d=([Xbin',Ybin',zeros(size(Xbin')),Yerr']);
param0=[0.2 50];
[fresult,fval]= fminsearch(@lsq2d,param0,[],d)
Q=gammainc((N-3)/2,fval/2)

%see how our fit looks
axes(handles.axes1);
resid=Y-X*fresult(1) - fresult(2);
linex=(0:10)*max(Xbin)/10;
liney=fresult(1)*linex+fresult(2);
axes(handles.axes1)
hold off
plot(X,Y,'.b',linex,liney,'-r')
hold on
errorbar(Xbin,Ybin,Yerr,'-g')
title(plot_title)
ylabel('FRET')
xlabel(xaxis_title)
axes(handles.axes2)
plot(X,resid,'.')
title('residuals')
drawnow
result=fresult;
%----------------------------------------------------------
function  result=mean_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
a=1;
%calculate mean for donor channel
for n=min(Dd):max(Dd)
    pix=find(Dd==n);
    if isempty(pix)
        continue
    end
    Ddbin(a)=n;
    Fdbin(a)=mean(Fd(pix));
    Fderr(a)=std(Fd(pix));
    Adbin(a)=mean(Ad(pix));
    Aderr(a)=std(Ad(pix));
    a=a+1;
end
%Noise is dominated by factors other than shot noise and is roughly
%constant
badpix=(find(Fderr==0));
mean_Fderr=mean(Fderr(find(Fderr~=0)));
Fderr(badpix)=mean_Fderr;
badpix=(find(Aderr==0));
mean_Aderr=mean(Aderr(find(Aderr~=0)));
Aderr(badpix)=mean_Aderr;
%set Dderr to all ones
Dderr=ones(size(Ddbin));

a=1;
%calculate mean for acceptor channel
for n=min(Aa):max(Aa)
    pix=find(Aa==n);
    if isempty(pix)
        continue
    end
    Aabin(a)=n;
    Fabin(a)=mean(Fa(pix));
    Faerr(a)=std(Fa(pix));
    Dabin(a)=mean(Da(pix));
    Daerr(a)=std(Da(pix));
    a=a+1;
end
%Noise is dominated by factors other than shot noise and is roughly
%constant
badpix=(find(Faerr==0));
mean_Faerr=mean(Faerr(find(Faerr ~= 0)))
Faerr(badpix)=mean_Faerr;

badpix=(find(Dderr==0));
mean_Dderr=mean(Dderr(find(Dderr ~= 0)))
Dderr(badpix)=mean_Dderr;

Aaerr=ones(size(Aabin));
D=[Ddbin,Dabin]';
A=[Adbin,Aabin]';
F=[Fdbin,Fabin]';
N=max(size(F));
Derr=[Dderr,Daerr]';
Aerr=[Aderr,Aaerr]';
Ferr=[Fderr,Faerr]';
d=([D,A,F,Derr,Aerr,Ferr]);
param0=[0.2 0.2 50];
[result,fval]= fminsearch(@lsq3d,param0,[],d);
Q=gammainc((N-3)/2,fval/2)

%-----------------------------------------------------------------
function  result=lsq_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
D=[Dd;Da];
A=[Ad;Aa];
F=[Fd;Fa];

d=([D,A]);
param0=[0.2 0.2 50];
[result, resid, J]= nlinfit(d,F,@lsq3d_n,param0);
result
ci = nlparci(result,resid,J,.317)
%-------------------------------------------------------
function [F, D, A] = raw_data_cum(raw_data,sample_type)
for n=1:size(raw_data,2)     
    if ~strcmpi(sample_type,raw_data(n).sample_type)     %check if we have right sample type
        continue
    end
    if ~exist('exp_type')
        exp_type=raw_data(n).exp_type;
    elseif ~strcmpi(exp_type,raw_data(n).exp_type)
        warning(['Mismatched experiments in raw_data_cum.  Skipping ', raw_data(n).name])
        continue
    end
    
    if ~exist('F') | isempty(F)
        F=raw_data(n).F;
        D=raw_data(n).D;
        A=raw_data(n).A;
    else
        F=cat(1,F,raw_data(n).F);
        D=cat(1,D,raw_data(n).D);
        A=cat(1,A,raw_data(n).A);
    end 
end

%make sure we return something
if ~exist('F')
    F=[];
    D=[];
    A=[];
end
F=double(F);
D=double(D);
A=double(A);