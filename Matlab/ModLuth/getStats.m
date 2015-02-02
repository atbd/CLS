function stat = getStats (file_name, file_ext, balise, reference, seuil_km, iniMatrix, resMatrix, datePremierLoc, dateDernierLoc, handles)
%  
%   stat = getStats (file_name, file_ext, balise, reference, seuil_km,
%   iniMatrix, resMatrix, datePremierLoc, dateDernierLoc, handles)
%   
%   Fonction qui renvoi les statistiques des données:
%	- nb_doublons : Nombre de doublons (flag  = 2)
%   - nb_vit_exc : Nombre de points éliminés à cause d'une vitesse excesive
%   - nb_outliers : Nombre de outliers
%   - nb_LCZ = Nombre de localisations classe Z
%   - nb_LCB = Nombre de localisations classe B
%   - nb_LCA = Nombre de localisations classe A
%   - nb_LC0 = Nombre de localisations classe 0
%   - nb_LC1 = Nombre de localisations classe 1 
%   - nb_LC2 = Nombre de localisations classe 2
%   - nb_LC3 = Nombre de localisations classe 3
%   - duree = Durée du suivi
%   - iniLoc = Nombre de localisations durant le suivi
%
%   INPUT :
%   iniMatrix   : Matrice initiale
%   resMatrix   : Matrice des résultats
%  
%   OUTPUT:
%   stat    : structure avec les statistiques
%   
%   
%   AUTEUR  :   BCA
%   DATE    :   06/2006

col_date = 1;
col_flag = 9;
col_lc = 3;
col_freq = 4;


[nb_lig_iniMatrix,nb_col_iniMatrix] = size(iniMatrix);
[nb_lig_resMatrix,nb_col_resMatrix] = size(resMatrix);

stat.nb_doublons = length(iniMatrix(find(iniMatrix(:,col_flag)==2), col_flag));
stat.terre = length(iniMatrix(find(iniMatrix(:,col_flag)==6), col_flag));
stat.nb_vit_exc = length(iniMatrix(find(iniMatrix(:,col_flag)== 3), col_flag));
stat.nb_outliers = length(iniMatrix(find(iniMatrix(:,col_flag)==4), col_flag));

stat.nb_LCZ = length(iniMatrix(find(iniMatrix(:,col_lc)==-9), col_lc));
stat.nb_LCB = length(iniMatrix(find(iniMatrix(:,col_lc)==-2), col_lc));
stat.nb_LCA = length(iniMatrix(find(iniMatrix(:,col_lc)==-1), col_lc));
stat.nb_LC0 = length(iniMatrix(find(iniMatrix(:,col_lc)==0), col_lc));
stat.nb_LC1 = length(iniMatrix(find(iniMatrix(:,col_lc)==1), col_lc)); 
stat.nb_LC2 = length(iniMatrix(find(iniMatrix(:,col_lc)==2), col_lc));
stat.nb_LC3 = length(iniMatrix(find(iniMatrix(:,col_lc)==3), col_lc));
stat.duree = iniMatrix(end,col_date) - iniMatrix(1,col_date) + 1; %durée du suivi
stat.iniLoc = nb_lig_iniMatrix; % 'nombre de loc durant le suivi

stat.TotalDistini = totalDistance(iniMatrix(find(iniMatrix(:,col_flag)==0), :), 5,6); % distance parcourue en kilomètres
stat.TotalDist = totalDistance(resMatrix, 4,3); % distance parcourue en kilomètres

temp = floor(resMatrix(1,1)/(24*60*60));
stat.PremierJour = strcat(strrep(jourjul2jourgreg(temp), '.','/'), ' (', num2str(temp), ')'); % premier jour
temp = floor(resMatrix(end,1)/(24*60*60));
stat.DernierJour = strcat(strrep(jourjul2jourgreg(temp), '.','/'), ' (', num2str(temp), ')'); % dernier jour

if (iniMatrix(1,col_freq)==0)
    stat.var_freq = var(iniMatrix(2:end,col_freq));
else
    stat.var_freq = var(iniMatrix(:,col_freq));
end


str = sprintf('File Name: %s%s\n',file_name, file_ext);
str =  sprintf('%sTag: %s\n', str, balise);
str =  sprintf('%sReference: %s\n\n', str, reference);

stat.datePremierLoc = strcat(strrep(jourjul2jourgreg(datePremierLoc), '.','/'), ' (', num2str(datePremierLoc), ')'); 
stat.dateDernierLoc = strcat(strrep(jourjul2jourgreg(dateDernierLoc), '.','/'), ' (', num2str(dateDernierLoc), ')'); 
str = sprintf('%sDate GMT of the first Argos location: %s\n', str, stat.datePremierLoc);
str = sprintf('%sDate GMT of the last Argos location:  %s\n', str, stat.dateDernierLoc);

str = sprintf('%s\nStarting treatment day: %s\n', str, stat.PremierJour);
str = sprintf('%sEnding treatment day: %s\n', str, stat.DernierJour);




str = sprintf('%s\nTracking duration (days): %d\n',str,stat.duree);    



str = sprintf('%s\nNumber of locations: %d\n', str, stat.iniLoc);

str = sprintf('%s    Number of LCZ: %d (%2.2f%%)\n', str, stat.nb_LCZ, stat.nb_LCZ*100/stat.iniLoc);
str = sprintf('%s    Number of LCB: %d (%2.2f%%)\n', str, stat.nb_LCB, stat.nb_LCB*100/stat.iniLoc);
str = sprintf('%s    Number of LCA: %d (%2.2f%%)\n', str, stat.nb_LCA, stat.nb_LCA*100/stat.iniLoc);
str = sprintf('%s    Number of LC0: %d (%2.2f%%)\n', str, stat.nb_LC0, stat.nb_LC0*100/stat.iniLoc);
str = sprintf('%s    Number of LC1: %d (%2.2f%%)\n', str, stat.nb_LC1, stat.nb_LC1*100/stat.iniLoc);
str = sprintf('%s    Number of LC2: %d (%2.2f%%)\n', str, stat.nb_LC2, stat.nb_LC2*100/stat.iniLoc);
str = sprintf('%s    Number of LC3: %d (%2.2f%%)\n', str, stat.nb_LC3, stat.nb_LC3*100/stat.iniLoc);

str = sprintf('%s\nFrequency variance (Hz): %9.1f\n', str, stat.var_freq);
str = sprintf('%s\nDistance travelled after localization and speed correction (km) : %4.2f\n', str, stat.TotalDistini);




str = sprintf('%s\n*********************\n', str); 

traitement_val = get(handles.listTraitement,'Value');
traitement_str = get(handles.listTraitement,'String');

str = sprintf('%s\nTreatment: %s\n', str, char(traitement_str(traitement_val,:))); 

if (get(handles.listTraitement,'Value') == 2) % rediscretisation
    pas_redisc = getParamValue2(char(get(handles.str_ParamFile, 'String')),...
                                'redi/pas_redisc', '');
     str = sprintf('%s\nRediscretisation step (s) : %s \n', str,char(pas_redisc));
    
end


if (get(handles.listTraitement,'Value') == 3) % epanechnikov
	ecart = getParamValue2(char(get(handles.str_ParamFile, 'String')),...
					'lovi/ecart_max_pourcentage', '95');
	str = sprintf('%s\nThreshold for the outliers exclusion (km) : %d (at least %s %% of the locations preserved)\n', str, ...
			   seuil_km, char(ecart));
end
		   
			   
str = sprintf('%s\nNumber of the excluded locations:\n', str); 
[nblig, nbcol] = size(iniMatrix);	 
str =  sprintf('%s    Double: %d\n', str, stat.nb_doublons);
if (get(handles.ckb_ElimTerre, 'Value') == true)
	str= sprintf('%s    Earth locations: %d\n', str, stat.terre);
end;
str = sprintf('%s    Excessive speed (> %s m/s): %d (%2.2f%%)\n',...
	  str, char(getParamValue2(get(handles.str_ParamFile, 'String'), 'lovi/vitesse_max', '2.8')),...
	  stat.nb_vit_exc, stat.nb_vit_exc*100/nblig);
if (get(handles.listTraitement,'Value') == 3) % epanechnikov
	str = sprintf('%s    Outliers: %d\n', str, stat.nb_outliers);
end

str = sprintf('%s\nDistance travelled after treatment (km) : %4.2f\n', str, stat.TotalDist);

set(handles.str_GenInfo, 'String', str);

