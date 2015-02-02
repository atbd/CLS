function  strLC = loc2str (intLC)
%
%   strLC = loc2str (intLC)
%
%   Fonction de convertion pour les données de localisation:
%   Si LC = -1  ==> 'A'
%   Si LC = -2  ==> 'B'
%   Si LC = -9  ==> 'Z'
%
%   INPUT:
%   intLC : Valeur numerique de la localisation
% 
%   OUTPUT:
%   strLC : Valeur convertie de la classe de localisation (LC)
%
%   AUTEUR  :   BCA
%   DATE    :   10/2006

 
switch (intLC)
	case (-1)
		strLC = 'A';
	case (-2)
		strLC = 'B';
	case (-9)
		strLC = 'Z';
	case(0)
		strLC = '0';
	case (1)
		strLC = '1';
	case (2)
		strLC = '2';
	otherwise
		strLC = 'Z';
end
    
   
