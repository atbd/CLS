function infos_utiles = attribut_flag(infos_utiles,matrice_points_conserves,flag)
% ATTRIBUT_TRAJ(INFOS_UTILES,MATRICE_POINTS_CONSERVES,FLAG)
%   Cette fonction permet d'analyser les diff�rences entre les deux
%   matrices et d'attribuer un flag au point appartenant a la premi�re
%   matrice et pas � la seconde. La valeur de ce flag est elle aussi pass�e
%   en param�tre.
%
%   INPUT PARAMETERS:
%   INFOS_UTILES: Premi�re matrice
%   MATRICE_POINTS_CONSERVES: Deuxi�me matrice (ressemblante � la premi�re
%   mais avec des points qui on �t� elimin�s)
%   FLAG: Valeur du flag a attribuer pour les points appartenant � la
%   premi�re matrice mais pas � la seconde
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

% Instancier les variables utiles
col_jour = 1;
col_s = 2;
col_lc = 3;
col_lat1 = 4;
col_lon1 = 5;
col_lat2 = 6;
col_lon2 = 7;
col_flag = 8;

% R�cup�rer la taille des deux matrices
[nb_lig_infos_utiles,nb_col_infos_utiles] = size(infos_utiles);
[nb_lig_matrice_points_conserves,nb_col_matrice_points_conserves] = size(matrice_points_conserves);

% Pour chaque ligne de la matrice contenant toutes les infos
for i=1:nb_lig_infos_utiles
    % Bool�en permettant de savoir si on a retrouve le point dans la
    % matrice ne contenant que les points a conserver
    point_retrouve = 0;
    
    jour = infos_utiles(i,col_jour);
    s = infos_utiles(i,col_s);
    lat = infos_utiles(i,col_lat1);
    lon = infos_utiles(i,col_lon1);
    
    % Pour chaque ligne de la matrice contenant les points � conserver
    for j=1:nb_lig_matrice_points_conserves
        % Si le point est identique � celui de la matric contenant tous les
        % points
        if (matrice_points_conserves(j,col_jour) == jour) && ...
                (matrice_points_conserves(j,col_s) == s) && ...
                (matrice_points_conserves(j,col_lat1) == lat) && ...
                (matrice_points_conserves(j,col_lon1) == lon)
            % On met le bool�en a 1 pour indiquer qu'on a retrouve le
            % point
            point_retrouve = 1;
            
            % On arrete le parcours puisqu'on a retrouv� le point. On peut
            % donc passer au suivant
            break
        end
    end
    
    % Si on n'a pas retrouve le point
    if point_retrouve == 0
        % Si il n'y a pas deja un flag pour ce point
        if infos_utiles(i,col_flag) == 0
            % Mettre un flag au point
            infos_utiles(i,col_flag) = flag;
        end
    end
end