function [jour_julien_cnes] = conv_jourgreg2jourjul(date)
% [JOUR_JULIEN_CNES]=CONV_JOURGREG2JOURJUL(DATE) convertit une date en un jour
%   julien CNES
%   INPUT PARAMETERS:
%   DATE: Date au format JJ/MM/AAAA
%  
%   RETURN PARAMETERS:
%   JOUR_JULIEN_CNES: Jour Julien CNES
%
%   EXAMPLE:
%   [JOUR_JULIEN_CNES]=CONV_JOURGREG2JOURJUL('14/03/2005');
%
%   SEE ALSO:
%   http://www.jason.oceanobs.com/html/donnees/tools/jjtocd_fr.html
%	http://www.aviso.oceanobs.com/fr/donnees/boite-a-outils/jours-calendaires-ou-jours-juliens/index.html
%   Utilitaire utilisé pour vérifier le bon fonctionnement de la routine
%
%   AUTHOR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005

[str_jour,date] = strtok(date,'/'); 
[str_mois,date] = strtok(date,'/');
[str_annee,date] = strtok(date,'/');

 jour = str2num(char(str_jour));
 mois = str2num(char(str_mois));
 annee = str2num(char(str_annee));

if (annee < 100) % que 2 chiffres
	if (annee < 50 && annee >=0 )	
		annee = annee + 2000;
	else
		annee = annee + 1900;	% entre 1950 et 1999
	end
end

jour_julien_cnes = datenum(annee, mois, jour) - datenum('01-jan-1950');

% % Quantiemes dans l'annee pour les annees bissextiles et non bissextiles
% jk_Quantiemes = {0,31,60,91,121,152,182,213,244,274,305,335 ; 0,31,59,90,120,151,181,212,243,273,304,334};
% 
% % nombre de jours dans le mois pour les annees bissextiles et non bissextiles */
% jk_NbJoursMois = {31,29,31,30,31,30,31,31,30,31,30,31 ; 31,28,31,30,31,30,31,31,30,31,30,31};
% 

% jour = str2num(char(str_jour));
% mois = str2num(char(str_mois));
% 
% annee = str2num(char(str_annee));
% 
% if (annee < 100) % que 2 chiffres
% 	if (annee < 50 && annee >=0 )	
% 		annee = annee + 2000;
% 	else
% 		annee = annee + 1900;	% entre 1950 et 1999
% 	end
% end
% 
% nb_annees_bissextiles = 0;
% % Compter le nombre d'année bissextile depuis 1950
% for i=1950:(annee-1)
%     nb_annees_bissextiles = nb_annees_bissextiles + is_bissextile(i);
% end
% 
% % Verifier si l'année traitée est une année bissextile
% if is_bissextile(annee) == 1
%     indice_bis = 1;
% else
%     indice_bis = 2;
% end
% tmp_quantiemes = jk_Quantiemes(indice_bis,mois);
% 
% jour_julien_cnes = ((annee - 1950) * 365) + nb_annees_bissextiles + tmp_quantiemes{1} + jour - 1;

