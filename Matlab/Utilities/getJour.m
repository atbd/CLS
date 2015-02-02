function jour = getJour (strDate);

jk_Quantiemes = {0,31,60,91,121,152,182,213,244,274,305,335 ; 
				 0,31,59,90,120,151,181,212,243,273,304,334};
			 
[str_jour,strDate] = strtok(strDate,'/'); 
[str_mois,strDate] = strtok(strDate,'/');
[str_annee,strDate] = strtok(strDate,'/');
jour = str2num(char(str_jour));
mois = str2num(char(str_mois));

annee = str2num(char(str_annee));
if (annee < 100) % que 2 chiffres
	if (annee < 50 && annee >=0 )	
		annee = annee + 2000;
	else
		annee = annee + 1900;	% entre 1950 et 1999
	end
end

jour = jk_Quantiemes {is_bissextile(annee)+1, mois} + jour;