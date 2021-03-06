function BATHY=MakeBATHY(lonmin,lonmax,latmin,latmax,gsize, pacific);

% PURPOSE
% This function returns a matrix of depth values
%
% USE
% BATHY=MakeBATHY(-80,-50,30,50,4096);
% BATHY=MakeBATHY(-80,-50,30,50,8192);
%
% AUTHOR
% F. Royer


if (~exist('pacific', 'var')); pacific = false; end;

olddir=cd;
cd('..\Utilities\');
delta=360/gsize; % gsize=4096 for AVHRR9KM, 1440 for AMSR-E .25

% [-180 180]
if (pacific == false)
    if (lonmin>180); lonmin = lonmin-360; end;
    if (lonmax>180); lonmax = lonmax-360; end;
    xmin=floor((lonmin-(-180))/delta);
    if (xmin==0); xmin=1; end;
    xmax=ceil((lonmax-(-180))/delta);
    lon=(xmin:xmax)*delta-180;
% [0 360]
else
    if (lonmin<0); lonmin = lonmin+360; end;
    if (lonmax<0); lonmax = lonmax+360; end;
    xmin=floor(lonmin/delta);
    xmax=ceil(lonmax/delta);  
    lon=(xmin:xmax)*delta;
end


ymin=floor((latmin+90)/delta);
ymax=ceil((latmax+90)/delta);
lat = (ymin:ymax)*delta-90;

scalefactor=1;
while (true)
	if scalefactor > 10 
		msgbox('Bathymetry error');
		return
	end
	try
	[latgrat,longrat,z] = satbath(scalefactor,[latmin latmax],[lonmin lonmax]);  

    %[latgrat,longrat,z] = satbath(scalefactor);
     %   longrat(find(longrat>360)) = longrat(find(longrat>360))-360;
        if (pacific == false)
            longrat(find(longrat>180)) = longrat(find(longrat>180))-360;
        end
        
        vlon = longrat(1,:);
        vlat = latgrat(:,1);
        [X,Y]=meshgrid(vlon,vlat);
        Z = interp2(X,Y,z,lon,lat');
		disp(['scalefactor: ' num2str(scalefactor)]);
		break;
    catch
        disp(lasterr);
		scalefactor = scalefactor + 1;
        clear latgrat longrat z X Y Z 
        
	end
end

cd(olddir);

BATHY.lon=lon;
BATHY.lat=lat;
BATHY.data=Z;