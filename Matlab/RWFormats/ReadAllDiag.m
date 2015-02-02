function [matData] = ReadAllDiag (inputFile)
%
%   [matData] = readDiag (inputFile)
% 
%
%   INPUT :
%   inputFile : Fichier avec les données en format DIAG
%


col_tag = 1 ;
col_jour = 2 ;
col_time = 3;
col_lc = 4;
col_IQ = 5;
col_lat1 = 6;
col_lon1 = 7;
col_lat2 = 8;
col_lon2 = 9;
col_nbmess = 10;
col_nbmess120 = 11;
col_bestlevel = 12;
col_pasduration = 13;
col_NOPC = 14;
col_freq =15;
col_altitude = 16;

wrongValue = 9999;
matData = [];
% Vérifier que le fichier existe
if (exist (inputFile) == 0)
 
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end


% Lecture du fichier pour récupérer toutes les infos
inputData = textread(inputFile,'%s', 'delimiter', '\n');

% Recuperation des dimensions de la matrice
[nbRows,nbColumn] = size(inputData);

inputData = upper(inputData);

[nbRows,nbColumn] = size(inputData);


j=0;
i=1;
%disp(nbRows);
while (i<=nbRows)
  %  disp(i);
    readline = char(inputData(i));
    if (findstr(readline, 'DATE'))
        j = j + 1 ;               
		matData(j,col_tag) =  str2num(readline(1:5));
		matData(j, col_jour) = 	floor(datenum(readline(14:22), 'dd.mm.yy')-datenum('01-01-1950'));
        matData(j, col_time) = 	str2num(readline(24:25))*3600+ str2num(readline(27:28))*60+str2num( readline(30:31));
        
        % LC
        lc = (readline(39));
        if strcmp(lc, 'Z');  matData(j, col_lc) = -9;
        elseif strcmp(lc, 'B');  matData(j, col_lc) = -2;
        elseif strcmp(lc, 'A');  matData(j, col_lc) = -1;
        else matData(j, col_lc) = str2num(lc); end;
        
        % IQ
        matData(j, col_IQ) = str2num(readline(46:48));
        
        
        % lon et lat
        readline = char(inputData(i+1));
        if (strfind(readline, '?'))
             matData (j, col_lat1) = wrongValue;
             matData (j, col_lon1) = wrongValue;
             matData (j, col_lat2) = wrongValue;
             matData (j, col_lon2) = wrongValue;
        else
            matData (j, col_lat1) = str2num(readline(8:13));
            if (readline(14) =='S')
                matData (j, col_lat1) = -matData (j, col_lat1);
            end;
            matData (j, col_lon1) = str2num(readline(25:30));
            if (readline(31) =='W')
                matData (j, col_lon1) = -matData (j, col_lon1);
            end;

            matData (j, col_lat2) = str2num(readline(41:46));
            if (readline(47) =='S')
                matData (j, col_lat2) = -matData (j, col_lat2);
            end;
            matData (j, col_lon2) = str2num(readline(58:63));
            if (readline(64) =='W')
                matData (j, col_lon2) = -matData (j, col_lon2);
            end;  
        end
        
       % nbmess, nbmess > -120, bestlevel
        readline = char(inputData(i+2));
        matData (j, col_nbmess) = str2num(readline(10:12));
        matData (j, col_nbmess120) = str2num(readline(31:33));
        matData (j, col_bestlevel) = str2num(readline(49:52));
     
        readline = char(inputData(i+3));
     
        if (strfind(readline, '?'))
            matData (j, col_pasduration) = wrongValue;
            matData (j, col_NOPC) = wrongValue;
        else
            matData (j, col_pasduration) = str2num(readline(17:19));
            matData (j, col_NOPC) = str2num(readline(31));
        end
     
        readline = char(inputData(i+4));
        matData (j, col_freq) = str2num([readline(15:17) readline(19:26)]);
        matData (j, col_altitude) = str2num(readline(43:47));
     
        i = i+5;
    else
	 i=i+1;
    end
end	 
