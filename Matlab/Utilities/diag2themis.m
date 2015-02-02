function diag2themis(diagFile, themisFile)

%diagFile =  'C:\Data\DEPE\Originales\DIAG\25532.diag'
addpath('..\RWFormats')
[res, balise, reference, readData] = readDiag (diagFile);

readData(find(readData(:,3)==-9) ,:) =[];
readData(find(readData(:,1)==9999) ,:) =[];
readData(find(readData(:,2)==9999) ,:) =[];

readData(:,9)=0;
inData = correction_mat_choix_loc(readData);

for i=1:size(inData,1)
   outData(i,1:6)= datevec(datestr(datenum('01-01-1950')+inData(i,1) + inData(i,2)/24/60/60));
end

outData(:,7)=inData(:,6);
outData(:,8)=inData(:,5);
outData(1:6)=round(outData(1:6));

for i=1:size(outData,1)
    % date
    str_month=num2str(cast(outData(i,2), 'int16'));
    if outData(i,2)<10; str_month=['0' str_month]; end;
    str_day=num2str(cast(outData(i,3), 'int16'));
    if outData(i,3)<10; str_day=['0' str_day]; end;
    %time
    str_h=num2str(cast(outData(i,4), 'int16'));
    if outData(i,4)<10; str_h=['0' str_h]; end;
    str_m=num2str(cast(outData(i,5), 'int16'));
    if outData(i,5)<10; str_m=['0' str_m]; end;
    str_s=num2str(cast(outData(i,6), 'int16'));
    if length(str_s)==1; str_s=['0' str_s]; end;

    if strfind(str_s, '.')>0
        disp('')
    end
    if i==1
        str = sprintf('%s/%s/%d %s:%s:%s;%3.1f;%3.1f;ignored;ignored;\n',...
             str_day, str_month, outData(i,1), ...
             str_h, str_m, str_s, outData(i,7), outData(i,8));
    else
        str = sprintf('%s%s/%s/%d %s:%s:%s;%3.1f;%3.1f;ignored;ignored;\n',...
             str, str_day, str_month, outData(i,1), ...
             str_h, str_m, str_s, outData(i,7), outData(i,8));
    end
end


try
    fid = fopen (themisFile, 'w');
    fwrite(fid, str);
    fclose(fid);

catch
    disp(lasterr)
    fclose('all')
end

return