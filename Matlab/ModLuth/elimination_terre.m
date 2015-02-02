function iniMatrix = elimination_terre (iniMatrix);


col_lat = 5;
col_lon = 6;
col_flag = 9;

latMin = floor (min(iniMatrix(:,col_lat)))-1;
latMax = ceil (max(iniMatrix(:,col_lat)))+1;
lonMin = floor (min(iniMatrix(:,col_lon)))-1;
lonMax = ceil (max(iniMatrix(:,col_lon)))+1;

iniMatrix(:,10) = 999;

%BATHY=MakeBATHY(lonMin,lonMax,latMin,latMax,10800);
[BATHY.data,BATHY.lat,BATHY.lon] = extract_1m([latMin,latMax,lonMin,lonMax],1);

iniMatrix(:,10) = GetDepth(iniMatrix(:,col_lon), iniMatrix(:,col_lat), BATHY);

iniMatrix(find(iniMatrix(:,10) > 0),col_flag) = 6;

iniMatrix = iniMatrix(:,1:col_flag);

return;
