function res = writeExpert ( inMatrix, outFile )
%
%	res = writeExpert ( inMatrix, outFile )
%
%	Permet d'écrire dans le fichier outFile, les données contenues dans la
%	matrice inMatrix en format EXPERT. Les colonnes de la matrice doivent 
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
%	fichiers EXPERT originaux, on va just metre quelques valeurs par défaut,
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
	str = sprintf('         Ptfm: %s\n', num2str(inMatrix(i,col_ptfm)));
	
	% deuxième ligne
	str =  sprintf('%sDate: %d\ts:  %d       100/03 Msg: 10 >-120Db:  0 Best: -121 D_dat: 495\n',...
					str, inMatrix(i,col_date),inMatrix(i,col_time));
	% troisième ligne
	str =  sprintf('%sNloc: 31      LQ: 0000503000 22:36:18 Alt:  0.000 F_init: 647010.3 NM09922MEL\n',str);
					
	% quatrième ligne
	str =  sprintf('%sDate of processing : %s %s\n',...
					str,... 
				    datestr(datenum(jourjul2jourgreg(inMatrix(i,col_date)), 'dd.mm.yyyy'), 1),...
					sec2heure(num2str(inMatrix(i,col_time))));

	% cinquième ligne
	if ~(inMatrix(i,col_lat1) == 9999)
		str =  sprintf ('%sLat1: %2.4f Lon1: %2.4f Lat2:  %2.4f Lon2: %2.4f F: 647936.2 NQ: %d\n', ...
					str, inMatrix(i,col_lat1), inMatrix(i,col_lon1), ...
					inMatrix(i,col_lat2), inMatrix(i,col_lon2), ...
					lc2nq(inMatrix(i, col_lc)));
	end
		
	% cinquième ligne
	str = sprintf('%sCi:    0.00   Cf:  -1.00 Pb:50. Dp:  20.434    Vl:  1.420  Df:  0.00  Tr:  3.1\n',str);
	
					
	fprintf(fid_out, '%s', str);
	
	
end

fclose (fid_out);
