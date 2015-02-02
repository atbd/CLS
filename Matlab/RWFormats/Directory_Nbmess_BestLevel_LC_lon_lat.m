function [res data mesloc] =  Directory_Nbmess_BestLevel_LC_lon_lat (inputDir, afficher, outFile)

%   [res data mesloc] = Directory_Nbmess_BestLevel (inputDir, outFile)
%
%	Permet de lire les données de Nombre de messages et best level de 
%   d'un fichier en format Diag. 
%
%	balise	:	Le numéro de la balise Argos
%	data    :   Matrice de 4 colonnes, jour julien CNES, temps, 
%               nombre de messages et best level	
%
%	colonne 1  : jour julien
%	colonne 2  : temps en secondes
%	colonne 3  : nb messages
%	colonne 4  : Best level
%
%   INPUT :
%   inputDir    :   Répertoire avec les fichiers en format DIAG
%   outFile     :   Fichier avec les résultats
%
%   OUTPUT :
%   res : false s'il y a eu de problèmes dans la lecture du fichier
%   data : matrice avec les données.
%   
%   AUTEUR  :   BCA
%   DATE    :   06/2007


res = true;
data = [];
col_jour = 1;
col_balise=2;
col_nbmes = 3;
col_bestlevel=4;
col_lc = 5;
col_lon = 6;
col_lat = 7;


% Vérifier que c'est un répertorie
if (exist(inputDir) ~= 7)
    msgbox ('Ce n''est pas un repertoire');
    res = false;
    return;
end

% Vérifier le dernier caracter
if (inputDir(end)~='\' && inputDir(end) ~='/')
    inputDir(end+1)='\';
end


% Vérifier qu'il y a de fichiers DIAG dans le répertoire
listDiag = dir([inputDir '*.DIAG']);
[nbfiles tmp] = size(listDiag);
if(nbfiles == 0)
    msgbox ('pas de fichiers diag dans le répertoire');
    res = false;
    return;
end




% Recupération des données: Jour julien, balise, nbmess, bestlevel, lc
data = [];

for (i=1:nbfiles)
    matData=[];
    [res2, balise, matData]  = read_Nbmess_BestLevel_LC_lon_lat ([inputDir listDiag(i).name]);
    if (res2 == false)
        return;
    end;
    
    % Pour éliminer les registres correspondand à de tests. On considère 
    % qu'il doit avoir au moins une différence d'une semaine (7 jours)
    % entre les test et les mesures.
    dif = matData(2:end,col_jour) - matData(1:end-1,col_jour);
    ind = find(dif >7);
    if ~isempty(ind) matData = matData(ind+1:end,:); end
    
    matData(:,2) = str2num(balise);
    initjour = matData(1,col_jour);
    lastjour = matData(end,col_jour);
   
    for(j=initjour:lastjour)
        if isempty(find(matData(:,col_jour) == j))
            if (afficher == true)
                disp( [listDiag(i).name ' : ' datestr(j+datenum('01-01-1950')) ' (' num2str(j) ')' ]);
            end 
             matData(end+1,:) = [j str2num(balise)  0 0 NaN 0 0];
        end
    end
    data = [data; matData];
end
data = sortrows(data,[col_jour, col_balise]); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% histograme de nombre de messages ==> % de nombre de jours avec n messages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mes_jour_tag(:,1) = data(1, col_jour):1:data(end, col_jour);
% mes_jour_tag(:,2:3) = 0;
listtags = unique(data(:,col_balise));

k=1;
for (i = 1:length(listtags))
   temp_tag = data(find(data(:,col_balise) == listtags(i)),:);
   for (j = temp_tag(1, col_jour):temp_tag(end,col_jour))
       temp2 = temp_tag(find(temp_tag(:,col_jour) == j),:);
       if (~isempty(temp2))
          mestagjour = sum(temp2(:,col_nbmes));
           mes_jour_tag(k,1:3) = [listtags(i),j, mestagjour];
           k = k+1;
           
       end
   end
end

mes_jour_tag (find(mes_jour_tag(:,3)==0),:) = [];
mes_jour_tag(:,4) = floor(mes_jour_tag(:,3)/10);

for (i=1:20)
    hmess (i, 1)= i-1;
    hmess (i, 2) = length(find(mes_jour_tag(:,4) ==(i-1)));
end

%hmess = hist(mes_jour_tag(:,3), 0:10:190);
hmess(:,3) = hmess(:,2)/sum(hmess(:,2))*100;
moy_mes_jour_tag = (sum(mes_jour_tag(:,3))/length(mes_jour_tag));

if (afficher ==  true)
    figure;bar(0:10:190, hmess(:,3));
    str1 = 'Histogramme du nombre messages reçus par jour et par tag';
    str2 = 'Moyenne de messages reçus par jour et par tag';
    str3 = sprintf('%s\n%s (%6.2f )', str1, str2, moy_mes_jour_tag);
    title (str3);
end



 
 
 
 % Best level
 
bestlevel = data(:,col_bestlevel);
bestlevel (find(bestlevel == 0)) = [];

a = hist(bestlevel, ceil((max(bestlevel)-min(bestlevel)+1))/2);
b = a/sum(a)*100;
if (afficher ==  true)
    figure; bar([min(bestlevel):2:max(bestlevel)], b)
    title('bestlevel (%)');
end


% LC

l = data(:,col_lc);
l(find(isnan(l))) = [];
h  = hist(l, [-9:1:3]);
h = [h(1) h(end-5:end)];
h = h/sum(h)*100;
if (afficher == true)
    figure;
    bar(h);
    set(gca,'XTickLabelMode','manual')
    set(gca, 'XTickLabel',{'Z';'B';'A';'0';'1';'2';'3'})
    title ('Classe de loc (%)');
end


% moyenne de messages par loc
j=1;
for(i=[-9,-2,-1,0,1,2,3])
    mesloc(j,1) = i;
    mesloc(j,2) = sum(data(find(data(:,col_lc) == i),col_nbmes));
    mesloc(j,3) = mesloc(j,2)/length(find(data(:,col_lc)==i));
    j = j+1;
end

if (afficher == true)
    figure;
    bar(mesloc(:,3));
    set(gca,'XTickLabelMode','manual')
    set(gca, 'XTickLabel',{'Z';'B';'A';'0';'1';'2';'3'})
    title ('messages par classe de loc');
end


% bestlevel et loc

lon_lat_bl = [data(:,col_lon) data(:,col_lat) data(:,col_bestlevel) ];
lon_lat_bl(find(lon_lat_bl(:,1) == 9999),:) = [];
lon_lat_bl(find(lon_lat_bl(:,2) == 9999),:) = [];
lon_lat_bl(find(lon_lat_bl(:,3) == 0),:) = [];
% lon_lat_bl(find(lon_lat_bl(:,3) <= -135),4) = 1;
% lon_lat_bl(find(lon_lat_bl(:,3) > -135 & lon_lat_bl(:,3) <=  -130),4) = 2;
% lon_lat_bl(find(lon_lat_bl(:,3) > -130 & lon_lat_bl(:,3) <=  -125),4) = 3;
% lon_lat_bl(find(lon_lat_bl(:,3) > -125 & lon_lat_bl(:,3) <=  -120),4) = 4;
% lon_lat_bl(find(lon_lat_bl(:,3) > -120),4) = 5;
 
lon_lat_bl(find(lon_lat_bl(:,3) <= -130),4) = 1;
%lon_lat_bl(find(lon_lat_bl(:,3) > -130 & lon_lat_bl(:,3) <=  -125),4) = 2;
% lon_lat_bl(find(lon_lat_bl(:,3) > -130 & lon_lat_bl(:,3) <=  -125),4) = 3;
% lon_lat_bl(find(lon_lat_bl(:,3) > -125 & lon_lat_bl(:,3) <=  -120),4) = 4;
 lon_lat_bl(find(lon_lat_bl(:,3) > -130),4) = 2;


% plot avec bathy

addpath('..\Utilities\');

BATHY=MakeBATHY(-5, 40, 25, 55, 10800/2);
%BATHY=MakeBATHY(-95, -60, -40, -10, 10800/2); 

 coast = (BATHY.data > 0);
% figure;
% imcontour(BATHY.lon, BATHY.lat,coast,1, 'Color', [0.5 0.5 0.5]);
% axis xy;
% hold on;


color = [ [0 1 0];[1 0 0]; ];

%color = [ [1 0 0]; [1 0.4 0]; [1 1 0.2]; [0 1 0]; [0 0 1]];
for (k=1:2)
    figure;
    imcontour(BATHY.lon, BATHY.lat,coast,1, 'Color', [0.5 0.5 0.5]);
     axis xy;
    hold on;
    temp = lon_lat_bl(find(lon_lat_bl(:,4)==k),:);
    scatter(temp(:,1), temp(:,2), 'Marker', 'o', 'MarkerFaceColor', color(k,:), ...
		'MarkerEdgeColor', color(k,:));
    title(num2str(k));
end



if ( exist('outFile','var'))
   
    try
    
        
        if (exist(outFile) == 2); delete(outFile);end
        
        
        % histogramme nb messages
        xlswrite(outFile, {['Moyenne de messages/jour : ' num2str(moy_mes_jour_tag) ]},1, 'A2');
        xlswrite(outFile, {'tag', 'Jour', 'Nb mess'}, 1 , 'A4');
        xlswrite(outFile, mes_jour_tag (:,1:3), 1 , 'A5');

        xlswrite(outFile, {'histogramme'}, 1 , 'G2');
         xlswrite(outFile, {'range','nombre', '%'}, 1 , 'G4');
        labels = {'(0-9)';'(10-19)';'(20-29)';'(30-39)';'(40-49)';'(50-59)';'(60-69)'; ...
                   '(70-79)';'(80-89)';'(90-99)';'(100-109)';'(110-119)'; ...
                   '(120-129)';'(130-139)';'(140-149)';'(150-159)';'(160-169)';...
                   '(170-179)';'(180-189)';'(190-199)'};
         xlswrite(outFile, labels, 1 , 'g5');
        xlswrite(outFile,  hmess(:,2:3), 1 , 'h5'); 

         % Best level
         xlswrite(outFile, {'Best level'}, 2 , 'A2');
         xlswrite(outFile, {'Best level', 'nb', '%'}, 2 , 'A4');
         out = [(min(bestlevel):2:max(bestlevel))' a' b'];
         xlswrite(outFile, out, 2 , 'A5');
          
         % LC    
         xlswrite(outFile, {'LC'}, 3, 'A2');
           
         xlswrite(outFile, {'LC', '%'}, 3 , 'A4');
         labels = {'Z';'B';'A';'0';' 1';' 2';' 3'};
         xlswrite(outFile, labels, 3 , 'A5');
         xlswrite(outFile, h', 3 , 'B5');
        
        % tout
    %     xlswrite(outFile, {'Jour', 'temps (s)', 'Nb mess', 'BestLevel' , 'LC'}, 2 , 'A3');
    %     xlswrite(outFile, data, 2 , 'A4');
    
    catch
        disp(lasterr);
    end
end


 return;

