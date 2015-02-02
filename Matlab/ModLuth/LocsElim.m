function varargout = LocsElim(varargin)
% LOCSELIM M-file for LocsElim.fig
%      LOCSELIM, by itself, creates a new LOCSELIM or raises the existing
%      singleton*.
%
%      H = LOCSELIM returns the handle to a new LOCSELIM or the handle to
%      the existing singleton*.
%
%      LOCSELIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCSELIM.M with the given input arguments.
%
%      LOCSELIM('Property','Value',...) creates a new LOCSELIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LocsElim_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LocsElim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help LocsElim

% Last Modified by GUIDE v2.5 12-Sep-2007 15:04:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LocsElim_OpeningFcn, ...
                   'gui_OutputFcn',  @LocsElim_OutputFcn, ...
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


% --- Executes just before LocsElim is made visible.
function LocsElim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LocsElim (see VARARGIN)

% Choose default command line output for LocsElim

handles.output = hObject;
global iniMatrix; 
global loc;
global rouge; global noir;

col_lat = 5;
col_lon = 6;
col_flag = 9;
[latLim, lonLim] = getLim(iniMatrix, col_lat,col_lon);
[BATHY.data,BATHY.lat,BATHY.lon] = extract_1m([latLim(1), latLim(2),lonLim(1), lonLim(2)],1);
coast = (BATHY.data > 0);
axes(handles.axes_map);
axis equal;
imcontour(BATHY.lon, BATHY.lat,coast,1, 'Color', [0.2 0.2 0.2]);
axis xy;


%ajouter tous les valeurs
line (iniMatrix(:, col_lon), iniMatrix(:,col_lat), 'Marker', '+',...
	 'Color', [0.5 0.5 0.5]);

%les valeurs de terre à éliminer
elim = iniMatrix(find(iniMatrix(:,col_flag)==6),col_lat:col_lon);
                 
%%%%%%%%%%%%
%Ajouter les locs 

% lon - lat
loc = [];
loc(:,1) = elim(:,2);
loc(:,2) = elim(:,1);
loc(:,3) = 'x';

guidata(hObject, handles);
update_list (handles);     
update_graph (handles);
uiwait(handles.figure1);


% UIWAIT makes LocsElim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LocsElim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% global iniMatrix;
% varargout{1} = iniMatrix;
% uiresume(handles.figure1);
% close;

% --- Executes on selection change in list_locs.
function list_locs_Callback(hObject, eventdata, handles)
% hObject    handle to list_locs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_locs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_locs

update_graph (handles);
return;



% --- Executes during object creation, after setting all properties.
function list_locs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_locs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in btn_keep.
function btn_keep_Callback(hObject, eventdata, handles)
% hObject    handle to btn_keep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global loc;
locstr = get(handles.list_locs, 'String');
val = get(handles.list_locs, 'Value');

str = char(locstr(val));
[clon, str] = strtok(str, ' ');
clat = strtok(str, ' ');

clon = str2num(clon);
clat = str2num(clat);
 
ind = find(loc(:,1)== clon & loc(:,2)== clat);
loc(ind,3) = ' ';

update_graph (handles)
update_list (handles);

% --- Executes on button press in btn_elimin.
function btn_elimin_Callback(hObject, eventdata, handles)
% hObject    handle to btn_elimin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global loc;
locstr = get(handles.list_locs, 'String');
val = get(handles.list_locs, 'Value');

str = char(locstr(val));
[clon, str] = strtok(str, ' ');
clat = strtok(str, ' ');

clon = str2num(clon);
clat = str2num(clat);
 
ind = find(loc(:,1)== clon & loc(:,2)== clat);
loc(ind,3) = 'x';

update_graph (handles)
update_list (handles);


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);
close;

% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global iniMatrix;
global loc;

col_lat = 5;
col_lon = 6;

keep = loc(find(loc(:,3)~='x'),1:2);

for (i=1:size(keep,1));
    ind  = find( iniMatrix(:,col_lon) == keep(i,1) & ...
                 iniMatrix(:,col_lat) == keep(i,2));
    iniMatrix( ind,9) = 0;
end

uiresume(handles.figure1);
close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_graph (handles)
global loc;
global rouge; global vert; global noir;


locstr = get(handles.list_locs, 'String');
val = get(handles.list_locs, 'Value');

axes(handles.axes_map);

% effacer les graphs
if exist('rouge'); 
    try; if (~isempty(rouge)); delete(rouge); end;catch;end
end
if exist('vert'); 
    try;if (~isempty(vert)); delete(vert); end;;catch;end
 end
if exist('noir');  
    try;if (~isempty(noir)); delete(noir); end;catch;end
end;

% les éliminés
tmp = loc(find(loc(:,3)=='x'), 1:2);
if (~isempty(tmp))
    rouge =  line (tmp(:, 1), tmp(:,2), 'Marker', 'o',...
			'LineStyle', 'none', 'Color', [1 0 0], ...
            'MarkerFaceColor', [1 0 0]);
end       
            
% les conservés
tmp = loc(find(loc(:,3)~='x'), 1:2);
if (~isempty(tmp))
    vert = line (tmp(:, 1), tmp(:,2), 'Marker', 'o',...
			'LineStyle', 'none', 'Color', [0.4 0.9 0.4],...
            'MarkerFaceColor', [0 1 0]);
end

% le courant
tmp = loc(val, 1:2);
    noir = line (tmp(:, 1), tmp(:,2), 'Marker', '*','MarkerSize', 12,...
			'LineStyle', 'none', 'Color', [0 0 0]);   
return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_list (handles)
global loc;
 for i=1:size(loc, 1)
     loc_str{i,1} = sprintf('%3.3f    %3.3f    %s', ...
        loc(i,1), loc(i,2), char(loc(i,3)));
 end
 
set(handles.list_locs, 'String', loc_str);

