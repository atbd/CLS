function h = histo_bestlevel(inputDir)

col_tag = 1 ;
col_jour = 2 ;
col_time = 3;
col_lc = 4;
col_IQ = 5;
col_lat1 = 6;
col_lon1 = 7;
col_lat2 = 8;
col_lon2 = 9;
col_nbmess = 10;
col_nbmess120 = 11;
col_bestlevel = 12;
col_pasduration = 13;
col_NOPC = 14;
col_freq =15;
col_altitude = 16;
wrongValue = 9999;

Data = Dir_ReadAllDiag (inputDir);

Data(find(Data(:,col_lat1) == wrongValue), :) =[]  ;
Data(find(Data(:,col_lon1) == wrongValue), :) =[]  ;
Data(find(Data(:,col_lat2) == wrongValue), :) =[]  ;
Data(find(Data(:,col_lon2) == wrongValue), :) =[]  ;

%h = hist(Data(:,col_bestlevel), min(Data(:,col_bestlevel)):2:max(Data(:,col_bestlevel)));

bestlevel = Data(:,col_bestlevel);
bestlevel (find(bestlevel == 0)) = [];

%vect = floor(min(bestlevel)):2:ceil(max(bestlevel));
vect = -140:2:-116;
a = hist(bestlevel, vect);

b = a/sum(a)*100;
%if (afficher ==  true)
%     figure; bar([min(vect):2:max(vect)], b)
%     title('bestlevel (%)');
%end
 h = [vect' a' b'];
