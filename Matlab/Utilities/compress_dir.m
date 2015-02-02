function compress_dir (dirName, extname)


if (dirName(end)~='\'); dirName(end+1) = '\'; end;

if (exist(dirName) ~= 7)
    msgbox ([ dirName ' n''est pas un répertoire']);
    return;
end

cdir = pwd;
dirFiles = dir([dirName '*.' extname]);

cd (dirName);
for (i=1:length(dirFiles))
    [path name ext] = fileparts(dirFiles(i).name);
    dos(['IZARCC "' dirName name ext '.zip" "' dirName name ext '"']); 
    delete  ([dirName name ext]);  
end
cd (cdir);

msgbox('ok');