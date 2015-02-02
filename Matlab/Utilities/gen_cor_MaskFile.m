function gen_cor_MaskFile(indir, outfile, str, levels)

%   function gen_cor_MaskFile(indir, outfile)
%
%   Cette fonction permet de créer un seul fichier binaire contentant les
%   masques des plusieurs niveaux de profondeur des données mercator (==> 38
%   niveaux) à partir des fichiers avec un masque par niveau en format text
%   Le nom des fichier est: cor_mask_[niveau].txt
%
%   INPUT:
%   indir   :  Nom du répertoire avec les fichiers de masque en format text
%   outfile :  Nom du fichier de sortie
%   levels  :  Nombre de fichiers == niveaux de profondeur
%
%   USAGE
%   gen_cor_MaskFile('C:\mercator\mask\', 'cor_mask_','C:\mercator\mask\mask_37.bin', 37)
%
%   AUTEUR  :   BCA
%   DATE    :   08/2008


if (indir(end)~='\'); indir(end+1)='\'; end;

first = true;
for (i=1:levels)
   fname  = [indir str num2str(i) '.txt'];
   m = dlmread(fname);
   m(:,end)=[];
   if (first)
        mask = m;
        first = false;
   else
       mask = mask +m;
   end
end


try
    fid = fopen(outfile, 'wb');
    fwrite(fid, mask, 'int32');
    fclose(fid);
catch
    fclose('all')
end