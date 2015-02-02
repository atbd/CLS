function res = writeText( inMatrix, outFile )
%
%	res = writeText( inMatrix, outFile )
%
%	Permet d'�crire dans le fichier outFile, les donn�es contenues dans la
%	matrice inMatrix en format TEXTE. Les colonnes de la matrice doivent 
%	�tre dans l'ordre suivante:
%
%	colonne 1 : indicateur de plateforme
%	colonne 2 : Date (en jours julien)
%	colonne 3 : temps en secondes
%	colonne 4 : classe de localisation
%	colonne 5 : fr�quence calcul�e
%	colonne 6 : latitude
%	colonne 7 : longitude
%	colonne 8 : latitude image
%	colonne 9 : longitude image
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
	dlmwrite(outFile, inMatrix, '\t');
catch
	res = false
end

return