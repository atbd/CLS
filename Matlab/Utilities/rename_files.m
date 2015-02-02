function rename_files(inDir, infilter, inpattern, outpattern)

% outdir = 'M:\reanalyse_nc\glo_soda_opsat_05x30d\BGCH\';
% if outdir(end)~='\'; outdir(end+1)='\';end;


% cette fonction permet de renomer l'ensemble de fichiers dans un
% r�pertoire
%
%   INPUT:
%   inDir   :   R�pertoire d'entr�e
%   infilter :  filtre pour les fichiers � renomer
%   inpattern:  texte � remplacer
%   outpattern : texte de remplacement

%   AUTHEUR: BCA
%   DATE: 02/2009

if inDir(end)~='\'; inDir(end+1)='\';end;

listfiles = dir ([inDir infilter]);

for i=1:length(listfiles)
    fname = listfiles(i).name;
    infile = [inDir fname];
    
    outfile = strrep(fname, inpattern, outpattern);
   % outfname = lower(fname);
    outfile = [inDir outfile];

    
    [status,message,messageid]=movefile(infile,outfile);
    if status~=1
       disp (infile)
       disp(outfile)
       disp(message)
       return;
    end
end
  