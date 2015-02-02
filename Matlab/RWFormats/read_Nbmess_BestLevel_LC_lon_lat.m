function [res, balise, data] = read_Nbmess_BestLevel_LC_lon_lat (inputFile, outFile)
%
%   [res, balise, reference, matData] = read_Nbmess_BestLevel (inputFile, outFile)
%
%	Permet de lire les données de Nombre de messages et best level de 
%   d'un fichier en format Diag. 
%
%	balise	:	Le numéro de la balise Argos
%	data    :   Matrice de 4 colonnes, jour julien CNES, temps, 
%               nombre de messages et best level	
%
%	colonne 1  : jour julien
%	colonne 2  : temps en secondes
%	colonne 3  : nb messages
%	colonne 4  : Best level
%
%   INPUT :
%   inputFile   : Fichier avec les données en format DIAG
%   outFile     : Fichier avec les resultats
%
%   OUTPUT :
%   res : false s'il y a eu de problèmes dans la lecture du fichier
%	balise : le numéro de la balise
%   data : matrice avec les données.
%   
%   AUTEUR  :   BCA
%   DATE    :   06/2007

res = true;

col_date = 1 ;
col_time = 2 ;
col_nbMess = 3 ;
col_BestLevel = 4;
col_LC = 5;
col_lon = 6;
col_lat =7;

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
inputData = textread(inputFile,'%s', 'delimiter','\n');

% Recuperation des dimensions de la matrice
[nbRows,nbColumn] = size(inputData);

inputData = upper(inputData);

% Trouver la première ligne avec de données, ceci afin d'eviter des en
% têtes dont on ne connaît pas la taille. 
firstRow = 0;
for i=1:nbRows
    if (strfind(char(inputData(i)),'DATE'))
        readline = char(inputData(i));
        balise = readline(1:5);
        firstRow = i;
        break;
    end
end

if (firstRow == 0); 
    msgbox('error dans le fichier');
    res = false;
    return;
end


inputData = inputData(firstRow:end);
[nbRows,nbColumn] = size(inputData);

j=1;
i=1;

while (i<=nbRows)
    % nouvelle ligne
    
    if (strfind(char(inputData(i)), 'DATE'))
        readline = char(inputData(i));
        
        % la date
        dd = str2num(readline(15:16));
        mm = str2num(readline(18:19));
        yy = str2num(readline(21:22));
        if (yy < 10); yy = yy +2000; else yy = yy+1900; end;
        data(j, col_date) = datenum(yy, mm, dd) - datenum('01-01-1950');
        
        % le temps
        data(j, col_time) = str2num(readline(24:25))*3600 + ...
                             str2num(readline(27:28))*60 + ...
                             str2num(readline(30:31));
                         
                    
        lc = readline(39);
        if (lc == 'Z'); data(j, col_LC) = -9; 
        elseif (lc == 'B'); data(j, col_LC)= -2;
        elseif (lc == 'A'); data(j, col_LC)= -1;
        else data(j, col_LC)= str2num(lc); end; 
      
        %lon lat
        readline = char(inputData(i+1));

        if (strfind(readline, '?'))
            data(j, col_lon) = wrongValue;
            data(j, col_lat) = wrongValue;
        else
            data(j, col_lon) = str2num(readline(24:30));
            if(readline(31)=='W');data(j,col_lon) = - data(j,col_lon); end;

            data(j, col_lat) = str2num(readline(8:13));
            if(readline(14)=='S');data(j,col_lat) = - data(j,col_lat); end;
        end
        
        % nb mess
        readline = char(inputData(i+2));
        data(j, col_nbMess) = str2num(readline(10:12));

        % bestlevel
        data(j, col_BestLevel) = str2num(readline(49:52));

        j = j+1;
    end
    i = i+1;
   
end


if ( exist('outFile','var'))
    xlswrite(outFile, {'Balise :', balise }, 1 , 'A1' );
    xlswrite(outFile, {'Date', 'Time', 'Nb mess', 'BestLevel' }, 1 , 'A3');
    xlswrite(outFile, data, 1 , 'A4');
end
