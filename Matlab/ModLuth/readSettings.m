function readSettings (handles)

% readSettings (handles)
%
% cette function permet de recuperer les valeurs de différents paramètres
% utilisés dans l'interface ModLut.
%
% Paramètres:
% - Repertoire avec les données d'entrée
% - Répertoire pour sauvegarder les fichiers de sortie.
% - Fichier de paramètres de traitement.
%
% AUTEUR : Beatriz Calmettes
% DATE	 : novembre 2006


inDir = getParamValue2('settings.xml', 'settings/inputDir', 'c:\');
outDir =  getParamValue2('settings.xml', 'settings/outputDir', 'c:\');
paramFile = getParamValue2('settings.xml', 'settings/paramFile', 'c:\');

set(handles.str_input, 'String',char(inDir));
set(handles.str_OutDir, 'String',char(outDir) );
set(handles.str_ParamFile, 'String',char(paramFile));