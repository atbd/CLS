function matrice = correction_mat_choix_loc(matrice)
%   [MATRICE, idx] =CORRECTION_MAT_CHOIX_LOC( MATR) corrige les erreurs de choix de loc
%   dans la matrice passée en paramètre.

%   INPUT PARAMETERS:
%   MATR: matrice contenant les infos
%  
%   RETURN PARAMETERS:
%   MATRICE =	matrice représentant les données corrigées dans la matrice
% 
%   EXAMPLE:
%   A=CORRECTION_MAT_CHOIX_LOC(M);
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005
%
%	Modification : la vérification de doublons se fait appart pour
%	l'indiquer dans le flag des valeurs initiales. Le calcul de valeurs
%	précedentes et suivantes de localisation doit s'effectuer en tenant
%	compte du flag.
%
%	AUTEUR	:	BCA
%	DATE	:	10/2006



% Initialisation des variables du programme
lat1 = 5;
lon1 = 6;
lat2 = 7;
lon2 = 8;
col_flag = 9;

    
nbpoints = find(matrice(:,col_flag) == 0);
if length(nbpoints) < 3
	return; % rien à changer
end

[nb_ligne_matrice,nb_colonne_matrice] = size(matrice);



modif = true;

% Tant que des modif ont été effectuées a la passe preliminaire
while modif == true
    modif = false;  
    % On ne traite pas la premiere localisation, on passe directement à la
    % deuxième
    for i=2:(nb_ligne_matrice-1)

		if (matrice(i, col_flag) ~=0)
			continue;
		end
		
		% point précédent sans flag
		prec = max(find(matrice(1:i-1,col_flag) == 0));
		if (isempty(prec)) 
			continue;
		end;
		
		% point suivante sans flag
		suiv = min (find(matrice(i+1:end, col_flag)==0));
		if(isempty(suiv)) %dernière valeur valide
			break;
		end
		suiv = suiv +i;

		
        coord_precedent = [matrice(prec,lat1), matrice(prec,lon1)];
        coord_courant =   [matrice(i,lat1),matrice(i,lon1)];    
        coord_image =     [matrice(i,lat2), matrice(i,lon2)];
        coord_suivante =  [matrice(suiv,lat1),matrice(suiv,lon1)];

        % Incrémenter le nombre de positions valides
       
        dist_courante = distance(coord_precedent,coord_courant) + distance(coord_courant,coord_suivante);
        dist_image = distance(coord_precedent,coord_image) + distance(coord_image,coord_suivante);
        
        % Si la distance est pus courte en passant par la loc image
        if dist_courante > dist_image
            temp_image = coord_image;
            modif = true;         
            % Echanger les valeur des loc
            matrice(i,lat1) = coord_image(1);
            matrice(i,lon1) = coord_image(2);
            matrice(i,lat2) = coord_courant(1);
            matrice(i,lon2) = coord_courant(2);
        end
    end
end

