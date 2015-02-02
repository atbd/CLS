function anneedec = anneedec(jourjulien)


[dd mm aa] = jourjul_ddmmaa (jourjulien);


if (aa < 100) % que 2 chiffres
	if (aa < 50 && aa >=0 )	
		aa = aa + 2000;
	else
		aa = aa + 1900;	% entre 1950 et 1999
	end
end


% Quantiemes dans l'annee pour les annees bissextiles et non bissextiles
jk_Quantiemes = { 0,31,59,90,120,151,181,212,243,273,304,334; ...
				  0,31,60,91,121,152,182,213,244,274,305,335};
	            

jours = jk_Quantiemes{is_bissextile(aa)+1, mm} + dd;

anneedec = aa + jours/(365+is_bissextile(aa));


