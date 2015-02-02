function res = writeDiag ( inMatrix, outFile )
%
%	res = writeDiag ( inMatrix, outFile )
%
%	Permet d'écrire dans le fichier outFile, les données contenues dans la
%	matrice inMatrix en format DIAG. Les colonnes de la matrice doivent 
%	être dans l'ordre suivante:
%
%	colonne 1 : indicateur de plateforme
%	colonne 2 : Date (en jours julien)
%	colonne 3 : temps en secondes
%	colonne 4 : classe de localisation
%	colonne 5 : latitude
%	colonne 6 : longitude
%	colonne 7 : latitude image
%	colonne 8 : longitude image
%
%	Il y a un certain nombre de paramètres qui sont inclus dans les
%	fichiers DIAG originaux, on va just metre quelques valeurs par défaut,
%	juste pour faire le fichier de sortie compatible avec d'autres
%	programmes même si ces valeurs ne sont pas utilisés.
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

col_ptfm = 1;
col_date = 2;
col_time = 3;
col_lc = 4;
col_lat1 = 5;
col_lon1 = 6;
col_lat2 = 7;
col_lon2 = 8;


if isempty(inMatrix)
	res = false;
	return;
end

[nb_lig, nb_col] = size (inMatrix);

if (nb_col < 8)
	res = false;
	return;
end

fid_out = fopen (outFile, 'w');
if (fid_out == -1)
	msgbox (['Impssible d''ouvrir le fichier ' outFile]);
	res = false;
	return;
end

for (i = 1:nb_lig)
	
	% première ligne
	dateDiag = jourjul2jourgreg(inMatrix(1,col_date));
	dateDiag (7:8) = '';
	str =  sprintf('%s  Date : %s %s  LC : %s IQ : 02\n', ...
					num2str(inMatrix(i,col_ptfm)), ...
					dateDiag,...
					sec2heure(num2str(inMatrix(1,col_time))),...
					loc2str(inMatrix(i,col_lc)));
				
	% deuxième ligne
	str =  sprintf('%s     Lat1 : %s  Lon1 : %s  Lat2 : %s  Lon2 : %s\n',...
				    str,...
					NSLat(inMatrix(i,col_lat1)), EWLon(inMatrix(i,col_lon1)),...
					NSLat(inMatrix(i,col_lat2)), EWLon(inMatrix(i,col_lon2)));
				
	
	% à partir le troisième ligne, l'enregistrement est fixe pour le moment
	
	str = sprintf ('%s%s\n%s\n%s\n%s\n\n', ...
					str, ...
					'     Nb mes : 008  Nb mes>-120dB : 000  Best level : -125 dB',...
					'     Pass duration : 322s   NOPC : 3', ...                                          
					'     Calcul freq : 401 646911.1 Hz   Altitude :    0 m ', ...                       
					'            00          168          192           53');
					
	fprintf(fid_out, '%s', str);
	
	
end

fclose (fid_out);
