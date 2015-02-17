function res = epanechnikov(pt_estim,pt_donnee,taille_demi_fen)
% RES=EPANECHNIKOV(PT_ESTIM,PT_DONNEE,TAILLE_FEN) fournit le resultat de
%   de l'application de la fonction d'Epanechnikov
%
%   INPUT PARAMETERS:
%   PT_ESTIM: point en cours d'estimation (point au centre de la fenetre)
%   PT_DONNEE: point dont on cherche le poids
%   TAILLE_DEMI_FEN: taille de la demi fenetre
%  
%   RETURN PARAMETERS:
%   RES = poids de pt_donnée calculé avec la fonction (noyau)
%   d'Epanechnikov
%
%   SEE ALSO: S. BESNARD, Manuel utilisateur des programmes de formatage et
%   de filtrage/lissage des données Argos, CLS, 2005
%
% Ce "filtrage" des valeurs non comprises dans la fenetre doit etre fait
% avant l'appel de cette fonction mais il est plus prudent de la conserver
% ici aussi...
%
%   AUTEUR  :   Julien VANDERSTRAETEN
%   DATE    :   08/2005



% Si le point est compris dans la fenetre
 if abs(pt_estim-pt_donnee) < taille_demi_fen
     res = (3/4) * (1/taille_demi_fen) * (1 - ((pt_estim-pt_donnee) / taille_demi_fen)^2);
 % Sinon
 else
     res = 0;
 end

