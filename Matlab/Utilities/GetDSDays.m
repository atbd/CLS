function [dsdays dsvalues] = GetDSDays (inFile, initday)

%   [dsdays dsvalues] = GetDSDays
%
%   DESCRIPTION: cette fonction renvoi les jour de transmission d'une
%   balise argos a partir d'un fichier en format DS
%
%   INPUT : 
%   inFile  :   Le nom du fichier en format DS
%   initDay :   la première date à considérer.
%
%   OUTPUT : 
%   dsdays  :   Le nombre de jours de transmission
%   dsvalues:   La liste des jours de transmission
%
%   EXEMPLE :
%   [dsdays, dsvalues] = GetDSDays('C:\Data\68379.DS', '06-25-2006')
%   dsdays = 3
%   dsvalues = [04-Apr-2007; 05-Apr-2007;06-Apr-2007]
%
%   AUTHEUR : BCA
%   DATE    : nov 2006


inMatrix = textread(inFile, '%s');
nb_lines = length(inMatrix);
j=1;

% la ligne contenant la date doit contenir 2 '-'
for (i=1:nb_lines)
	if (length(find(inMatrix{i} == '-')) == 2)
		strdate = char(inMatrix{i});
		dsvalues(j) = datenum(str2num(strdate(1:4)), str2num(strdate(6:7)), ...
			   str2num(strdate(9:10)));
		j = j+1;
	end
end


dsvalues = unique(dsvalues);
if(exist('initday', 'var'))
    dsvalues = dsvalues(find (dsvalues>(datenum(initday))));
end
dsvalues = datestr(dsvalues);
[dsdays b] = size(dsvalues);


