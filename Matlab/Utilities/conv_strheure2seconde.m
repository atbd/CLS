function [secondes] = conv_strheure2seconde(heure)
% [SECONDES]=CONV_STRHEURE2SECONDE(HEURE) convertit une heure en un nombre
%   de secondes
%   INPUT PARAMETERS:
%   HEURE: Heure au format HH:MM:SS
%  
%   RETURN PARAMETERS:
%   SECONDES: Nombre de secondes dans le jour
%
%   EXAMPLE:
%   [SECONDES]=CONV_HEURE2SECONDE('20:01:54');
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005



[str_heure,minute] = strtok(heure,':');
[str_minute,seconde] = strtok(minute,':');
[str_seconde,seconde] = strtok(seconde,':');

temp = 0;

if (length(str_seconde) == 5)
	if upper(str_seconde(4:5)) == 'PM'
		temp = 12*60*60;
	end
	str_seconde = str_seconde(1:2);
end

	
secondes = 3600*str2num(char(str_heure)) + 60*str2num(char(str_minute)) + str2num(char(str_seconde)) + temp;