function varargout = ModLuth(varargin)
% MODLUTH M-file for ModLuth.fig
%      MODLUTH, by itself, creates a new MODLUTH or raises the existing
%      singleton*.
%
%      H = MODLUTH returns the handle to a new MODLUTH or the handle to
%      the existing singleton*.
%
%      MODLUTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODLUTH.M with the given input arguments.
%
%      MODLUTH('Property','Value',...) creates a new MODLUTH or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before ModLuth_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to ModLuth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ModLuth

% Last Modified by GUIDE v2.5 01-Sep-2009 09:46:32



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModLuth_OpeningFcn, ...
                   'gui_OutputFcn',  @ModLuth_OutputFcn, ...
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





% --- Executes just before ModLuth is made visible.
function ModLuth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModLuth (see VARARGIN)

% Choose default command line output for ModLuth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.fig_trace, 'visible', 'on'); 
%worldmap('World');
load coast; 
plot (long, lat, 'color', [0.1 0.1 0.1]);

% update
set(handles.str_GenInfo, 'String', ' ');


addpath('..\Utilities');
addpath('..\RWFormats');
addpath('..\Epanechnikov');
addpath('..\Kalman');


%read settings
readSettings (handles);

% UIWAIT makes ModLuth wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModLuth_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function str_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function str_input_Callback(hObject, eventdata, handles)
% hObject    handle to str_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_input as text
%        str2double(get(hObject,'String')) returns contents of str_input as a double




% --- Executes on button press in btn_DiagFile.
function btn_DiagFile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_DiagFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

previousValue = char(get(handles.str_input, 'String'));

start_file = char(get(handles.str_input, 'String'));
if exist(start_file,'dir')
    if start_file(end) ~= '\'; start_file(end+1)='\'; end
end
[pathstr,name] = fileparts(start_file);
[fileName, pathName] = uigetfile ([strcat(pathstr, '\')  '*.*']);

if isequal(fileName,0)
    set(handles.str_input, 'String', previousValue);
else
    totalName = strcat(pathName, fileName);
    set(handles.str_input, 'String', totalName);
end


function str_OutDir_Callback(hObject, eventdata, handles)
% hObject    handle to str_OutDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_OutDir as text
%        str2double(get(hObject,'String')) returns contents of str_OutDir as a double




% --- Executes during object creation, after setting all properties.
function str_OutDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_OutDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in btn_Execution.
function btn_Execution_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Execution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%	set(handles.str_sufixe, 'String', '');

	% Vérifier que les fichiers existent
    fileInput = char(get(handles.str_input, 'String'));
    fileParam = char (get(handles.str_ParamFile, 'String'));

    if ( ~exist(fileInput,'file') || exist(fileInput,'file') == 7)
       msg = strcat('The input file "', fileInput , '" doesn''t exist');
       errordlg(msg,'erreur');
       set(handles.btn_Execution, 'Enable', 'on');
       return
    end


    global iniMatrix
    global locMatrix
    global resMatrix;
    global resVitesseMatrix;
	global balise;
	global reference;
	global sufixe;
	global seuil_km;
	global premierLoc;
	global dernierLoc;

    iniMatrix = [];
    refMatrix = [];
    resMatrix = [];

    jour2sec = 24*60*60;

    % Faire le traitement


    % lire les données selon le format
    val = get(handles.listInputFormat, 'Value');
	liste = get(handles.listInputFormat, 'String');
	format = liste(val);
	
	execstr = strcat('[res, balise, reference, iniMatrix] = read',format,'(fileInput);');
	
    try
		eval (char(execstr));
		if (res == false)
			inError ('Impossible to read the diag file. Please, verify the format', handles);
           % problèmes dans la lecture du fichier en format diag. Vérifiez
           % le format', handles);
			return
		end
    catch
      %  inError ('Problèmes dans lecture des données d''entrée', handles);
        inError ('Impossible to read the input data', handles);
        return;
    end

    if ~isempty( char(get(handles.str_reference, 'String')))
        reference = char(get(handles.str_reference, 'String'));
    end
  
    
    if isempty(iniMatrix)
        %inError('Matrice initialle vide', handles);
        inError('Initial matrix empty', handles);
        return;
	end 

    iniMatrix = cleanData (iniMatrix); 
			
	% organiser d'abord par jour julien (colonne 1) suivi du nombre
	% secondes (colonne 2)
    iniMatrix = sortrows(iniMatrix,[1 2]);
	
	datePremierLoc = iniMatrix(1,1);
	dateDernierLoc = iniMatrix(end,1);
	
	str_JJ= get(handles.str_PremierJour, 'String');
	if isempty(str_JJ)
		premierJJ =  iniMatrix(1,1);
	else
		premierJJ = conv_jourgreg2jourjul(str_JJ);
		premierJJ = max(premierJJ , iniMatrix(1,1));
		if (premierJJ >iniMatrix(end,1))
		%	msgbox('Error dans la date de début de traitement');
            msgbox('Error in the first jour of processing');
			return;
		end
	end
		
	str_JJ= get(handles.str_DernierJour, 'String');
	if isempty(str_JJ)
		dernierJJ =  iniMatrix(end,1);
	else
		dernierJJ = conv_jourgreg2jourjul(str_JJ);
		dernierJJ = min(dernierJJ, iniMatrix(end,1));
		if (dernierJJ<iniMatrix(1,1))
            msgbox('Error in the last jour of processing');
			return;
		end
    end
	
   
	% Enlever les localisations qui ne sont pas dans le range
	iniMatrix = iniMatrix(find(iniMatrix(:,1)>= premierJJ), :);
	iniMatrix = iniMatrix(find(iniMatrix(:,1)<= dernierJJ), :);
	
	
	
	% ajouter une colonne à la matrice initiale pour indiquer les raisons
	% de l'élimination du point (flag)

    col_flag = 9;
	iniMatrix(:,col_flag) = 0;
	
	
	iniMatrix(find(iniMatrix(:,3) == -9), col_flag) = 1;  % flag pour classe loc Z
	iniMatrix = detecter_doublons(iniMatrix); % flag (2) pour doublon
	
    

    
    
	% correction de localisation
    iniMatrix = correction_mat_choix_loc(iniMatrix);

	if (get(handles.ckb_ElimTerre, 'Value') == true)
		iniMatrix = elimination_terre (iniMatrix);
        if (~isempty(find(iniMatrix(:,col_flag)==6)))
           % iniMatrix = LocsElim(iniMatrix);
           LocsElim;
        end
    end


    % il faut le faire après l'élimination de points sur terre
	fLat = str2num(get(handles.str_FirstLat, 'String'));
    fLon = str2num(get(handles.str_FirstLon, 'String'));
    
    if (~isempty(fLat) && ~isempty(fLon))
        newline = [iniMatrix(1,1), 0,3,0,fLat, fLon, fLat, fLon, 0];
        iniMatrix = [ newline;iniMatrix];
    elseif (~isempty(fLat) || ~isempty(fLon))
        msgbox('Lat or Lot empty');
        return;
    end
    
	% correction de vitesse
	% flag = 3 pour les points éliminés
	vit_max_tort = getParamValue2 (fileParam, 'lovi/vitesse_max', '2.8');
	% passer à centimètres
	vit_max_tort = str2num(vit_max_tort) *100;
    iniMatrix = elimination_mat_vitesse_excessive(iniMatrix,vit_max_tort);
	
	locMatrix = iniMatrix(find(iniMatrix(:,col_flag) == 0), :);	
    
    if (size(locMatrix,1) <2)
        msgbox ('Not enough valid data in the matrix'); 
        return
    end
    val = get(handles.listTraitement,'Value');

    pacific = get(handles.ckb_pacific, 'Value');
    if pacific==true
        ind = find(iniMatrix(:,6)<0);
        iniMatrix(ind,6) = iniMatrix(ind,6) +360;
        clear ind
        ind = find (locMatrix(:,6)<0);
        locMatrix(ind,6)=locMatrix(ind,6)+360;
    end
    
    try
        switch (val)              
            case 1
                resMatrix(:,1) = locMatrix(:,1)*jour2sec + locMatrix(:,2);
				resMatrix(:,2) = 0; % On ne "bouche pas de trous";
				resMatrix(:,3) = locMatrix(:,6);% longitude
				resMatrix(:,4) = locMatrix(:,5); % latitude
				sufixe = '_lovi';
                
			case 2 
				
				resMatrix(:,1) = locMatrix(:,1)+ locMatrix(:,2)/(24*60*60);
				resMatrix(:,2) = 0; % On ne "bouche pas de trous";
				resMatrix(:,3) = locMatrix(:,6);% longitude
				resMatrix(:,4) = locMatrix(:,5); % latitude
				[pas_redisc res] = getParamValue2 (fileParam, 'redi/pas_redisc', '10800'); % 3 heures
				if (res == false); return; end;
				
				resMatrix = redisc(resMatrix,str2num(pas_redisc));
				resMatrix(:,1) = floor(resMatrix(:,1))*(24*60*60) + ...
								(resMatrix(:,1) - floor(resMatrix(:,1)))*24*60*60;
				sufixe = '_redi';
				
				
            case 3
				
				[iniMatrix, outMatrix, seuil_km, res] = lissage(iniMatrix, fileParam);  
				if (res == false); return; end;
				resMatrix(:,1) = outMatrix(:,1); 
				resMatrix(:,2) = outMatrix(:,4); % flag a voir
				resMatrix(:,3) = outMatrix (:,3); %longitude
				resMatrix(:,4) = outMatrix(:,2); % latitude
				sufixe = '_epan';
			case 4
				% Lecture et définition de paramètres
				[LocAcc res] = getParamValue2(fileParam, 'kalm/locAccuracy', '[1,0.7,0.2,1.5,0.5,0.2,0.1]');
				if (res == false); return; end;
				eval (strcat ('params.LocAccuracy = ', char(LocAcc), ';'));
				% Time step
				[TimeStep res] = getParamValue2(fileParam, 'kalm/TimeStep', '7');
				if (res == false); return; end;
				params.TimeStep = str2num(TimeStep);
				% D
				[D res] = getParamValue2(fileParam, 'kalm/D', '500');
				if (res == false); return; end;
				params.D = str2num(D);
				% rho
				[rho res] = getParamValue2(fileParam, 'kalm/rho', '100');
				if (res == false); return; end; 
				params.rho = str2num(rho);
				%p0
				[p0 res] = getParamValue2(fileParam, 'kalm/p0', '0.9');
				if (res == false); return; end;
				params.p0 = str2num(p0);
						
				params.H=eye(2,2);		% Shape of state2obs matrix
				params.Q=zeros(2,2);  % Process variance matrix
				params.Q(1,1)=2*params.D;
				params.Q(2,2)=2*params.D;
				params.F=eye(2,2);		% Propagation matrix

				Initday=datestr(datenum(jourjul2jourgreg(iniMatrix(1,1)),'dd.mm.yyyy'),1);
				Lastday=datestr(datenum(jourjul2jourgreg(iniMatrix(end,1)),'dd.mm.yyyy'),1);
				[TI,timestep] = MakeTI([Initday,',00:00'],[Lastday,',00:00'],0,params.TimeStep,0,0);
					
				subdata = ini2francois (locMatrix);
				fit=GSF_2D(subdata,TI,params);
				resMatrix = fit.res; 
				sufixe = '_KFRW';
			case 5
				% Lecture et définition de paramètres
				[LocAcc res] = getParamValue2(fileParam, 'kalm/locAccuracy', '[1,0.7,0.2,1.5,0.5,0.2,0.1]');
				if (res == false); return; end;
				eval (strcat ('params.LocAccuracy = ', char(LocAcc), ';'));
				% Time step
				[TimeStep res] = getParamValue2(fileParam, 'kalm/TimeStep', '7');
				if (res == false); return; end;
				params.TimeStep = str2num(TimeStep);
				% D
				[D res] = getParamValue2(fileParam, 'kalm/D', '500');
				if (res == false); return; end;
				params.D = str2num(D);
				% rho
				[rho res] = getParamValue2(fileParam, 'kalm/rho', '100');
				if (res == false); return; end; 
				params.rho = str2num(rho);
				%p0
				[p0 res] = getParamValue2(fileParam, 'kalm/p0', '0.9');
				if (res == false); return; end;
				params.p0 = str2num(p0);
						
				params.H=eye(2,4);		% Shape of state2obs matrix
				params.Q=zeros(4,4);  % Process variance matrix
				params.Q(3,3)=2*params.D;
				params.Q(4,4)=2*params.D;
				params.F=eye(4,4);params.F(1,3)=1; params.F(2,4)=1;		% Propagation matrix

				Initday=datestr(datenum(jourjul2jourgreg(iniMatrix(1,1)),'dd.mm.yyyy'),1);
				Lastday=datestr(datenum(jourjul2jourgreg(iniMatrix(end,1)),'dd.mm.yyyy'),1);
				[TI,timestep] = MakeTI([Initday,',00:00'],[Lastday,',00:00'],0,params.TimeStep,0,0);
					
				subdata = ini2francois (locMatrix);
				fit=GSF_2D(subdata,TI,params);
				resMatrix = fit.res; 
				sufixe = '_KFCR';
				
			case 6 % Kalman simplifié
				
				[loc_err res] = getParamValue2(fileParam, 'ksim/loc_err', '[NaN,700,200,1500,500,200,100]');
				if (res == false); return; end;
				eval (strcat ('params.loc_err = ', char(loc_err), ';'));
				params.lat_ini = getParamValue2(fileParam, 'ksim/lat_ini', '-18');
				params.lon_ini = getParamValue2(fileParam, 'ksim/lon_ini', '-65');
				params.moy_alpha_ini = getParamValue2(fileParam, 'ksim/moy_alpha_ini', '75');
				params.ecarttype_alpha_ini = getParamValue2(fileParam, 'ksim/ecarttype_alpha_ini', '30');
				params.moy_vit_ini = getParamValue2(fileParam, 'ksim/moy_vit_ini', '0.7');
				params.ecarttype_v_ini = getParamValue2(fileParam, 'ksim/ecarttype_v_ini', '0.03');
				subdata = ini2francois (locMatrix);
				resMatrix = FiltreK(subdata, params);
				sufixe = '_KSIM';
        end
	catch
		disp(lasterr);
        inError('Processing Problems', handles);
        return;
	end

    if isempty(resMatrix)
        %inError('Matrice de résultats vide', handles);
        inError('Result matrix empty', handles);
        return;
    end 

    %calcul des matrices de vitesse
    [res, resVitesseMatrix] = calc_vitesse(resMatrix(:,1), resMatrix(:,4), resMatrix(:,3));
	resMatrix(:,5:8) = resVitesseMatrix (:, 1:4);
	 
	% Plot
	plot_ModLuth_Traj (handles, iniMatrix, locMatrix, resMatrix);
	
	% visualisation des statistiques
	global file_name;
	[pathstr,file_name,file_ext ] = fileparts(get(handles.str_input, 'String'));
	
	getStats(file_name, file_ext, balise, reference, seuil_km, iniMatrix,...
		     resMatrix, datePremierLoc, dateDernierLoc, handles);
		 
    msgbox ('Processing OK');   

    set(handles.btn_Execution, 'Enable', 'on');
    


function str_ParamFile_Callback(hObject, eventdata, handles)
% hObject    handle to str_ParamFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_ParamFile as text
%        str2double(get(hObject,'String')) returns contents of str_ParamFile as a double


% --- Executes during object creation, after setting all properties.
function str_ParamFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_ParamFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in btn_ParamFile.
function btn_ParamFile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_ParamFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

previousValue = char(get(handles.str_ParamFile, 'String'));
start_file = char(get(handles.str_ParamFile, 'String'));

if (exist(start_file, 'dir')) % si c'est un répertoire
	pathstr= start_file;
else
	[pathstr,name] = fileparts(start_file);
end
	
[fileName, pathName] = uigetfile ([pathstr,  '\*.*']);

if isequal(fileName,0)
    set(handles.str_ParamFile, 'String', previousValue);
else
    totalName = strcat(pathName, fileName);
    set(handles.str_ParamFile, 'String', totalName);
end


% --- Executes on button press in btn_Quitter.
function btn_Quitter_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Quitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
writeSettings(handles);
clear all;
close all;


% --- Executes on button press in btn_Save.
function btn_Save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global iniMatrix resMatrix balise reference sufixe file_name;

if isempty(resMatrix)
   % msgbox('Matrice de resultats vide'); 
	msgbox('Result matrix empty');
	return;
end

outputDir = char(get(handles.str_OutDir, 'String')); 

psufix = get(handles.str_sufixe, 'String');
if ~(isempty(psufix))
	psufix = strcat('_', psufix);
end

gen_name = strcat (outputDir, '\', file_name,sufixe,psufix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% on enregistre 3 fichiers:
%  -	le fichier de données sans traitement, qui inclut aussi en en-tête 
%		le numéro de la balise et la référence de la tortue.
%  -	le fichier de données de résultat : date en jours julian, flag,
%		lon, lat, U, V, Vtotal, cap.
%  -	un fichier d'information avec les statistiques (nombre de points,
%		éliminées, nombre de mesures par classe de localisation, etc.)
%
% le fichier de données sans traitement ==> .ini
try
	outputFile = strcat(gen_name, '.ini');
	fid = fopen(outputFile,'w');
	fprintf (fid, 'Tag:\t%s\nReference:\t%s\n\n\n\n', balise, reference);
    fprintf (fid, 'CNES Day\tTime (s)\tLC\tFrequency\tLat1\tLon1\tLat2\tLon2\tElim_Flag\n');
    fprintf(fid, '%d\t%d\t%d\t%.1f\t%.3f\t%.3f\t%.3f\t%.3f\t%d\n', iniMatrix');
	fclose(fid);
	
catch
	msg = strcat('Impossible to write the file "', outputFile, '". Verify the name of the directory.');
	inError (msg, handles)
	return;
end

% le fichier de réslutats
try
	outputFile = strcat(gen_name, '.res');
	fid = fopen(outputFile,'w');
    fprintf (fid, 'Tag:\t%s\nReference:\t%s\n\n\n\n', balise, reference);
	
	[nl, nc] = size(resMatrix);
	
    fprintf(fid, 'CNES Day\tEstim_Flag\tLon\tLat\tUg (cm/s)\tVg (cm/s)\tSg (cm/s)\tHg (North)\n');
    
	fprintf (fid, '%5.3f\t%d\t%3.3f\t%3.3f\t%1.3f\t%1.3f\t%1.3f\t%2.3f\n',...
			[resMatrix(:,1)/(24*60*60),... % jour julien decimal 
			 resMatrix(:,2),...		% flag
			 resMatrix(:,3),...		%longitude
			 resMatrix(:,4), ...	% latitude
			 resMatrix(:,5), ...	%u
			 resMatrix(:,6), ...	%v
			 resMatrix(:,7), ...	%total
			 resMatrix(:,8)]');		%cap
			
	fclose(fid);
	msgbox ('Enregistrement OK');

catch
	msg = strcat('Impossible to write the file "', outputFile, '". Verify the name of the directory.');
	inError (msg, handles)
	return;
end


% le fichier d'info
try
	outputFile = strcat(gen_name, '.info');
	str =char(get(handles.str_GenInfo, 'String'));
	
	[nl, nc] = size(str);
	str2 = '';
	for i=1:nl
		str2 = sprintf('%s\n%s',str2, str(i,:));
	end
	fid = fopen(outputFile,'w');
  	fprintf (fid, '%s', str2);
  	fclose(fid);

catch
    msg = strcat('Impossible to write the file "', outputFile, '". Verify the name of the directory.');
    inError (msg, handles)
end



% --- Executes on selection change in listTraitement.
function listTraitement_Callback(hObject, eventdata, handles)
% hObject    handle to listTraitement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listTraitement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listTraitement


% --- Executes during object creation, after setting all properties.
function listTraitement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listTraitement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listInputFormat.
function listInputFormat_Callback(hObject, eventdata, handles)
% hObject    handle to listInputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listInputFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listInputFormat


% --- Executes during object creation, after setting all properties.
function listInputFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listInputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function inError (msg, handles)
    axes(handles.fig_trace);
    worldmap world;    
    msgbox(msg);
    set(handles.btn_Execution, 'Enable', 'on');



% --- Executes on button press in btn_OutDir.
function btn_OutDir_Callback(hObject, eventdata, handles)
% hObject    handle to btn_OutDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


previousValue = char(get(handles.str_OutDir, 'String'));

start_dir = char(get(handles.str_OutDir, 'String'));

directory_name = uigetdir(start_dir);

if isequal(directory_name,0)
    set(handles.str_OutDir, 'String', previousValue);
else
    set(handles.str_OutDir, 'String', directory_name);
end




function str_sufixe_Callback(hObject, eventdata, handles)
% hObject    handle to str_sufixe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_sufixe as text
%        str2double(get(hObject,'String')) returns contents of str_sufixe as a double


% --- Executes during object creation, after setting all properties.
function str_sufixe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_sufixe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in btn_gestionParam.
function btn_gestionParam_Callback(hObject, eventdata, handles)
% hObject    handle to btn_gestionParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in ckb_elimterre.
function ckb_elimterre_Callback(hObject, eventdata, handles)
% hObject    handle to ckb_elimterre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckb_elimterre




% --- Executes on button press in ckb_ElimTerre.
function ckb_ElimTerre_Callback(hObject, eventdata, handles)
% hObject    handle to ckb_ElimTerre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckb_ElimTerre




% --- Executes on button press in ckb_hrcote.
function ckb_hrcote_Callback(hObject, eventdata, handles)
% hObject    handle to ckb_hrcote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckb_hrcote


% --- Executes on button press in btn_legende.
function btn_legende_Callback(hObject, eventdata, handles)
% hObject    handle to btn_legende (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ModLuth_legende


% --- Executes on button press in btn_MAJ.
function btn_MAJ_Callback(hObject, eventdata, handles)
% hObject    handle to btn_MAJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global iniMatrix locMatrix resMatrix;
plot_ModLuth_Traj (handles, iniMatrix, locMatrix, resMatrix);




function str_PremierJour_Callback(hObject, eventdata, handles)
% hObject    handle to str_PremierJour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_PremierJour as text
%        str2double(get(hObject,'String')) returns contents of str_PremierJour as a double


% --- Executes during object creation, after setting all properties.
function str_PremierJour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_PremierJour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function str_DernierJour_Callback(hObject, eventdata, handles)
% hObject    handle to str_DernierJour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_DernierJour as text
%        str2double(get(hObject,'String')) returns contents of str_DernierJour as a double


% --- Executes during object creation, after setting all properties.
function str_DernierJour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_DernierJour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function str_FirstLon_Callback(hObject, eventdata, handles)
% hObject    handle to str_FirstLon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_FirstLon as text
%        str2double(get(hObject,'String')) returns contents of str_FirstLon as a double


% --- Executes during object creation, after setting all properties.
function str_FirstLon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_FirstLon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function str_FirstLat_Callback(hObject, eventdata, handles)
% hObject    handle to str_FirstLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_FirstLat as text
%        str2double(get(hObject,'String')) returns contents of str_FirstLat as a double


% --- Executes during object creation, after setting all properties.
function str_FirstLat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_FirstLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function str_reference_Callback(hObject, eventdata, handles)
% hObject    handle to str_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str_reference as text
%        str2double(get(hObject,'String')) returns contents of str_reference as a double


% --- Executes during object creation, after setting all properties.
function str_reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in ckb_pacific.
function ckb_pacific_Callback(hObject, eventdata, handles)
% hObject    handle to ckb_pacific (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckb_pacific


