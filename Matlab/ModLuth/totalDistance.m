function totalDist = totalDistance (inMatrix, col_lat, col_lon)
%
%  totalDist = totalDistance (inMatrix, col_lat, col_lon)
% 
%  Renvoie la distance total parcourue en kilomètres
%
%  INPUT
%  inMatrix : matrice avec les données
%  col_lat : colonne avec les valeurs de latitude
%  col_lon : colonne avec les valerus de longitude
%
%  OUTPUT 
%  totalDist : Distance totale
%
%   AUTHEUR	:   BCA
%   DATE    :   09/2006


[nblig nbcol] = size (inMatrix);

totalDist = 0;
for i=1:nblig-1
    c1 = [inMatrix(i,col_lat) inMatrix(i,col_lon)];
    c2 = [inMatrix(i+1,col_lat) inMatrix(i+1,col_lon)];
    totalDist = totalDist + distance_cls (c1,c2);
end
