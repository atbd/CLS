function res = writexls( inMatrix, outFile )
%
%	res = writexls( inMatrix, outFile )
%
%	Permet d'�crire dans le fichier outFile, les donn�es contenues dans la
%	matrice inMatrix en format excel (xls). Les colonnes de la matrice doivent 
%	�tre dans l'ordre suivante:
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
%	Les donn�es seront �crites dans le m�me ordre dans le fichier de sortie
%
%	INPUT :
%	inMatrix : Matrice avec les donn�es
%	outFile : Fichier de sortie
%
%	OUTPUT :
%	res :	1 si le fichier a �t� bien g�n�r�
%
%	AUTEUR :	BCA
%	DATE :		10/2006

res = true;

try
	titres = {'Ptfm', 'Date' ,'Temps' ,'LC', 'Freq', 'Lat1', 'Lon1','Lat2', 'Lon2'}; 
	xlswrite(outFile,titres,'Feuil1');

    % ecriture de la matrice dans un fichier XLS
    xlswrite(outFile,inMatrix,'Feuil1','A2');

catch
	res = false
end

return