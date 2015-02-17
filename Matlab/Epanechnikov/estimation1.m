function estim = estimation1(matr,taille_demi_fen,taille_demi_fen_max,nb_pt_demi_fen,min_estim1)
% [ESTIM_FIN,TAILLE_FEN]=ESTIMATION1(MATR,TAILLE_DEMI_FEN,NB_PT_DEMI_FEN,MIN_ESTIM1)
%   Effectue la regression linéaire permettant de faire une première
%   estimation pour ensuite éliminer les outliers
%  
%   INPUT PARAMETERS:
%   MATR: Matrice contenant les informations nécessaires au calcul de la
%   régression (Temps, latitude, longitude)
%   TAILLE_DEMI_FEN: Taille de la demi fenêtre de départ
%   TAILLE_DEMI_FEN_MAX: Taille max de la demi fenêtre
%   NB_PT_DEMI_FEN: Nb de points minimum dans chaque demi fenêtre pour
%   pouvoir calculer la régression linéaire
%   MIN_ESTIM1: Nombre de point minimum dans la fenetre pour pouvoir
%   realiser l'estimation
%  
%   RETURN PARAMETERS:
%   ESTIM_FIN: Matrice contenant le résultat de la regression linéaire
% 
%   SEE ALSO:
%   EPANECHNIKOV
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

% Initialisation des variables du programme

col_date = 1 ;
col_time = 2 ;
col_lat1 = 5 ;
col_lon1 = 6 ;
col_flag = 9;

% enlever de la matrice les points avec flag >0
matr = matr(find(matr(:,col_flag) ==0),:);

estim = [];

% Compteur du nombre d'estimations effectuées
cpteur_estim = 0;
cpt_pt = 0;

% Constante de conversion pour passer des jours aux secondes
cte_conv_jour2sec = 24*60*60;

% Nombre de points dans la fenetre = nb_pt_demi_fen * 2 + 1
nb_pt_fen = nb_pt_demi_fen * 2 + 1;

% Récupération de la taille de la matrice passée en entrée
[nb_lig_matr, nb_col_matr] = size(matr);

% On garde la valeur de la taille de la demi fenetre dans une variable
taille_demi_fen_save = taille_demi_fen;

% Initialisation de la premiere case des ecarts à 0
ecart_cumule(1,1) = 0;

% Initialisation de la première case des dates
date(1,1) = (matr(1,col_date) * cte_conv_jour2sec) + matr(1,col_time);

% Calcul des ecarts de temps (en secondes) entre chaque mesure
for i=2:nb_lig_matr
    ecart_cumule(i,1) = ecart_cumule(i-1,1) + ((matr(i,col_date) - matr(i-1,col_date)) * cte_conv_jour2sec) + (matr(i,col_time) - matr(i-1,col_time));
    date(i,1) = (matr(i,col_date) * cte_conv_jour2sec) + matr(i,col_time);
end


deuxieme_temps = ecart_cumule(2,1);
av_dernier_temps = ecart_cumule(end-1,1);
repartition_pt_ok = 0;
pas_estim = 0;

% Pour chaque localisation
for i=1:nb_lig_matr

    % Tant qu'on a pas le nombre de points souhaités dans la fenêtre ou
    % qu'on n'a pas les points repartis correctement dans les demi fenetres
    % ou qu'on a pas detecté une impossibilité d'estimer
    while (repartition_pt_ok == 0) && (pas_estim == 0)
        cpt_pt = 0;
        % Compteur du nombre de points dans la demi fenetre de gauche
        cpt_pt_gauche = 0;
        % Compteur du nombre de points dans la demi fenetre de droite
        cpt_pt_droite = 0;
       
        % Pour chaque localisation
        for j=1:nb_lig_matr
             % Si elle est comprise dans la fenetre
             if (ecart_cumule(j,1) > (ecart_cumule(i,1) - taille_demi_fen)) && (ecart_cumule(j,1) < (ecart_cumule(i,1) + taille_demi_fen))
                % Incrémentation du compteur de nombre de points dans la
                % fenetre
                cpt_pt = cpt_pt+1;
                % Construction des matrices X et K
                K(cpt_pt,1) = epanechnikov(ecart_cumule(i,1),ecart_cumule(j,1),taille_demi_fen);
                X(cpt_pt,1:2) = [1 (ecart_cumule(j,1) - ecart_cumule(i,1))];
                Y_lat(cpt_pt,1) = matr(j,col_lat1);
                Y_lon(cpt_pt,1) = matr(j,col_lon1);
                
                % Si le point est dans la demi fenetre de droite
                if (ecart_cumule(j,1) - ecart_cumule(i,1)) > 0
                    cpt_pt_droite = cpt_pt_droite + 1;
                else
                    cpt_pt_gauche = cpt_pt_gauche + 1;
                end
             else
                % Si on a depassé la demi fenetre de droite
                if ecart_cumule(j,1) - ecart_cumule(i,1) > taille_demi_fen
                    % On arrete de chercher
                    break;
                end
             end
        end
        
        % Si la fenetre "dépasse" a gauche ou a droite
        if ((ecart_cumule(i,1)-taille_demi_fen) <= deuxieme_temps) || ((ecart_cumule(i,1) + taille_demi_fen) >= av_dernier_temps)
            % On ne peut pas calculer d'estimation
            pas_estim = 1;
        else
            % Si les points sont correctement repartis et que l'on en a 
            % assez dans la fenetre
            if (cpt_pt_droite >= nb_pt_demi_fen) && (cpt_pt_gauche >= nb_pt_demi_fen) && (cpt_pt >= min_estim1)
                repartition_pt_ok = 1;
            % Sinon
            else
                % Agrandissement de la taille de la demi fenetre de 1/2h
                taille_demi_fen = taille_demi_fen + 1800;
                % Si la taille de la demi fenetre est superieure a la
                % taille max autorisée
                %if taille_demi_fen > taille_demi_fen_max
                    % On ne peut pas calculer d'estimation
                    %pas_estim = 1;
                %end
            end
        end
    end

    % Restauration de la valeur initial de la demi fenetre
    taille_demi_fen = taille_demi_fen_save;
    
    % On incremente le compteur du nombre d'estimation
   % cpteur_estim = cpteur_estim + 1;

    % Si on doit faire une estimation
    if pas_estim == 0
		
		cpteur_estim = cpteur_estim + 1;

        % Calcul de la regression linéaire
        Ka = diag(K);
    
        sol_lat = eye(1,2)*(inv(X'*Ka*X))*(X'*Ka*Y_lat);
        estim(cpteur_estim,1:2)=[date(i,1) sol_lat];   
        sol_lon = eye(1,2)*(inv(X'*Ka*X))*(X'*Ka*Y_lon);
        estim(cpteur_estim,3)=sol_lon;
		
		dist(cpteur_estim,1) = distance([estim(cpteur_estim, 2) estim(cpteur_estim, 3)], ...
									  [matr(i, col_lat1), matr(i, col_lon1)]);

    end

    % Réinitialisation des matrices permettant de faire le calcul de la
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
