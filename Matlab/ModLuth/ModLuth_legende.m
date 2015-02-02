function varargout = ModLuth_legende(varargin)
% MODLUTH_LEGENDE M-file for ModLuth_legende.fig
%      MODLUTH_LEGENDE, by itself, creates a new MODLUTH_LEGENDE or raises the existing
%      singleton*.
%
%      H = MODLUTH_LEGENDE returns the handle to a new MODLUTH_LEGENDE or the handle to
%      the existing singleton*.
%
%      MODLUTH_LEGENDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODLUTH_LEGENDE.M with the given input arguments.
%
%      MODLUTH_LEGENDE('Property','Value',...) creates a new MODLUTH_LEGENDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModLuth_legende_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModLuth_legende_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ModLuth_legende

% Last Modified by GUIDE v2.5 15-Dec-2006 10:12:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModLuth_legende_OpeningFcn, ...
                   'gui_OutputFcn',  @ModLuth_legende_OutputFcn, ...
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


% --- Executes just before ModLuth_legende is made visible.
function ModLuth_legende_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModLuth_legende (see VARARGIN)

% Choose default command line output for ModLuth_legende
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModLuth_legende wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModLuth_legende_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_quit.
function btn_quit_Callback(hObject, eventdata, handles)
% hObject    handle to btn_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

