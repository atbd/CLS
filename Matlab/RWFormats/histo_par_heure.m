
function histo_par_heure (inputDir,outFile),


% 'tag','jour julien','temps','LC','IQ', ...
%                    'lat1','lon1','lat2','lon2',...
%                    'Nb mes','Nb mes > -120','Best Level',...
%                     'Pass duration','NOPC',...
%                    'freq','Altitude'};

ini_col_tag = 1;
ini_col_jour = 2;
ini_col_time = 3;
ini_col_Nbmes = 10;
ini_col_bl = 12;

col_tag = 1;
col_time = 2;
col_jour = 2;
col_Nbmes = 3;
col_bl = 4;

[matData] = Dir_ReadAllDiag (inputDir);

mat_heure = [matData(:,ini_col_tag) floor(matData(:,ini_col_time)/3600) ...
        matData(:,ini_col_Nbmes) matData(:,ini_col_bl)];

res_heure = zeros(24,6);    
        
for (i=0:23)
   temp = mat_heure(find(mat_heure(:,col_time) == i),:);
   res_heure(i+1,1) = i;
   if (~isempty(temp))
       res_heure(i+1,2) = length(temp(:,col_tag));
       res_heure(i+1,3) = mean(temp(:,col_Nbmes));
       res_heure(i+1,4) = std (temp(:,col_Nbmes));
       res_heure(i+1,5) = mean(temp(:,col_bl));
       res_heure(i+1,6) = std (temp(:,col_bl)); 
   end
end
     

mat_jour = [matData(:,ini_col_tag) matData(:,ini_col_jour) ...
        matData(:,ini_col_Nbmes) matData(:,ini_col_bl)];


mat_jour(:,col_jour) = weekday( mat_jour(:,col_jour) + datenum('01-01-1950'));

    
res_jour = zeros(7,6);  
 for (i=1:7)
    temp = mat_jour(find(mat_jour(:,col_jour) == i),:);
    res_jour(i,1) = i;
   if (~isempty(temp))
       res_jour(i,2) = length(temp(:,col_tag));
       res_jour(i,3) = mean(temp(:,col_Nbmes));
       res_jour(i,4) = std (temp(:,col_Nbmes));
       res_jour(i,5) = mean(temp(:,col_bl));
       res_jour(i,6) = std (temp(:,col_bl)); 
   end
 end




if (exist('outFile', 'var'))
    if (exist(outFile)); delete(outFile); end;
    
    
    % heures
    xlswrite(outFile, {'Histogramme par heure'}, 1, 'A1');
    xlswrite(outFile, {'Nb mess', ' ', 'Best Level'}, 1,'C3');
    xlswrite(outFile, {'heure', 'Nb rec.', 'Moyenne', 'Ecart Type', 'Moyenne', 'Ecart Type'}, 1, 'A4');
    xlswrite(outFile, res_heure, 1, 'A5');
    
    % jours
     xlswrite(outFile, {'Histogramme par jour'}, 1, 'A31');
    xlswrite(outFile, {'Nb mess', ' ', 'Best Level'}, 1,'C33');
    xlswrite(outFile, {'jour', 'Nb rec.', 'Moyenne', 'Ecart Type', 'Moyenne', 'Ecart Type'}, 1, 'A34');
    xlswrite(outFile, {'Dimanche';'Lundi';'Mardi';'Mercredi';'Jeudi';'Vendredi'; 'Samedi'}, 1, 'A35');
    xlswrite(outFile, res_jour(:,2:end), 1, 'B35');
   
    
    
end
       
        
return;
     

