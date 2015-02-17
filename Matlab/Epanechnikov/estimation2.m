function estim_fin = estimation2(matr,taille_demi_fen,taille_demi_fen_max,nb_pt_demi_fen,pas_echantillonnage,min_estim2)
% [ESTIM_FIN,TAILLE_FEN]=ESTIMATION2(MATR,TAILLE_DEMI_FEN,NB_PT_DEMI_FEN,PAS_ECHANTILLONNAGE,MIN_ESTIM2)
%   Effectue la regreesion linéaire permettant de réechantillonner le tracé
%  
%   INPUT PARAMETERS:
%   MATR: Matrice contenant les informations nécessaires au calcul de la
%   régression (Temps, latitude, longitude)
%   TAILLE_DEMI_FEN: Taille de la demi fenêtre de départ
%   NB_PT_DEMI_FEN: Nb de points minimum dans chaque demi fenêtre pour
%   pouvoir calculer la régression linéaire
%   PAS_ECHANTILLONNAGE: Pas d'echantillonnage (ou periode) souhaitée
%   MIN_ESTIM2: Nombre minimum de point dans la fenetre pour pouvoir
%   realiser l'estimation
%  
%   RETURN PARAMETERS:
%   ESTIM_FIN: Matrice contenant le résultat de la regression linéaire
% 
%   SEE ALSO:
%   EPANECHNIKOV
%   COMBLER_TROUS
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005


% Initialisation des variables du programme
col_tps = 1;
col_lat = 2;
col_lon = 3;
col_lc = 4;

% Compteur du nombre d'estimations effectuées
cpteur_estim = 0;
cpt_pt = 0;

% Constante de conversion pour passer des jours aux secondes
cte_conv_jour2sec = 24*60*60;

% Nombre de points dans la fenetre = nb_pt_demi_fen * 2 + 1
nb_pt_fen = nb_pt_demi_fen * 2;

% Récupération de la taille de la matrice passée en entrée
[nb_lig_matr,nb_col_matr] = size(matr);

% On garde la valeur de la taille de la demi fenetre dans une variable
taille_demi_fen_save = taille_demi_fen;

% Initialisation de la premiere case des ecarts à 0
ecart_cumule(1) = 0;

% Calcul des ecarts de temps (en secondes) entre chaque mesure
for i=2:nb_lig_matr
    ecart_cumule(i,1) = ecart_cumule(i-1,1) + (matr(i,col_tps) - matr(i-1,col_tps));
end

deuxieme_temps = ecart_cumule(2,1);
av_dernier_temps = ecart_cumule(end-1,1);
repartition_pt_ok = 0;

% On incremente le compteur du nombre d'estimation
cpteur_estim = cpteur_estim+1;

% Recopier le tout premier echantillon
estim(cpteur_estim,1) = matr(1,col_tps);
estim(cpteur_estim,2) = matr(1,col_lat);
estim(cpteur_estim,3) = matr(1,col_lon);
estim(cpteur_estim,4) = 0;

pas_estim = 0;

% Pour chaque echantillon
for i=pas_echantillonnage:pas_echantillonnage:ecart_cumule(end,1)
    while (repartition_pt_ok == 0) && (pas_estim == 0)
        cpt_pt = 0;
        % Compteur du nombre de points dans la demi fenetre de gauche
        cpt_pt_gauche = 0;
        % Compteur du nombre de points dans la demi fenetre de droite
        cpt_pt_droite = 0;
        % Compteur de classe de localisation
        cpt_lc = 0;
        
        % Pour chaque localisation
        for j=1:nb_lig_matr
            % Si elle est comprise dans la fenetre
            if (ecart_cumule(j) > (i - taille_demi_fen)) && (ecart_cumule(j) < (i + taille_demi_fen))
                % Incrémentation du compteur de nombre de points dans la
                % fenetre
                cpt_pt = cpt_pt+1;
                % Construction des matrices X et K
                K(cpt_pt,1) = epanechnikov(i,ecart_cumule(j),taille_demi_fen);
                X(cpt_pt,1:2) = [1 (ecart_cumule(j) - i)];
                Y_lat(cpt_pt,1) = matr(j,col_lat);
                Y_lon(cpt_pt,1) = matr(j,col_lon);

                cpt_lc = matr(j,col_lc);
                
                % Si le point est dans la demi fenetre de droite
                if (ecart_cumule(j) - i) > 0
                    cpt_pt_droite = cpt_pt_droite + 1;
                % Sinon il est dans celle de gauche
                else
                    cpt_pt_gauche = cpt_pt_gauche + 1;
                end
            % Sinon
            else
                % Si on a depassé la demi fenetre de droite
                if ecart_cumule(j) - i > taille_demi_fen
                    % On arrete de chercher
                    break;
                end
            end
        end

        % Si la fenetre depasse a gauche ou a droite
        if ((i-taille_demi_fen) <= deuxieme_temps) || ((i + taille_demi_fen) >= av_dernier_temps)
            pas_estim = 1;
        % Sinon
        else
            % Si les points sont repartis correctement et qu'il y a
            % assez de points dans la fenetre
            if (cpt_pt >= min_estim2) && (cpt_pt_droite >= nb_pt_demi_fen) && (cpt_pt_gauche >= nb_pt_demi_fen)
                repartition_pt_ok = 1;
            % Sinon
            else
                % Agrandissement de la taille de la demi fenetre de 1h
                taille_demi_fen = taille_demi_fen + 1800;
                % Si la taille de la demi fenetre est superieure a la
                % taille max autorisée
                if taille_demi_fen > taille_demi_fen_max
                     if (cpt_pt_droite >= 1) && (cpt_pt_gauche >= 1) && (cpt_pt >= 2) || (i < deuxieme_temps) || (i > av_dernier_temps)
                        repartition_pt_ok = 1;
                     else
                        % On ne peut pas calculer d'estimation
                        pas_estim = 1;
                     end
                end
            end
        end
    end

    % Si on doit faire une estimation
    if pas_estim == 0
        % On incremente le compteur du nombre d'estimation
        cpteur_estim = cpteur_estim+1;

        % Calcul de la regression linéaire
        Ka = diag(K);
    
        sol_lat = eye(1,2)*(inv(X'*Ka*X))*(X'*Ka*Y_lat);
        estim(cpteur_estim,1:2)=[i+matr(1,col_tps) sol_lat];
        
        sol_lon = eye(1,2)*(inv(X'*Ka*X))*(X'*Ka*Y_lon);
        estim(cpteur_estim,3) = sol_lon;
    end

    % Restauration de la valeur initiale de la demi fenetre
    taille_demi_fen = taille_demi_fen_save;
    
    % Réinitialisation des matrices permettant de faire le calcul de
    % regression
    K = [];
    Ka = [];
    X = [];
    Y_lat = [];
    Y_lon = [];

    % Réinitialisation des compteurs
    repartition_pt_ok = 0;
    pas_estim = 0;
end

% On comble les trous ou l'estimation n'a pas été possible en approximant
% par une droite
estim_fin = estim;
estim_fin = combler_trous(matr,estim,pas_echantillonnage);