function decompress_medspiration(inputDir)

cdir = pwd;

if inputDir(end) ~= '\' && inputDir(end) ~= '/' 
    inputDir(end+1) = '\';
end

listdirs = dir(inputDir);

for i=1:length(listdirs)
   cd ([inputDir listdirs(i).name])
   dos('IZARCE  *.bz2');
   cd (cdir);
end

cdir = pwd;

