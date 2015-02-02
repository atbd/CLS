function dist = distance_cls(coord1, coord2)
% DIST=DISTANCE(coord1,coord2) renvoie la distance en km entre deux 
%   points dont les coordonn�es sont pass�s en param�tres
%   INPUT PARAMETERS:
%   coord1: Latitude et longitude du point de d�part
%   coord2: Latitude et Longitude du point d'arriv�e
%  
%   RETURN PARAMETERS:
%   DIST: Distance en km entre les deux points
%
%   EXAMPLE:
%   coord1 = [5.7461,306.0658]
%   coord2 = [5.7477,306.0572]
%   DIST=DISTANCE(coord1, coord2);
%
%   SEE ALSO:
%   http://www.ign.fr/telechargement/FAQ/FAQ11.doc pour plus d'informations
%   sur le calcul de la distance entre deux points dont les coordonn�es
%   sont donn�s sous forme latitude/longitude
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

% rayon  moyen de la terre
R = 6378.137;  % sph�re  GRS80 
%R = 6371.598; %  sph�re de Picard 
latitude = 1;
longitude = 2;

delta_lat = coord1(latitude) - coord2(latitude);
delta_lon = coord1(longitude) - coord2(longitude);

if delta_lat == 0 && delta_lon == 0
    dist = 0;
else
    a = acos(sin(coord1(latitude)*pi/180) * sin(coord2(latitude)*pi/180) + ...
		cos(coord1(latitude)*pi/180) * cos(coord2(latitude)*pi/180) * ...
		cos(delta_lon*pi/180));
    dist = R * a;
end
