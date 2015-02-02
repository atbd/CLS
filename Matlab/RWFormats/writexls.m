function res = writexls( inMatrix, outFile )
%
%	res = writexls( inMatrix, outFile )
%
%	Permet d'écrire dans le fichier outFile, les données contenues dans la
%	matrice inMatrix en format excel (xls). Les colonnes de la matrice doivent 
%	être dans l'ordre suivante:
%
%	colonne 1 : indicateur de plateforme
%	colonne 2 : Date (en jours julien)
%	colonne 3 : temps en secondes
%	colonne 4 : classe de localisation
%	colonne 5 : fréquence calculée
%	colonne 5 : latitude
%	colonne 6 : longitude
%	colonne 7 : latitude image
%	colonne 8 : longitude image
%
%	Les données seront écrites dans le même ordre dans le fichier de sortie
%
%	INPUT :
%	inMatrix : Matrice avec les données
%	outFile : Fichier de sortie
%
%	OUTPUT :
%	res :	1 si le fichier a été bien généré
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