function diag2dym(diagFile, outFile)

%diagFile =  'C:\Data\DEPE\Originales\DIAG\25532.diag'
addpath('..\RWFormats')
[res, balise, reference, readData] = readDiag (diagFile);

readData(find(readData(:,3)==-9) ,:) =[];
readData(find(readData(:,1)==9999) ,:) =[];
readData(find(readData(:,2)==9999) ,:) =[];

readData(:,9)=0;
inData = correction_mat_choix_loc(readData);

for i=1:size(inData,1)
   outData(i,2:7)= datevec(datestr(datenum('01-01-1950')+inData(i,1) + inData(i,2)/24/60/60));
end
outData(:,5:7)=[];
outData(:,5)=inData(:,6);
outData(:,6)=inData(:,5);

tamp = outData(:,2);
outData(:,2)= outData(:,4);
outData(:,4)= tamp;


outData(:,1)= outData(:,4)+ ...
(datenum(outData(:,4), outData(:,3), outData(:,2))-datenum(outData(:,4), 1, 1))/365;

try
    fid = fopen(outFile, 'w');
    fprintf(fid, '%4.3f\t%d\t%d\t%d\t%4.3f\t%4.3f\n', outData');
    fclose(fid);


catch
    disp(lasterr)
    fclose('all')
end

return