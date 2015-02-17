function estim = z_estimation(matr)


taille_demi_fen=43200;
taille_demi_fen_max=86400;
nb_pt_demi_fen=2;
min_estim1=2;

col_date = 1 ;
col_time = 2 ;
col_lc = 3;
col_lat1 = 5 ;
col_lon1 = 6 ;

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
             if  matr(j,col_lc) == -10; continue; end;
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
        estim(i,1:2)=[date(i,1) sol_lat];   
        sol_lon = eye(1,2)*(inv(X'*Ka*X))*(X'*Ka*Y_lon);
        estim(i,3)=sol_lon;
        
		dist(cpteur_estim,1) = distance([estim(cpteur_estim, 2) estim(cpteur_estim, 3)], ...
									  [matr(i, col_lat1), matr(i, col_lon1)]);

    else
        estim(i,1:2)=[date(i,1) matr(i,col_lat1);];  
        estim(i,3)=matr(i,col_lon1);   
        
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

estim(:,4) = matr(:,3);
