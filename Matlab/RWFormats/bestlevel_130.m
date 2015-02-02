

inputDir = 'C:\Data\ETTP\DIAG\';
bl = -130;

data = Dir_ReadAllDiag (inputDir);

data_res = [data(:,1:3) data(:,6:9) data(:,4) data(:,12:14) ];

data_inf = data_res(find(data_res(:,9)<bl),:);
data_sup = data_res(find(data_res(:,9)>=bl),:);

outfile_inf = [inputDir 'MED_bestlevelinf_130.xls'];
outfile_sup = [inputDir 'MED_bestlevelsup_130.xls'];

header = [{'ID'}, {'Date'}, {'Time'}, {'Lat1'}, {'Lon1'}, {'Lat2'}, ...
          {'Lon2'}, {'LC'}, {'Best Level'}, {'Pass Duration'}, {'NOPC'}];
          
xlswrite(outfile_inf, header);         
xlswrite(outfile_sup, header);  

xlswrite(outfile_inf, data_inf, 1, 'A2'); 
xlswrite(outfile_sup, data_sup, 1, 'A2'); 