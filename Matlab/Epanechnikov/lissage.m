function [iniMatrix, outputMatrix, seuil_km, res] = lissage(iniMatrix, paramFile, name)
%   
%	[iniMatrix, outputMatrix] = lissage(iniMatrix, locMatrix, paramFile)
%  
%   INPUT :
%   inputMatrix :   Input matrix
%   locMAtrix   :   Matrix with location and speed correction
%   paramFile   :   Name of the parameter file (xml format)
%
%   OUTPUT :
%   iniMatrix   :  Input Matrix with the flag column updated
%   resMatrix   :  Result matrix after Epanechnikov filter. 
%   
%   AUTHOR  :   BCA
%   DATE    :   06/2006


% Read parameters
%demi_fen_min1
[demi_fen_min1 res] = getParamValue2 (paramFile, 'epan/demi_fenetre_min_estim1', '43200');
if (res == false) return; end;
demi_fen_min1 = str2num(demi_fen_min1);

%demi_fen_max1
demi_fen_max1 = getParamValue2 (paramFile, 'epan/demi_fenetre_max_estim1', '86400');
if (res == false) return; end;
demi_fen_max1 = str2num(demi_fen_max1);

%nb_pt_demi_fenetre_estim1
[nb_pt_demi_fenetre_estim1 res] = getParamValue2 (paramFile, 'epan/nb_pt_demi_fenetre_estim1', '2');
if (res == false) return; end;
nb_pt_demi_fenetre_estim1= str2num(nb_pt_demi_fenetre_estim1);

%min_estim1
[min_estim1 res] = getParamValue2 (paramFile, 'epan/min_estim1', '5');
if (res == false) return; end;
min_estim1= str2num(min_estim1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul de la première régression linéaire permettant d'eliminer les outliers  %   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

estim1 = estimation1(iniMatrix,demi_fen_min1,demi_fen_max1,nb_pt_demi_fenetre_estim1,min_estim1);

% On applique l'algo permmettant de supprimer les outliers

[ecart_max_pourcentage res] = getParamValue2 (paramFile, 'epan/ecart_max_pourcentage', '95');
if (res == false); return; end;
ecart_max_pourcentage = str2num(ecart_max_pourcentage);

[outputMatrix,iniMatrix, seuil_km] = elimination_outliers(estim1,iniMatrix,ecart_max_pourcentage);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                              %
% Calcul de la deuxième régression linéaire										%                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%demi_fenetre_min_estim2
[demi_fenetre_min_estim2 res] = getParamValue2 (paramFile, 'epan/demi_fenetre_min_estim2', '86400');
if (res == false); return; end;
demi_fenetre_min_estim2 = str2num(demi_fenetre_min_estim2);

%demi_fenetre_max_estim2
[demi_fenetre_max_estim2 res] = getParamValue2 (paramFile, 'epan/demi_fenetre_max_estim2', '86400');
if (res == false); return; end;
demi_fenetre_max_estim2 = str2num(demi_fenetre_max_estim2);

%nb_pt_demi_fenetre_estim2
[nb_pt_demi_fenetre_estim2 res] = getParamValue2 (paramFile, 'epan/nb_pt_demi_fenetre_estim2', '2');
if (res == false); return; end;
nb_pt_demi_fenetre_estim2 = str2num(nb_pt_demi_fenetre_estim2);

%periode
[periode res] = getParamValue2 (paramFile, 'epan/periode', '10800');
if (res == false); return; end;
periode = str2num(periode);

%min_estim2
[min_estim2 res] = getParamValue2 (paramFile, 'epan/min_estim2', '5');
if (res == false); return; end;
min_estim2 = str2num(min_estim2);


% On applique l'algo de calcul de la deuxième regression lineaire 
outputMatrix = estimation2(outputMatrix,demi_fenetre_min_estim2,demi_fenetre_max_estim2,...
                            nb_pt_demi_fenetre_estim2, periode,min_estim2);
res = true;


				