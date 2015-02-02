function  [dataValide, lcValue] = convLocation (str_lc, wrongValue)
%
%   [dataValide, lcValue] = convLocation (str_lc, wrongValue)
%
%   Fonction de convertion pour les données de localisation:
%   Si LC = 'A' ==> -1
%   Si LC = 'B' ==> -2
%   Si LC = 'Z' ==> -9
%
%   Pour tenir en compte aussi les valeurs du paramètre NQ du format expert
%   Si NQ = -1, -2, -3, -4, LC = 'Z' ==> -9
%   Si NQ = -6, -7, LC = 'A' ==> -1
%   Si NQ = -8, LC = 'B' ==> -2
%
%   Pour tout autre cas, la fonction renvoi wrongValue
%
%   INPUT:
%   str_lc : Valeur en format string de la localisation
%   wrongValue: Valeur de sortie dans le cas d'une valeur de localisation
%   non valide.
%
%   OUTPUT:
%   dateValide : false si la valeur d'entrée n'est pas une valeur valide.
%   lcValue : Valeur convertie de la classe de localisation (LC)
%
%   AUTEUR  :   BCA
%   DATE    :   06/2006

    dataValide = true;
    
    if (strcmp(str_lc ,'A'))
        lcValue = -1;
        return
    end    
    if (strcmp(str_lc , 'B'))
        lcValue = -2;
        return;
    end  
    if (strcmp(str_lc , 'Z'))
        lcValue = -9;
        return
    end
    if ((strcmp(str_lc , '0')) || ...
        (strcmp(str_lc , '1')) || ...
        (strcmp(str_lc , '2')) || ...
        (strcmp(str_lc , '3')) )
            lcValue = str2num(char(str_lc));
            return
    end
    
    
    % pour tenir en compte les valeurs du format expert
    
    if ((strcmp(str_lc, '-1')) ||(strcmp(str_lc, '-2')) || (strcmp(str_lc, '-3')) ||(strcmp(str_lc, '-4')))
         lcValue = -9; % 'Z'
         return;
    end  
   
    if ((strcmp(str_lc, '-6')) || (strcmp(str_lc, '-7')))
         lcValue = -1; % 'A';
         return;
     end
     if (strcmp(str_lc, '-8'))
         lcValue = -2; % 'B';
         return;
     end

    
    lcValue = wrongValue;
    dataValide = false;
