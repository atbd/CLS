function matrice = combler_trous(matr_estim1,matr_estim2,pas_echantillonnage)
% MATRICE = COMBLER_TROUS(MATR_ESTIM1,MATR_ESTIM2,PAS_ECHANTILLONNAGE)
%   comble les "trous" dans la trajectoire. Les trous correspondent à des
%   endroits ou aucune estimation n'a été calculé à cause d'un trop petit
%   nombre de données
%
%   INPUT PARAMETERS:
%   MATR_ESTIM1: Matrice correspondant aux localisations après la
%               suppression des outliers
%   MATR_ESTIM2: Matrice correspondant aux localisations après la deuxième
%               estimation (lissage et réechantillonnage)
%   PAS_ECHANTILLONNAGE: Pas d'echantillonage de la deuxième matrice
%
%   OUTPUT PARAMETERS:
%   MATRICE: Matrice résultante. Dans les "trous" on calcule un troncon de
%           trajectoire en ligne droite
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

% Initialisation des variables du programme
Tps = 1;
Lat = 2;
Lon = 3;
NQ = 4;

% Récupérer la taille de la matrice
[nb_lig_matr_estim1,nb_col_matr_estim1] = size(matr_estim1);
[nb_lig_matr_estim2,nb_col_matr_estim2] = size(matr_estim2);

cpt=1;

% Recopier la premiere loc
matrice(1,:) = matr_estim2(1,:);

% Pour chaque loc. (sauf la première)
for i=2:nb_lig_matr_estim2
    % Si il y a un "trou" dans l'echantillonnage
    if (matr_estim2(i,Tps) - matr_estim2(i-1,Tps)) > pas_echantillonnage
        % Pour chaque estimation manquante dans cette intervalle
        for j=pas_echantillonnage:pas_echantillonnage:(matr_estim2(i,Tps) - matr_estim2(i-1,Tps) - 1)
            tps_esti = j + matr_estim2(i-1,Tps);
            lat1 = matrice(cpt,Lat);
            lon1 = matrice(cpt,Lon);
            tps1 = matrice(cpt,Tps);
            
            % Trouver le point suivant dans la premiere estimation (sans
            % les outliers). L'indice de ce point est donné par k
            for k=1:nb_lig_matr_estim1
                if matr_estim1(k,Tps) > tps_esti
                    if matr_estim1(k,Tps) < matr_estim2(i,Tps)
                        % Si ce point est d'une assez bonne qualité
                        if (matr_estim1(k,NQ) >= 1)
                            lat2 = matr_estim1(k,Lat);
                            lon2 = matr_estim1(k,Lon);
                            tps2 = matr_estim1(k,Tps);
                        % Sinon
                        else
                            lat2 = matr_estim2(i,Lat);
                            lon2 = matr_estim2(i,Lon);
                            tps2 = matr_estim2(i,Tps);
                        end
                    % Sinon
                    else
                        lat2 = matr_estim2(i,Lat);
                        lon2 = matr_estim2(i,Lon);
                        tps2 = matr_estim2(i,Tps);
                    end
                    break
                end
            end

            % Calcul des coeffs de la droite (a_lat et b_lat) pour la latitude
            a_lat = (lat2 - lat1) / (tps2 - tps1); 
            b_lat = (lat1 * tps2 - lat2 * tps1) / (tps2 - tps1); 
            
            % Calcul des coeffs de la droite (a_lon et b_lon) pour la longitude
            a_lon = (lon2 - lon1) / (tps2 - tps1); 
            b_lon = (lon1 * tps2 - lon2 * tps1) / (tps2 - tps1); 

            esti_lat = a_lat * tps_esti + b_lat;
            esti_lon = a_lon * tps_esti + b_lon;
            
            cpt=cpt+1;
            matrice(cpt,1:3) = [(matr_estim2(i-1,Tps)+j) esti_lat esti_lon];
            % Flag pour preciser que ce n'est pas une estimation
            matrice(cpt,4) = 1;
        end
        cpt = cpt+1;
        matrice(cpt,1:3) = matr_estim2(i,1:3);
        % Flag pour preciser que ce n'est pas une estimation
        matrice(cpt,4) = 1;
    % Sinon on recopie simplement l'observation d'origine
    else
        cpt = cpt+1;
        matrice(cpt,1:3) = matr_estim2(i,1:3);
        % Flag pour preciser que c'est une estimation
        matrice(cpt,4) = 0;
    end
end

% Verifier que la courbe ne s'arrete pas avant la fin car on n'a pas pu
% estimer les derniers points
% Si il manque effectivement des points
if (matr_estim1(nb_lig_matr_estim1,Tps) - matr_estim2(nb_lig_matr_estim2,Tps)) > pas_echantillonnage
    for j=pas_echantillonnage:pas_echantillonnage:(matr_estim1(nb_lig_matr_estim1,Tps) - matr_estim2(nb_lig_matr_estim2,Tps))
        tps_esti = j + matr_estim2(nb_lig_matr_estim2,Tps);
        lat1 = matrice(cpt,Lat);
        lon1 = matrice(cpt,Lon);
        tps1 = matrice(cpt,Tps);

        % Trouver le point suivant dans la premiere estimation (sans
        % les outliers). L'indice de ce point est donnée par k
        for k=1:nb_lig_matr_estim1
            if matr_estim1(k,Tps) > tps_esti
                lat2 = matr_estim1(k,Lat);
                lon2 = matr_estim1(k,Lon);
                tps2 = matr_estim1(k,Tps);
                break
            end
        end

        % Calcul des coeffs de la droite (a et b) pour la latitude
        a_lat = (lat2 - lat1) / (tps2 - tps1);
        b_lat = (lat1 * tps2 - lat2 * tps1) / (tps2 - tps1);

        % Calcul des coeffs de la droite (a et b) pour la longitude
        a_lon = (lon2 - lon1) / (tps2 - tps1);
        b_lon = (lon1 * tps2 - lon2 * tps1) / (tps2 - tps1);

        esti_lat = a_lat * tps_esti + b_lat;
        esti_lon = a_lon * tps_esti + b_lon;

        cpt=cpt+1;
        matrice(cpt,1) = tps_esti;
        matrice(cpt,2) = esti_lat;
        matrice(cpt,3) = esti_lon;
        % Flag pour preciser que ce n'est pas une estimation
        matrice(cpt,4) = 1; 
    end
end