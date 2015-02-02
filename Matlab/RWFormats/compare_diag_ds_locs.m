function compare_diag_ds_locs (diagfile, dsfile, outfile);



% colonnes à la lecture initiale
% col_date = 1 ;
% col_time = 2 ;
% col_lc = 3 ;
% col_freq = 4;
% col_lat1 = 5 ;
% col_lon1 = 6 ;
% col_lat_image = 7 ;
% col_lon_image = 8 ;
[res, balise_diag, reference_diag, mat_diag] = readDiag (diagfile);
[res, balise_ds, reference_ds, mat_ds] = readDS (dsfile);

if (balise_diag ~= balise_ds)
    msgbox(['Erreur !! balise ds : ' balise_ds  ' balise diag ' balise_diag]);
    return;
end

col_date = 1;
col_time = 2;
col_lc_ds = 3;
col_lat_ds = 4;
col_lon_ds = 5;
col_lc_diag = 6;
col_lat1_diag = 7;
col_lon1_diag = 8;
col_lat2_diag = 9;
col_lon2_diag = 10;


resMat(:,col_date:col_time) = mat_diag(:,1:2);
resMat(:,col_lc_diag)= mat_diag(:,3);
resMat(:,col_lat1_diag:col_lon2_diag) = mat_diag(:,5:8);

[nl_ds, nc_ds] = size(mat_ds);

for(i=1:nl_ds)
    p = find(resMat(:,col_date) == mat_ds(i,1) & (resMat(:,col_time) == mat_ds(i,2)));
    if (~isempty(p))
        resMat(p,col_lc_ds) = mat_ds(i,3);
        resMat(p, col_lat_ds:col_lon_ds) = mat_ds(i,5:6);
    else
        disp('il manque une date dans le fichier DIAG');
    end
    
end

if (exist(outfile)==2)
    delete(outfile);
end

xlswrite(outfile, {balise_diag},1, 'A2');

header = {'Date', 'Time', 'DS lc', 'DS lat', 'DS lon', 'DIAG lc', ...
          'DIAG lat1', 'DIAG lon1', 'DIAG lat2', 'DIAG lon2'};

 
xlswrite(outfile, header,1, 'A4');
          
xlswrite(outfile, resMat,1, 'A5');
disp('ok');


