function col = getcols(theader)


%  col = getcols(theader)
%
%  Cette fonction renvoie les numeros des colonnes pour les données
%  indiquées dans le header
%
%   INPUT PARAMETERS:
%   theader  :   vector d'en-tête
%  
%  
%   RETURN PARAMETERS:
%   col    :   structure avec les colonnes
% 
%  
%   AUTEUR  :   BCA
%   DATE    :   09/2007
%




col.Jour =0; col.EstimFlag=0; col.Lon=0; col.Lat=0; col.Ug=0; col.Vg=0;
col.Sg=0; col.Hg=0; col.Uc=0; col.Vc=0; col.Sc=0; col.Hc=0; col.Us=0;
col.Vs=0; col.Ss=0; col.Hs=0; col.FlagCourant=0; col.FlagDelay=0;
col.Xg=0; col.Yg=0; col.Xs=0; col.Ys = 0; col.Freq =0; col.LatCor = 0;
col.LonCor=0; col.Bathy=0; col.SST=0; col.chloro=0; col.Lat1=0; col.Lat2=0;
col.Lon1=0; col.Lon2=0; col.LC=0;



for(i=1:size(theader,1)) 
    if strcmp(char(theader{i}) , 'CNES Day')
        col.Jour = i;
    elseif strcmp(char(theader{i}), 'Estim_Flag')
        col.EstimFlag=i;
   elseif strcmp(char(theader{i}) , 'Lon')
        col.Lon = i;     
    elseif strcmp(char(theader{i}) , 'Lat')
        col.Lat = i;
    elseif strfind(char(theader{i}), 'Ug');
        col.Ug=i;
    elseif strfind(char(theader{i}), 'Vg');
        col.Vg=i;
    elseif strfind(char(theader{i}), 'Sg');
        col.Sg=i;
    elseif strfind(char(theader{i}), 'Hg');
        col.Hg=i;
    elseif strfind(char(theader{i}), 'Uc');
        col.Uc=i;
    elseif strfind(char(theader{i}), 'Vc');
        col.Vc=i;
    elseif strfind(char(theader{i}), 'Sc');
        col.Sc=i;
    elseif strfind(char(theader{i}), 'Hc');
        col.Hc=i;
    elseif strfind(char(theader{i}), 'Us');
        col.Us=i;
    elseif strfind(char(theader{i}), 'Vs');
        col.Vs=i;
    elseif strfind(char(theader{i}), 'Ss');
        col.Ss=i;
    elseif strfind(char(theader{i}), 'Hs');
        col.Hs=i;
    elseif strfind(char(theader{i}), 'Coast');
        col.FlagCourant=i;
    elseif strfind(char(theader{i}), 'Delay');
        col.FlagDelay=i;    
    elseif strfind(char(theader{i}), 'Xg');
        col.Xg=i; 
    elseif strfind(char(theader{i}), 'Yg');
        col.Yg=i; 
    elseif strfind(char(theader{i}), 'Xs');
        col.Xs=i; 
    elseif strfind(char(theader{i}), 'Ys');
        col.Ys=i; 
   elseif strfind(char(theader{i}), 'Time')
        col.Time = i;
    elseif strfind(char(theader{i}), 'Lon1')
        col.Lon1 = i;
    elseif strfind(char(theader{i}), 'Lat1')
        col.Lat1 = i;   
   elseif strfind(char(theader{i}), 'LC')
        col.LC = i; 
    elseif (strcmp(char(theader{i}) , 'Elim_Flag'))
        col.Elim_Flag = i;     
    elseif (strfind(char(theader{i}) , 'Frequency'))
        col.Freq = i;       
    elseif (strcmp(char(theader{i}) , 'LatCor'))
        col.LatCor = i;     
    elseif (strfind(char(theader{i}) , 'LonCor'))
        col.LonCor = i;       
    elseif (strfind(char(theader{i}) , 'Bathy'))
        col.Bathy = i;  
    elseif (strfind(char(theader{i}) , 'SST'))
        col.SST = i;  
    elseif (strfind(char(theader{i}) , 'Chloro'))
        col.chloro = i;       


    end
end

