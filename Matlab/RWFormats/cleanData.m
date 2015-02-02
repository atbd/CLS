function outputMatrix = cleanData (inputMatrix)
%
% outputMatrix = cleanData (inputMatrix)
%
% cleanData :   Function pour enlever les lignes contenant des valeurs non 
%               valides pour la localisation dans la matrice de données 
%               brutes
%
%   INPUT:
%   inputMatrix : Matrice avec les données brutes
%
%   OUTPUT:
%   outputMatrix : Matrice sans les valeurs non valides
%
%   AUTHOR  :   BCA
%   DATE    :   06/2006

col_lc = 3;
col_lat1 = 5 ;
col_lon1 = 6 ;
col_lat_image = 7 ;
col_lon_image = 8 ;

wrongValue = 9999;

i = 1;
[nblines, nbcol] = size(inputMatrix);

while (true)
    if ( (inputMatrix(i, col_lat1)) == wrongValue || ...
         (inputMatrix(i, col_lon1)) == wrongValue || ...
         (inputMatrix(i, col_lat_image)) == wrongValue || ...
         (inputMatrix(i, col_lon_image)) == wrongValue )
     
     inputMatrix (i,:)=[];
     [nblines, nbcol] = size(inputMatrix);
    else
        if (inputMatrix(i, col_lc) == wrongValue)
            % cette valeur correspond à LC  = Z
            inputMatrix(i, col_lc) = -9;
        end
        i = i+1;
    end
    
    if (i>nblines)
        break;
    end
    
end

inputMatrix(find(inputMatrix(:,col_lat1)==0 & inputMatrix(:,col_lon1)==0), col_lc)= -9;
%inputMatrix(find(inputMatrix(:,col_lat_image)==0 & inputMatrix(:,col_lon_image)==0 ), col_lc)= -9;

outputMatrix = inputMatrix;
clear inputMatrix;
