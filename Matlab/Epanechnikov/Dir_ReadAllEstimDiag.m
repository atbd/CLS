function [data] = Dir_ReadAllEstimDiag (inputDir, OutFile)

inputDir(end+1) = '\';
listfiles = dir([inputDir '*.diag']);

listDiag = dir([inputDir '*.DIAG']);
[nbfiles tmp] = size(listDiag);
if(nbfiles == 0)
    msgbox ('pas de fichiers diag dans le répertoire');
    res = false;
    return;
end

data = [];

for (i=1:nbfiles)
    matData=[];
  
    filename = [inputDir listDiag(i).name];
    disp(filename);
    
    %matData  = ReadAllDiag(filename);
    matData = estimateLoc (filename);
    data = [data; matData];
end

% ecrire

if ( exist('OutFile','var'))
   
    try
        if (exist(OutFile) == 2); delete(OutFile);end
        labels = {'tag','jour julien','temps','LC','IQ', ...
                   'lat1','lon1','lat2','lon2',...
                   'Nb mes','Nb mes > -120','Best Level',...
                    'Pass duration','NOPC',...
                   'freq','Altitude'};
               
         xlswrite(OutFile, labels, 1 , 'A2');
        xlswrite(OutFile, data, 1 , 'A3');
    catch
        disp(lasterr);
    end
end
    
