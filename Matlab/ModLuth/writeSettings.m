function writeSettings (handles)

% writeSettings (handles)
%
% cette function permet de mettre à jour le fichier settings.xml avec les 
% valeurs de différents paramètres utilisés dans l'interface ModLut.
%
% Paramètres:
% - Repertoire avec les données d'entrée
% - Répertoire pour sauvegarder les fichiers de sortie.
% - Fichier de paramètres de traitement.
%
% AUTEUR : Beatriz Calmettes
% DATE	 : novembre 2006


inDir = get(handles.str_input, 'String');

if (exist(inDir, 'dir') ~=7 )  % ce n'est pas un répertoire
	inDir = fileparts(inDir);
end

outDir = get(handles.str_OutDir, 'String' );
paramFile = get(handles.str_ParamFile, 'String');

% le répertoire d'entrée
docNode = com.mathworks.xml.XMLUtils.createDocument('settings');
docRootNode = docNode.getDocumentElement;

thisElement = docNode.createElement('inputDir');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',inDir)));
docRootNode.appendChild(thisElement);

% le répertoire de sortie
thisElement = docNode.createElement('outputDir');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',outDir)));
docRootNode.appendChild(thisElement);

% le fichier de paramètres
thisElement = docNode.createElement('paramFile');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',paramFile)));
    docRootNode.appendChild(thisElement);	
	
xmlwrite('settings.xml',docNode);
