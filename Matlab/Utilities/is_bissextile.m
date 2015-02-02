function bis = is_bissextile(annee)
% BIS=IS_BISSEXTILE(ANNEE) retourne 1 si l'année passée en argument est une
%   année bissextile, 0 sinon.
%   INPUT PARAMETERS:
%   ANNEE: Année sur 4 digits
%  
%   RETURN PARAMETERS:
%   BIS: 1 si l'année est bissextile, 0 sinon
%
%   EXAMPLE:
%   BIS=IS_BISSEXTILE(2005);
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005


warning off all
try
bis = 0;
temp = int16(annee/4) * 4;
if temp == annee
    bis = 1;
end
temp = int16(annee/100) * 100;
if bis == 1 && temp == annee
    bis = 0;
end
temp = int16(annee/400) * 400;
if bis == 0 && temp == annee
    bis = 1;
end
catch
    disp(lasterr);
end
warning on all