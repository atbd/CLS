function [res, balise, reference,  inData] = readText( inputFile )
%
%	[res, inData] = readText( inputFile )
%
%	Permet de lire les données de trajectoire d'un fichier en format TEXT. 
%
%	balise	:	Le numéro de la balise Argos
%	reference :	Réference de la tortue (si elle existe)
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
%	Les données doivent être impérativement dans cet ordre dans le fichier
%
%   INPUT :
%   inputFile : Fichier avec les données en format TEXT
%
%   OUTPUT :
%   res : false s'il y a eu de problèmes dans la lecture du fichier
%	balise : le numéro de la balise
%	reference : la référence de la tortue
%   inData : matrice avec les données.
%
%	AUTEUR :	BCA
%	DATE :		10/2006

res = true;

% Vérifier que le fichier existe
if (exist (inputFile) == 0)
    res = false;
	balise = '';
	reference = '';
    inData = [];
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end


[res, balise, reference, textheader, inData] = readResults( inputFile );

if res == false;
    msbox('Error in readText');
    return;
end

return;



