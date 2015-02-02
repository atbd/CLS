function matrice = elimination_mat_vitesse_excessive(matrice,vitesse_max_tortue)
% [MATRICE]=ELIMINATION_MAT_VITESSE_EXCESSIVE(MATR,VITESSE_MAX_TORTUE) 
%   elimine les loc correspondant à des vitesses excessives
%
%   INPUT PARAMETERS:
%   MATR: matrice contenant les infos
%   VITESSE_MAX_TORTUE: paramètre donnant la vitesse max des tortues
%  
%   RETURN PARAMETERS:
%   MATRICE = matrice représentant les données corrigées dans la matrice
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005


% Initialisation des variables du programme

col_jour = 1;
col_sec = 2;
col_lc = 3;
col_freq = 4;
col_lat1 = 5;
col_lon1 = 6;
col_lat2 = 7;
col_lon2 = 8;
col_flag = 9;


nbpoints = find(matrice(:,col_flag) == 0);
if length(nbpoints) < 4
	return; % rien à changer
end


modif = 1;
%vitesse_max_tortue = str2num(vitesse_max_tortue);
% Récupération des dimensions de la matrice
[nb_ligne_matr,nb_colonne_matr] = size(matrice);

while (modif == 1)
	modif = 0;
	% Pour chaque loc (sauf les deux premières)
	for i=3:nb_ligne_matr
		if(matrice(i, col_flag) ~= 0)
			continue
		end

		% point précedent valable
		prec = find(matrice(1:i-1,col_flag) == 0);
		if (isempty(prec) || length(prec)<2) % il faut au moins 2 mesures avant
			continue;
		end
		prec = max(prec);

		% point suivante sans flag
		suiv = min (find(matrice(i+1:end, col_flag)==0));
		if(isempty(suiv)) %dernière valeur valide
			break;
		end
		suiv = suiv + i;

		lat_preced = matrice(prec,col_lat1);
		lon_preced = matrice(prec,col_lon1);

		% Récupérer la latitude et la longitude courante
		lat = matrice(i,col_lat1);
		lon = matrice(i,col_lon1);

		% Récupérer la date de l'obs précédente
		jour_preced = matrice(prec,col_jour);
		seconde_preced = matrice(prec,col_sec);

		% Récupérer la date de l'obs courante
		jour = matrice(i,col_jour);
		seconde = matrice(i,col_sec);

		instant1 = conv_jour2seconde(jour_preced) + seconde_preced;
		instant2 = conv_jour2seconde(jour) + seconde;

		% On calcule la vitesse
		temp = vitesse(lat_preced,lon_preced,lat,lon,instant1,instant2);

		% Si la vitesse de la tortue est excessive
		% Alors il faut analyser quelle loc il faut éliminer
		if temp > vitesse_max_tortue
			modif = 1 ;
			% Récupérer les classes de loc et les erreurs
			classe_preced = matrice(prec,col_lc);
			classe = matrice(i,col_lc);

			% Si la loc precedente est de moins bonne classe et que la
			% meilleure est superieure a 0 (les classes de loc ne renseignent 
			% sur l'erreur que quand leur valeur est positive)
			if classe_preced < classe && classe > 0
				% ==> on elimine la loc précédente
				matrice(prec, col_flag) = 3;
			
 			elseif (classe_preced > classe && classe_preced >0)
 				% ==> on elimine la loc courant
 				matrice(i, col_flag) = 3;
			% Sinon
			else
				% Si les deux classes sont identiques
				if (~(classe_preced > classe && classe_preced > 0)) && (i < nb_ligne_matr)
					% On calcule les vitesses precedentes et
					% suivantes

					% Récupérer la date de l'obs precedente preced

					prec2 = find(matrice(1:prec-1,col_flag) == 0);
					if (isempty(prec2))
						continue;
					end
					prec2 = max(prec2);

					jour_preced_preced = matrice(prec2,col_jour);
					seconde_preced_preced = matrice(prec2,col_sec);

					% Récupérer la date de l'obs précédente
					jour_preced = matrice(prec,col_jour);
					seconde_preced = matrice(prec,col_sec);

					instant3 = conv_jour2seconde(jour_preced_preced) + seconde_preced_preced;
					instant4 = conv_jour2seconde(jour_preced) + seconde_preced;

					% Si les locs on ete effectuées a des instants differents
					if instant3 ~= instant4
						% Calculer la vitesse précédente
						vitesse1 = vitesse(matrice(prec2,col_lat1),matrice(prec2,col_lon1),matrice(prec,col_lat1),matrice(prec,col_lon1),instant3,instant4);
					else
						vitesse1 = 0;
					end

					% Récupérer la date de l'obs suivante
					jour_suiv = matrice(suiv,col_jour);
					seconde_suiv = matrice(suiv,col_sec);

					instant5 = conv_jour2seconde(jour_suiv) + seconde_suiv;

					% Si les locs on ete effectuées a des instants differents
					if instant2 ~= instant5
						% Calculer la vitesse suivante
						vitesse2 = vitesse(lat,lon,matrice(suiv,col_lat1),matrice(suiv,col_lon1),instant2,instant5);
					else
						vitesse2 = 0;
					end

					% Si la vitesse précédente est supérieure à la
					% suivante
					if vitesse1 >= vitesse2
						% On remplace la location précédente par la location
						% courante 
						% on élimine la location précédente
						matrice(prec,col_flag) = 3;
 					else % sinon on élimine la courante
 						matrice(i, col_flag) = 3; 
					end

				end
				
			end
		end
	end
end  % while modif
