function vit = vitesse(lat1,lon1,lat2,lon2,tps1,tps2)
% VIT=VITESSE(LAT1,LON1,LAT2,LON2,TPS1,TPS2) renvoie la vitesse moyenne en 
%   cm/s pour parcourir la distance entre les deux points
%   INPUT PARAMETERS:
%   LAT1: Latitude du point de départ
%   LON1: Longitude du point de départ
%   LAT2: Latitude du point d'arrivée
%   LON2: Longitude du point d'arrivée
%   TPS1: Instant de départ en seconde
%   TPS2: Instant d'arrivée en seconde
%  
%   RETURN PARAMETERS:
%   VIT: Vitesse en cm/s pour parcourir la distance entre les deux points
%
%   EXAMPLE:
%   VIT=VITESSE(5.7461,306.0658,5,7477,306.0572,1577268747,1577314597);
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005


if tps2 ~= tps1
    vit = distance_cls([lat1,lon1],[lat2,lon2]) * 1000 / (tps2 - tps1)*100;
else
    vit = 0;
end
