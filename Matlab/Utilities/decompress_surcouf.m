function decompress_surcouf (inputDir, first, last)


cdir = pwd;
if inputDir(end) ~= '\' && inputDir(end) ~= '/' 
    inputDir(end+1) = '\';
end

cd (inputDir)

for i=first-1:last+1
     ncname =  [inputDir 'CourantTotal_' num2str(i) '.nc'];
     if ~exist(ncname)
         fname = [inputDir 'CourantTotal_' num2str(i) '.nc.gz'];
         if (exist(fname))
             dos(['IZARCE ' fname]);
             delete  (fname)  
         else
             disp(['missing ' fname]);
         end
         
     end
end

cd (cdir);


return;