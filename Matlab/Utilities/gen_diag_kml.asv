function gen_diag_kml (infile, outfile, inidate)



addpath('..\RWFormats');
col_lon=6;
col_lat=5;


[res, balise, reference, matData] = readDiag (infile);

matData(find(matData(:,col_lon)==9999),:)=[];
matData(find(matData(:,col_lat)==9999),:)=[];

if (exist('inidate', 'var'))
    ini_julien = datenum(inidate) - datenum('1950-1-1');
    matData(find(matData(:,1)<ini_julien),:)=[]; 
end



str = sprintf('<?xml version="1.0" encoding="UTF-8"?>\n');
str = sprintf('%s\t<kml xmlns="http://earth.google.com/kml/2.0">\n', str);
str = sprintf('%s\t\t<Folder>\n', str);
str = sprintf('%s\t\t\t<Placemark>\n', str);
str = sprintf('%s\t\t\t\t<name>Tag Id: %s </name>\n', str, balise);
str = sprintf('%s\t\t\t\t<Style>\n', str);
str = sprintf('%s\t\t\t\t\t<LineStyle>\n', str);
str = sprintf('%s\t\t\t\t\t\t<color>ff0000ff</color>\n', str);
str = sprintf('%s\t\t\t\t\t\t<width>2</width>\n', str);
str = sprintf('%s\t\t\t\t\t</LineStyle>\n', str);
str = sprintf('%s\t\t\t\t</Style>\n', str);
str = sprintf('%s\t\t\t\t<LineString>\n', str);
str = sprintf('%s\t\t\t\t\t<coordinates>\n', str);

for i=1:size(matData,1);
 str = sprintf('%s\t\t\t\t\t\t%3.2f, %3.2f\n', str, ...
                matData(i,col_lon),  matData(i,col_lat) );
end

str = sprintf('%s\t\t\t\t\t</coordinates>\n', str);
str = sprintf('%s\t\t\t\t</LineString>\n', str);
str = sprintf('%s\t\t\t</Placemark>\n', str);

% First Point 
str = sprintf('%s\t\t\t<Placemark>\n', str);
str = sprintf('%s\t\t\t\t<name>First point</name>\n', str);
str = sprintf('%s\t\t\t\t<description>First point</description>\n', str);
str = sprintf('%s\t\t\t\t<Point>\n', str);
str = sprintf('%s\t\t\t\t\t<coordinates>%3.2f, %3.2f</coordinates>\n', str, ...
               matData(1,col_lon), matData(1,col_lat));
str = sprintf('%s\t\t\t\t</Point>\n', str);          
str = sprintf('%s\t\t\t</Placemark>\n', str);

% Last Point 
str = sprintf('%s\t\t\t<Placemark>\n', str);
str = sprintf('%s\t\t\t\t<name>Last point</name>\n', str);
str = sprintf('%s\t\t\t\t<description>Last point</description>\n', str);
str = sprintf('%s\t\t\t\t<Point>\n', str);
str = sprintf('%s\t\t\t\t\t<coordinates>%3.2f, %3.2f</coordinates>\n', str, ...
               matData(end,col_lon), matData(end,col_lat));
str = sprintf('%s\t\t\t\t</Point>\n', str);          
str = sprintf('%s\t\t\t</Placemark>\n', str);

str = sprintf('%s\t\t</Folder>\n', str);
str = sprintf('%s\t</kml>', str);

try
    fid = fopen (outfile, 'w');
    fwrite(fid, str);
    fclose(fid);

catch
    disp(lasterr)
    fclose('all')
end

return;
