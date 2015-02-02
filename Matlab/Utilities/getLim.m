function [latLim, lonLim] = getLim(matrice, col_lat, col_lon)
%   
%   [latLim, lonLim] = getLim(matrice, col_lat, col_lon)
%
%   Renvoie les limites de longitude et latitude d'une matrice (comprisses
%   entre -180 et 180)
%
%   INPUT:
%   matrice :   Matrice de données
%   col_lat :   Colonne avec les valeurs de latitude
%   col_lon :   Colonne avec les valeurs de longitude
%
%   OUTPUT:
%   latLim :    [Latitude minimale , Latitude maximale]
%   lonLim :    [Longitude minimale, Longitude maximale]
%   
%   AUTHOR  :   BCA
%   DATE    :   06/2006

    minlat = min(matrice(:,col_lat));
    minlat = minlat - 1;
    if (minlat < -180)
        mintlat = -180;
    end
    
    maxlat = max(matrice(:,col_lat));
    maxlat = maxlat + 1;
    if (maxlat > 180)
		maxlat = 180;
    end

    minlon = min(matrice(:,col_lon));
    minlon = minlon - 1;
%     if (minlon < -180)
%         minlon = -180;
%     end
    maxlon = max(matrice(:,col_lon));
    maxlon = maxlon + 1;
%     if (maxlon > 180)
% 		maxlon = 180;
%     end    
    
    latLim = [minlat maxlat];
    lonLim = [minlon maxlon];