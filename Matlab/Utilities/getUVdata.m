function [U V] = getUVdata(filename)
    U = [];
    V = [];
    
   if (exist(filename) ~= 2);
       msgbox (['missing file : ' filename]);
       return;
   end
    ncid = netcdf(filename);
    ncvar = var(ncid);
   % ncvar = var(netcdf(filename));
    u_att = att(ncvar{6});
    units = u_att{3}(:);
    if (strcmp(units ,'cm/s') )
       scale=1;
    elseif (strcmp(units,'m/s'))
       scale = 100; 
    else
       msgbox(['Units unknown: ', units]);
       return;
    end;
    
    U = ncvar{6}(:)*scale;
    V = ncvar{7}(:)*scale;
    %ncclose;
    close(ncid);
return