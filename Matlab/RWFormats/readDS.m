function [res, balise, reference, matData] = readDS (inputFile)
%
%   [res, balise, reference, matData] = readDiag (inputFile)
%
%	Permet de lire les données de trajectoire d'un fichier en format DS. 
%
%	balise	:	Le numéro de la balise Argos
%	reference :	Cette information n'étant pas disponible dans les fichiers
%	DIAG, la routine renvoi 'vide' pour des raisons de compatibilité avec
%	les autres routines de lecture.
%
%	Tableau (inData)  avec les colonnes suivantes
%	colonne 1  : jour julien
%	colonne 2  : temps en secondes
%	colonne 3  : classe de localisation (format numérique)
%	colonne 4  : fréquence calculée
%	colonne 5  : latitude
%	colonne 6  : longitude
%	colonne 7  : latitude image
%	colonne 8 : longitude image 
%
%   INPUT :
%   inputFile : Fichier avec les données en format DS
%
%   OUTPUT :
%   res : false s'il y a eu de problèmes dans la lecture du fichier
%	balise : le numéro de la balise
%	reference : la référence de la tortue
%   matData : matrice avec les données.
%   
%   AUTEUR  :   BCA
%   DATE    :   06/2006

res = true;

col_date = 1 ;
col_time = 2 ;
col_lc = 3 ;
col_freq = 4;
col_lat1 = 5 ;
col_lon1 = 6 ;
col_lat_image = 7 ;
col_lon_image = 8 ;

% Vérifier que le fichier existe
if (exist (inputFile) == 0)
    res = false;
    matData = [];
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end


% Lecture du fichier pour récupérer toutes les infos
inputData = textread(inputFile,'%s','delimiter','\n');
nbRows = length(inputData);

readline = char(inputData(1));
reference = readline(1:5);
balise = readline(7:11);
j=1;
matData=[];
for (i=1:nbRows)
    readline = char(inputData(i));
    if ( ~isempty(strfind(readline, reference)) && ...
         ~isempty(strfind(readline, balise)) && ...
         ~isempty(strfind(readline, '-')) && ...
         ~isempty(strfind(readline, ':')) )  
        matData(j, col_date) = datenum(str2num(readline(24:27)), ...
                                       str2num(readline(29:30)), ...
                                       str2num(readline(32:33)));
        % la date en jour julien cnes
         matData(j, col_date) =  matData(j, col_date) - datenum('01-01-1950');
         % le temps en secondes
         matData(j, col_time)= str2num(readline(35:36))*3600 + ...
                               str2num(readline(38:39))*60 + ...
                               str2num(readline(41:42));
                           
        % la clase de loc                       
        loc =  readline(22);
        if (loc=='Z'); matData(j, col_lc) = -9; 
        elseif (loc=='B'); matData(j, col_lc) = -2; 
        elseif (loc=='A'); matData(j, col_lc) = -1; 
        else; matData(j, col_lc) = str2num(readline(22)); end;                   
        
        % la latitude
         matData(j, col_lat1) = str2num(readline(44:50));
        % la longitude
         matData(j, col_lon1) = str2num(readline(53:59));
         j = j+1;
    end
end;

if ~isempty(matData)
    matData(:, col_freq) = 0;
    matData(:, col_lat_image) = 0;
    matData(:, col_lon_image) = 0;
end


return;


