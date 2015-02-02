function nb_secondes = conv_jour2seconde(nb_jour)
% NB_SECONDES=CONV_JOUR2SECONDE(NB_JOUR) convertit un nombre de jour en
%   nombre de secondes
%   INPUT PARAMETERS:
%   NB_JOUR: Nombre de jours à convertir
%  
%   RETURN PARAMETERS:
%   NB_SECONDES: Nombre de secondes correspondant au nombre de jours passé
%               en entrée
%
%   EXAMPLE:
%   NB_SECONDES=CONV_JOUR2SECONDE(12);
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

nb_secondes = 24*3600*nb_jour;