function [res, balise, reference, textheader, readData, line1, line2, line3] = readResults( inputFile )
%
%	[res, inData] = readResults( inputFile )
%
%	Permet de lire les donn�es de trajectoire d'un fichier en format TEXT. 
%
%	balise	:	Le num�ro de la balise Argos
%	reference :	R�ference de la tortue (si elle existe)
%   param 1:
%   param 2
%
%	Les donn�es doivent �tre imp�rativement dans cet ordre dans le fichier
%
%   INPUT :
%   inputFile : Fichier avec les donn�es en format TEXT
%
%   OUTPUT :
%   res : faux s'il y a eu de probl�mes dans la lecture du fichier
%	balise : le num�ro de la balise
%	reference : la r�f�rence de la tortue
%   textheader
%   inData : matrice avec les donn�es.
%
%	AUTEUR :	BCA
%	DATE :		10/2006

res = true;

% V�rifier que le fichier existe
if (exist (inputFile) == 0)
    res = false;
	balise = '';
	reference = '';
    readData = [];
    line1=''; line2=''; line3=''
    msg = strcat ('impossible de trouver le fichier "', inputFile, '"');
    msgbox (msg);
    return
end

try
    [temp balise] = textread(inputFile, '%s\t%s',1);
    [temp reference] = textread(inputFile, '%s\t%s',1, 'headerlines', 1) ;  
    line1 =char(textread(inputFile, '%s', 1,'delimiter', '\n','headerlines', 2));
    line2 =char(textread(inputFile, '%s', 1,'delimiter', '\n','headerlines', 3));
    line3 =char(textread(inputFile, '%s', 1,'delimiter', '\n','headerlines', 4));
    
    balise=char(balise);
    reference = char(reference);
    fid = fopen(inputFile);
    
    readData  = cell2mat(textscan(fid,'',-1,'headerlines',6));
    fclose(fid);
  
    textheader = textread(inputFile, '%s',size(readData,2), 'delimiter','\t', 'headerlines', 5) ; 
    
catch
	res = false;
	return;
end

