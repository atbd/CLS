function [matrice,matrice_toutes_infos, seuil_km] = elimination_outliers(matr_estim,matr,seuil)
% MATRICE=ELIMINATION_OUTLIERS(MATR_ESTIM,MATR,SEUIL) permet d'eliminer
%   les points de la courbe situés trop loin de leur estimée (distance
%   entre le point et son estimée > seuil)
%
%   INPUT PARAMETERS:
%   MATR_ESTIM: Matrice contenant les estimation
%   MATR: Matrice contenant les position originales
%   SEUIL: Ecart maximum tolérer entre les deux points (en km)
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005
%
%	MODIFICATION : Nouvelle méthode (avec moins de boucles) pour détecter
%	les outliers. Le flag indicant que la valeur va être modifié est mis à
%	jour dans cette function.
%
%	Les colonnes de 'matrice_toutes_infos' (8) sont :
%	jour - date - lc - lat1 - lon1 - lat2 - lon2 - flat
%
%	Les colonnes de la matrice estimée (matrice) sont:
%	jour julien decimal  - lat - lon - lc
%	
%	AUTEUR	:	BCA
%	DATE	:	10/2006


% Initialisation des variables du programme


col_date = 1;
col_time = 2;
col_lc = 3;
col_freq = 4;
col_lat1 = 5;
col_lon1 = 6;
col_flag = 9;
col_dist = 10;

matr(:,col_dist) = 0;

lat_estim = 2;
lon_estim = 3;

cte_conv_jour2sec = 24*60*60;

% il faut d'abord calculer les distances

[nb_lig_matr,nb_col_matr] = size(matr);
for(i=1:nb_lig_matr)
	date_matr = matr(i,col_date) * cte_conv_jour2sec + matr(i,col_time);
	est = find(matr_estim(:,1) == date_matr);
	if ~isempty(est) % trouvée dans l'estimation
		% calculer la distance
		 dist = distance_cls([matr(i,col_lat1) matr(i,col_lon1)],[matr_estim(est,lat_estim),matr_estim(est,lon_estim)]);
		 matr(i,col_dist) = floor(dist);
	end 
end

max_dist = floor(max(matr(:,col_dist)));
% for i=1:max_dist
% 	%vec(i) = i+1;
% 	n(i,1) = i;
% end

n = 1:max_dist;
n =n';
n (:,2) = hist (matr(:,col_dist), n(:,1));
total = sum(n(:,2));
n(:,3) = cumsum(n(:,2));
n(:,3) =  n(:,3)/total * 100;


for(i=1:length (n))
	if ( n(i,3) >= seuil)
		seuil_km = n(i,1);
		break;
	end
end

% mise à jour du flag
matr(find(matr(:,col_dist)> seuil_km), col_flag) = 4;
%enlever la colonne de distances 
matr = matr(:,1:col_flag);

matrice_toutes_infos = matr;

matr = matr(find(matr(:,col_flag) == 0),:);
% jour julien decimal
matrice (:,1) = matr(:,1)* cte_conv_jour2sec+ matr(:,2);
% lat et lon
matrice (:,lat_estim:lon_estim) = matr (:,col_lat1:col_lon1);
matrice (:,4) = matr (:,col_lc);

