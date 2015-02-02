function  nq = lc2nq (lc)
%
%    nq = lc2nq (lc)
%
%   Fonction de convertion pour les données de localisation de LC 
%	(format DIAG) à NQ (format expert):
%   Si LC = -1 ==> -6
%   Si LC = -2 ==> -8
%   Si LC = -9 ==> -4
%
%   INPUT:
%   lc : Valeur de la classe de localisation
%
%   OUTPUT:
%   nq : valeur de NQ
%
%   AUTEUR  :   BCA
%   DATE    :   10/2006

nq = lc;  

switch (lc)
	case (-1)
		nq = -6;
	case (-2)
		nq = -8;
	case (-9)
		nq = -4;
end