function [str_date] = jourjul2jourgreg(jourjul)

%   jourjul2jourgreg(jourjul) converti un jour julien en date au formal
%   JJ.MM.AAAA
%
%   INPUT PARAMETERS:
%   JOUR_JULIEN_CNES: Jour Julien CNES
%  
%   RETURN PARAMETERS:
%   DATE: Date au format JJ.MM.AAAA
%
%   EXAMPLE:
%   [JOUR_JULIEN_CNES]=jourjul2jourgreg(20699);
%
%   SEE ALSO:
%   http://www.jason.oceanobs.com/html/donnees/tools/jjtocd_fr.html
%   Utilitaire utilisé pour vérifier le bon fonctionnement de la routine
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005



str_date = datestr(jourjul + datenum('01-jan-1950'), 'dd.mm.yyyy');


% % Quantiemes dans l'annee pour les annees bissextiles et non bissextiles
% jk_Quantiemes = {31,60,91,121,152,182,213,244,274,305,335, 366 ; ...
%                  31,59,90,120,151,181,212,243,273,304,334, 365};
% 
% temp = floor(jourjul/365);
% % Compter le nombre d'année bissextile depuis 1950
% 
% nb_annees_bissextiles = 0;
% for i=1950:(temp+1950)
%     nb_annees_bissextiles = nb_annees_bissextiles + is_bissextile(i);
% end
%            
% annee = (1950 + floor((jourjul-nb_annees_bissextiles)/365));
% 
% str_annee = num2str (annee);
% 
% if (annee < 10)
%     str_annee = strcat('0', str_annee);
% end
% 
% % Verifier si l'année traitée est une année bissextile
% if is_bissextile(annee) == 1
%     indice_bis = 1;
% else
%     indice_bis = 2;
% end
% 
% reste = jourjul - floor((jourjul-nb_annees_bissextiles)/365)*365 - nb_annees_bissextiles+1;
% 
% for (i=1:12)
%     if ( reste <= cell2mat(jk_Quantiemes(indice_bis, i)));
%         mois = i;
%         break;
%     end
% end
%    
% str_mois = num2str(mois);
% if (mois<10)
%     str_mois = strcat('0', str_mois);
% end
% 
% if (mois > 1)
%     jour = reste - cell2mat(jk_Quantiemes(indice_bis, mois-1))+ is_bissextile(annee+2000);
% else
%     jour = floor(reste);
% end
% 
% str_jour = floor(num2str(jour));
% if (jour < 10)
%     str_jour = strcat('0', str_jour); 
% end
% 
% str_date = strcat(str_jour, '.',str_mois, '.', str_annee);
% 
% 
