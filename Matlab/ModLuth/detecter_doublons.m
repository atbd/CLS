function inMatrix  = detecter_doublons (inMatrix);

%	outMatrix  = detecter_doublons (inMatrix)
%
%	Cette fonction permet de détecter les doublons dans les observations.
%	La colonne de flag est misse à '4' si c'est un doublon et si la classe
%	de localisation est différente de Z
%
%	INPUT :
%	inMatrix	:	Matrix avant la détection.
%
%	OUTPUT :
%	outMatrix	:	Matrix avec les valeurs de flag misses à jour
%
%	AUTEUR	:	Beatriz Calmettes
%	DATE	:	10/06
%

col_jour = 1;
col_sec = 2;
col_lat1 = 5;
col_lon1 = 6;
col_lat2 = 7;
col_lon2 = 8;
col_flag = 9;

% Récupération des dimensions de la matrice
[nb_ligne_matr,nb_colonne_matr] = size(inMatrix);

% Pour chaque loc (sauf la première)
for i=2:nb_ligne_matr
	% même date
	if (inMatrix(i,col_jour) == inMatrix(i-1,col_jour)) && ...
		(inMatrix(i, col_sec) == inMatrix(i-1, col_sec))
			if (inMatrix(i, col_flag) ~= 1) % si ce n'est pas une classe Z
				inMatrix (i, col_flag) = 2;   % flag parce que c'est un doublon
			end	
	else	
		if  ((abs(inMatrix(i, col_lat1) - inMatrix(i-1,col_lat1)) > 0.001) || (abs(inMatrix(i,col_lon1) - inMatrix(i-1,col_lon1)) > 0.001)) && ... 
			((abs(inMatrix(i, col_lat2) - inMatrix(i-1,col_lat2)) > 0.001) || (abs(inMatrix(i,col_lon2) - inMatrix(i-1,col_lon2)) > 0.001)) 
			%nouvelle mesure
			continue;
		else
			if (inMatrix(i, col_flag) ~= 1) % si ce n'est pas une classe Z
				inMatrix (i, col_flag) = 2;   % flag parce que c'est un doublon
			end			
		end
	end
end

return
