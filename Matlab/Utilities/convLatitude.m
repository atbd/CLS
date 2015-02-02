function [dataValide, latValue] = convLatitude(strLat)
%
%   [dataValide, latValue] = convLatitude(strLat)
%
%   Function pour la conversion des données de latitude de Nort/Sud a des
%   valeurs numériques entre -180 et 180. Si la donnée n'est
%   pas valide (valeur vide ou contant le caracter '?'), la fonction
%   renvoi une valeur vide. 
%
%   INPUT:
%   strLat : Valeur en format string de la latitude
%
%   OUTPUT:
%   dateValide : false si la valeur d'entrée n'est pas une valeur valide.
%   strValue : Valeur convertie de la latitude
%
%   AUTHOR  :   BCA
%   DATE    :   06/2006

    dataValide = true;
    if (~isempty(strfind(strLat,'?')) || (strcmp(strLat , '')) || (isempty(strLat)))
            dataValide = false;
            latValue = '';
        else
            if (findstr(strLat,'N'))
                latValue = str2num(strrep(char(strLat), 'N', ''));
            else
                if(strfind(strLat,'S'))
                    latValue = (-1) * str2num(strrep(char(strLat), 'S', ''));
                else
                    latValue = str2num(strLat);
                    if (latValue > 180)
                        latValue = strValue - 360;
                   end
                end
            end
    end