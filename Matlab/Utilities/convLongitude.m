function [dataValide, strValue] = convLongitude(strLon)
%
%   [dateValide, , strValue] = convLongitude(strLon)   
%
%   Function pour la conversion des données de longitude de Est/Oest(W)
%   à des valeurs numériques entre -180 et 180. Si la donnée n'est
%   pas valide (valeur vide ou contant le caracter '?'), la fonction
%   renvoi une valeur vide. 
%
%   INPUT:
%   strLon : Valeur en format string de la longitude
%
%   OUTPUT:
%   dateValide : false si la valeur d'entrée n'est pas une valeur valide.
%   strValue : Valeur convertie de la longitude
%
%   AUTHOR  :   BCA
%   DATE    :   06/2006

    dataValide = true;
    if (~isempty(strfind(strLon,'?')) || (strcmp(strLon , '')) || (isempty(strLon)))
            dataValide = false;
            strValue = '';
        else
            if (strfind(strLon,'E'))
                strValue = str2num(strrep(char(strLon), 'E', ''));
            else
                if (findstr(strLon,'W'))
                    strValue = (-1) * str2num(strrep(char(strLon), 'W', ''));
                else
                    strValue = str2num(strLon);
                    if (strValue > 180)
                        strValue = strValue - 360 ;
                    end
                end
            end
    end    
    
