function genMaskFiles(infile, outdir, nbl, nbc, nblevels)

%   genMaskFiles(infile, outdir, nbl, nbc, nblevels)
%
%   Cette fonction permet de créer 1 fichier mask par niveau à partir d'un
%   fichier contenant un mask à plusieurs niveaux. Les fichiers de sortie
%   ont le nom: mask_[niveau].txt
%
%   INPUT:
%   indir   :   Nom du fichier de masque à plusieurs niveaux
%   outdir  :   Nom du répertoire de sortie. 
%   nbl     :   Nombre de lignes de la matrice
%   nbc     :   Nombre de colonnes de la matrice
%   nblevels:   Nombre de niveaux du mask
%
%   USAGE
%   gen_cor_MaskFile('C:\mercator\mask\mask37.bin', 'C:\mercator\mask\', ...
%                     897, 1609, 37)
%
%   AUTEUR  :   BCA
%   DATE    :   08/2008


if (outdir(end)~='\'); outdir(end+1)='\'; end;

fid = fopen(infile);
mask37 = fread(fid, 'int32');
mask37 = reshape(mask37, nbl, nbc);
fclose(fid)

for (i=1:nblevels)
   fname  = [outdir 'mask_' num2str(i) '.txt'];
   m = mask37;
   m(find(m<i))=0;
   m(find(m>=i))=1;
   dlmwrite(fname, m, 'delimiter', '\t');
end