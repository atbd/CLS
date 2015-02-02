function writeSettings (handles)

% writeSettings (handles)
%
% cette function permet de mettre � jour le fichier settings.xml avec les 
% valeurs de diff�rents param�tres utilis�s dans l'interface ModLut.
%
% Param�tres:
% - Repertoire avec les donn�es d'entr�e
% - R�pertoire pour sauvegarder les fichiers de sortie.
% - Fichier de param�tres de traitement.
%
% AUTEUR : Beatriz Calmettes
% DATE	 : novembre 2006


inDir = get(handles.str_input, 'String');

if (exist(inDir, 'dir') ~=7 )  % ce n'est pas un r�pertoire
	inDir = fileparts(inDir);
end

outDir = get(handles.str_OutDir, 'String' );
paramFile = get(handles.str_ParamFile, 'String');

% le r�pertoire d'entr�e
docNode = com.mathworks.xml.XMLUtils.createDocument('settings');
docRootNode = docNode.getDocumentElement;

thisElement = docNode.createElement('inputDir');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',inDir)));
docRootNode.appendChild(thisElement);

% le r�pertoire de sortie
thisElement = docNode.createElement('outputDir');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',outDir)));
docRootNode.appendChild(thisElement);

% le fichier de param�tres
thisElement = docNode.createElement('paramFile');
thisElement.appendChild...
        (docNode.createTextNode(sprintf('%s',paramFile)));
    docRootNode.appendChild(thisElement);	
	
xmlwrite('settings.xml',docNode);
