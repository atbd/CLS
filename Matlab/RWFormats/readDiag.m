function [res, balise, reference, matData] = readDiag (inputFile)
%
%   [res, balise, reference, matData] = readDiag (inputFile)
%
%	Permet de lire les données de trajectoire d'un fichier en format Diag. 
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
%   inputFile : Fichier avec les données en format DIAG
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

wrongValue = 9999;
reference = 'empty';

% Vérifier que le fichier existe
if (exist (inputFile) == 0)
    res = false;
    matData = [];
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end


% Lecture du fichier pour récupérer toutes les infos
inputData = textread(inputFile,'%s');

% Recuperation des dimensions de la matrice
[nbRows,nbColumn] = size(inputData);

inputData = upper(inputData);

% Trouver la première ligne avec de données, ceci afin d'eviter des en
% têtes dont on ne connaît pas la taille. 
for i=1:nbRows
    if (strcmp(inputData(i),'DATE'))
        firstRow = i;
        break;
    end
end

inputData = inputData(firstRow-1:end);
[nbRows,nbColumn] = size(inputData);
balise = char(inputData(1,1));

j=0;
i=1;

while (i<=nbRows)
    % nouvelle ligne
    if (strcmp(inputData(i), 'DATE'))
        j = j + 1;      
		matData(j,1:8) = wrongValue;
				
        if length(strfind(char(inputData(i+2)),'?')) >0;i = i + 3; continue; end;
		%la date
		matData (j, col_date) = conv_jourgreg2jourjul(strrep(inputData(i+2), '.', '/'));
		
		%le temps
		matData (j, col_time) = conv_strheure2seconde (inputData(i+3));
		
        i = i + 3;    
        continue;
    end
    
    % Classe de localisation obtenue (LC)
    if (strcmp(inputData(i), 'LC'))
        [ret, lcValue] = convLocation (inputData(i+2), wrongValue);      
        if (ret == true)
            matData (j, col_lc) = lcValue;
        end
        i = i + 2;
        continue;
	end
    
     
      %La latitude et le sens 
     if (strcmp(inputData(i), 'LAT1'))
        [ret, lat1] = convLatitude(char(inputData(i+2))); 
        if (ret == true)
            matData (j, col_lat1) = lat1;
        end
        i = i + 2;
        continue;
     end 	
	
     %La longitude et le sens 
     if (strcmp(inputData(i), 'LON1'))
        [ret, lon1] = convLongitude(char(inputData(i+2))); 
        if (ret == true)
            matData (j, col_lon1) = lon1;
        end
        i = i + 2;
        continue;
	 end   
  
     %La latitude et le sens de la position image
     if (strcmp(inputData(i), 'LAT2'))
        [ret, lat_image] = convLatitude(char(inputData(i+2))); 
        if (ret == true)
            matData (j, col_lat_image) = lat_image;
        end
        i = i + 2;
        continue;
	 end    
	 
     %La longitude et le sens de la position image
     if (strcmp(inputData(i), 'LON2'))
        [ret, lon_image] = convLongitude(char(inputData(i+2))); 
        if (ret == true)
            matData (j, col_lon_image) = lon_image;
        end
        i = i + 2;
        continue;
	 end   
	 
	 % la fréquence
	 if (strcmp(inputData(i), 'CALCUL'))
         if strcmp(inputData(i+4), 'HZ')
             strfreq = inputData(i+3);
         else
            strfreq = strcat(inputData(i+3), inputData(i+4));
         end
		 matData(j, col_freq) = str2num(char(strfreq));
		 i = i + 5;
		 continue;
     end
 
	 i=i+1;
end	 
