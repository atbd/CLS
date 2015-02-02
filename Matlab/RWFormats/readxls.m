function [res, inData] = readxls( inputFile )
%
%	[res, inData] = readText( inputFile )
%
%	Permet de lire un fichier en format TEXT et de g�n�rer une
%   matrice avec les donn�es utiles:
%
%	colonne 1 : indicateur de plateforme
%	colonne 2 : Date (en jours julien)
%	colonne 3 : temps en secondes
%	colonne 4 : classe de localisation
%	colonne 5 : fr�quence calcul�e
%	colonne 5 : latitude
%	colonne 6 : longitude
%	colonne 7 : latitude image
%	colonne 8 : longitude image
%
%	Les donn�es doivent �tre imp�rativement dans cet ordre dans le fichier
%
%   INPUT :
%   inputFile : Fichier avec les donn�es en format TEXT
%
%   OUTPUT :
%   res : false s'il y a eu de probl�mes dans la lecture du fichier
%   matData : matrice avec les donn�es.
%
%	AUTEUR :	BCA
%	DATE :		10/2006

res = true;

% V�rifier que le fichier existe
if (exist (inputFile) == 0)
    res = false;
    matData = [];
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end

try
	[N, T, rawdata] = xlsread(inputFile);
	inData = N;
catch
	res = false;
end