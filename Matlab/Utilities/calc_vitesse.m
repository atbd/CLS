function [res, A] = calc_vitesse(vec_tps,vec_lat,vec_lon)
%   A=calc_vitesse(VEC_TPS,VEC_LAT,VEC_LON) calcul des  vitesses a
%   partir des donnees de latitude et de longitude et du temps
%
%   INPUT PARAMETERS:
%   VEC_LAT: Vecteur contenant l'ensemble des latitudes
%   VEC_LON: Vecteur contenant l'ensemble des longitudes
%   VEC_TPS: Vecteur contenant l'ensemble des dates (en secondes)
%  
%   RETURN PARAMETERS:
%   A: Matrice contenant l'ensemble des vitesses calculées
%	colonne 1 : U
%	colonne 2 : V
%	colonne 3 : Totale
%	colonne 4 : Direction
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005
% 
%	Modification: BCA  - 10/2006
%	Le calcul de la vitesse dans le point i est calculé par rapport au
%	point suivant au lieu d'étre calculé par rapport au point précedent.
%	Calcule aussi la direction de la vitesse
%


% Récupération des dimensions de tous les vecteurs
nb_lig_lat = length(vec_lat);
nb_lig_lon = length(vec_lon);
nb_lig_tps = length(vec_tps);

col_u = 1;
col_v = 2;
col_total = 3;
col_cap =4;

% Si tous les vecteurs ont les memes dimensions
if ~(nb_lig_lat == nb_lig_lon && nb_lig_tps == nb_lig_lat)
	res = false;
	return;
end

res = true;

% Pour chaque ligne sauf la dernière
for i=1:nb_lig_tps-1

	% Calculer les vitesses
	temp = vitesse(vec_lat(i),0,vec_lat(i+1),0,vec_tps(i),vec_tps(i+1)); % V

	if vec_lat(i) > vec_lat(i+1)
		A(i,col_v) = -temp;
	else
		A(i,col_v) = temp;
	end

	temp = vitesse(0, vec_lon(i),0,vec_lon(i+1),vec_tps(i),vec_tps(i+1)); % U
	if vec_lon(i) > vec_lon(i+1)
		A(i,col_u) = -temp;
	else
		A(i,col_u) = temp;
	end

	% norme et cap
	A(i,col_total) = sqrt(A(i,col_u)^2 + A(i,col_v)^2);
	% la norme est par rapport au nord
	A(i,col_cap) = rad2deg (atan2 (A(i,col_u), A(i,col_v)));
	
end

% on ne peut pas calculer la vitesse pour le dernier point 
A(nb_lig_tps,:) = 999;
