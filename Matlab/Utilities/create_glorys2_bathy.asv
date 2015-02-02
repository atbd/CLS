
bathy_nc_file = 'S:\SRC\PYTHON\bathy\etopo_data\ETOPO2v2g_f4.nc';


nc = netcdf(bathy_nc_file);
in_lon = nc{'x'}(:);
in_lat= nc{'y'}(:);

% faire interpolation en 4 matrices:
% West - Sud
vlon = in_lon(1:5402);
vlat = in_lat(1:2702);
in_bathy=nc{'z'}(1:2702,1:5402);
lon = -180:0.25:0;
lat = -90:0.25:0;
[X,Y]=meshgrid(vlon,vlat);
out_bathy_1 = interp2(X,Y,in_bathy,lon,lat');

% West - Nord
vlon = in_lon(1:5402);
vlat = in_lat(2700:end);
in_bathy=nc{'z'}(2700:end,1:5402);
lon = -180:0.25:0;
lat = 0.25:0.25:90;
[X,Y]=meshgrid(vlon,vlat);
out_bathy_2 = interp2(X,Y,in_bathy,lon,lat');


% Est - Nord
vlon = in_lon(5400:end);
vlat = in_lat(1:2702);
in_bathy=nc{'z'}(1:2702,5400:end);
lon = 0.25:0.25:179.75;
lat = -90:0.25:0;
[X,Y]=meshgrid(vlon,vlat);
out_bathy_3 = interp2(X,Y,in_bathy,lon,lat');

% Est - Sud
vlon = in_lon(5400:end);
vlat = in_lat(2700:end);
in_bathy=nc{'z'}(2700:end,5400:end);
lon = 0.25:0.25:179.75;
lat = 0.25:0.25:90;
[X,Y]=meshgrid(vlon,vlat);
out_bathy_4 = interp2(X,Y,in_bathy,lon,lat');

out_bathy=[[out_bathy_1, out_bathy_3];
           [out_bathy_2, out_bathy_4]];     
       
out_lon = -180:0.25:179.75;
out_lat = -90:0.25:90;
figure,imagesc(out_lon, out_lat, out_bathy); axis('xy')
nc.close()
 

% to compare with mercator
mercator_mask = 'S:\RUN_NAME\glo_mercator_opsat_catsat_025x7d_2002_2011\NC\MASK\glo_catsat_mercator_025_092011.nc';
ncmer = netcdf(mercator_mask);
mask = ncmer{'mask'}(:);
ncmer.close()

extract_bathy = out_bathy( 94:721-119, :);
