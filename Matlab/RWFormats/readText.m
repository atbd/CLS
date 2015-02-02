function [res, balise, reference,  inData] = readText( inputFile )
%
%	[res, inData] = readText( inputFile )
%
%	Permet de lire les donn�es de trajectoire d'un fichier en format TEXT. 
%
%	balise	:	Le num�ro de la balise Argos
%	reference :	R�ference de la tortue (si elle existe)
%
%	Tableau (inData)  avec les colonnes suivantes
%	colonne 1  : jour julien
%	colonne 2  : temps en secondes
%	colonne 3  : classe de localisation (format num�rique)
%	colonne 4  : fr�quence calcul�e
%	colonne 5  : latitude
%	colonne 6  : longitude
%	colonne 7  : latitude image
%	colonne 8 : longitude image
%
%	Les donn�es doivent �tre imp�rativement dans cet ordre dans le fichier
%
%   INPUT :
%   inputFile : Fichier avec les donn�es en format TEXT
%
%   OUTPUT :
%   res : false s'il y a eu de probl�mes dans la lecture du fichier
%	balise : le num�ro de la balise
%	reference : la r�f�rence de la tortue
%   inData : matrice avec les donn�es.
%
%	AUTEUR :	BCA
%	DATE :		10/2006

res = true;

% V�rifier que le fichier existe
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



