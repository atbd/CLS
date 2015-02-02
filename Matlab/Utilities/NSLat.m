function strLAT = NSLat ( floatLAT )
%
%  strLAT = NSLat ( floatLAT )
%
%  renvoie la valeur de latitude en format string, en format Nord/Sud
%
%	INPUT :
%	floatLAT : valeur en format float de la latitude
%
%	OUTPUT : 
%	strLAT : valeur en format string de la latitude
%
%	AUTEUR :	BCA
%	DATE :		10/2006

strEnd = 'N';
if (floatLAT < 0)
	strEnd = 'S';
end

val = abs(floatLAT);

space = '';
if (val<10)
	space = ' ';
end

if (val == 9999)
	strLAT = '???????';
else
	strLAT = sprintf('%s%2.3f%s',space, val, strEnd);
end