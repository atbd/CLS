function str_heure = sec2heure(str_secondes)
%
%   str_heure = sec2jour(str_secondes) convertit un nombre de secondes en
%   format: HH:MM:SS
%
%   INPUT :
%   str_secondes : Nombre de secondes en format string
%  
%   OUTPUT :
%   str_heure : string avec le temps
%   
%   AUTHOR  :   BCA
%   DATE    :   06/2006

secondes = str2num(char(str_secondes));

if isempty(secondes)
   str_heure = '00:00:00';
   return;
end

heure = floor(secondes/3600);
secondes = secondes - heure*3600;
str_heure = num2str(heure);
if heure < 10
    str_heure = strcat('0',str_heure);
end
 
minutes = floor(secondes/60);
str_minutes = num2str(minutes);
if  minutes < 10
    str_minutes = strcat('0', str_minutes);
end

secondes = secondes - minutes*60;
str_secondes = num2str(secondes);
if secondes < 10
    str_secondes = strcat('0', str_secondes);
end

str_heure = strcat(str_heure, ':', str_minutes, ':', str_secondes);

