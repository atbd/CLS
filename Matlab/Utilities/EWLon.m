function strLON = EWLon ( floatLON)
%
%  strLON = EWLon ( floatLON)
%
%  renvoie la valeur de longitude en format string, en format Est/West
%
%	INPUT :
%	floatLAT : valeur en format float de la longitude
%
%	OUTPUT : 
%	strLAT : valeur en format string de la longitude
%
%	AUTEUR :	BCA
%	DATE :		10/2006

strEnd = 'E';
if (floatLON < 0)
	strEnd = 'W';
end

val = abs(floatLON);

space = '';
if (val<10)
	space = ' ';
end

if (val == 9999)
	strLON = '???????';
else
	strLON = sprintf('%s%2.3f%s',space, val, strEnd);
end