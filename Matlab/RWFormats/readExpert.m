function [res, balise, reference, matData] = readExpert (inputFile)
%
%   [res, balise, reference, matData] = readExpert (inputFile)
%
%	Permet de lire les données de trajectoire d'un fichier en format Expert. 
%
%	balise	:	Le numéro de la balise Argos
%	reference :	Cette information n'étant pas disponible dans les fichiers
%	Expert, la routine renvoi 'empty' pour des raisons de compatibilité avec
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
%	colonne 8  : longitude image 
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
col_freq =4;
col_lat1 = 5 ;
col_lon1 = 6 ;
col_lat_image = 7 ;
col_lon_image = 8 ;


wrongValue = 9999;


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
    if (strcmp(inputData(i),'PTFM:'))
        firstRow = i;
        break;
    end
end

balise = char(inputData{2});
reference = 'empty';

if (firstRow > 1)
	inputData = inputData(firstRow-1:end);
end

[nbRows,nbColumn] = size(inputData);


j=0;

i=1;
while (i<nbRows)
    % nouvelle ligne
    if (strcmp(inputData(i), 'PTFM:'))
        j = j + 1;      
        matData(j,1:7) = wrongValue;
    end
    
    %la date
    if (strcmp(inputData(i), 'DATE:'))
         matData (j, col_date) =  str2num(char(inputData(i+1)));
         i=i+2;
         continue;
    end
    
    % les secondes
    if (strcmp(inputData(i), 'S:'))
        matData (j, col_time) = str2num(char(inputData(i+1)));
        i = i + 2;    
        continue
    end
    
    % Classe de localisation obtenue (LC)
    if ( ~isempty(strfind(char(inputData(i)), 'NQ:')))
      %  strcmp(inputData(i), 'NQ:'))
        temp = char(inputData(i));
        
        if (length(temp) > 3)
            str_value = char(temp(4:end));
        else
            str_value = inputData(i+1);
        end
        
        [ret, lcValue] = convLocation (str_value, wrongValue);      
        if (ret == true)
            matData (j, col_lc) = lcValue;
        end
        i = i + 2; 
        continue
    end
    
     %La longitude et le sens 
     if (strcmp(inputData(i), 'LON1:'))
        [ret, lon1] = convLongitude(char(inputData(i+1))); 
        if (ret == true)
            matData (j, col_lon1) = lon1;
        end
        i = i + 2;
        continue
     end   
     
      %La latitude et le sens 
     if (strcmp(inputData(i), 'LAT1:'))
        [ret, lat1] = convLatitude(char(inputData(i+1))); 
        if (ret == true)
            matData (j, col_lat1) = lat1;
        end
        i = i + 2;
        continue
     end   
     
     %La longitude et le sens de la position image
     if (strcmp(inputData(i), 'LON2:'))
        [ret, lon_image] = convLongitude(char(inputData(i+1))); 
        if (ret == true)
            matData (j, col_lon_image) = lon_image;
        end
        i = i + 2;
        continue
     end   
     
     %La latitude et le sens de la position image
     if (strcmp(inputData(i), 'LAT2:'))
        [ret, lat_image] = convLatitude(char(inputData(i+1))); 
        if (ret == true)
            matData (j, col_lat_image) = lat_image;
        end
        i = i + 2;
        continue
	 end   
	 
	 % la fréquence 
	if (strcmp(inputData(i), 'F:'))
		freq = str2num (char(inputData(i+1)));
		freq = 401000000 + freq;
		matData(j, col_freq) = freq;
		i = i+2;
		continue
	end

	 
     
     i = i+1;
end




   
    
           
        