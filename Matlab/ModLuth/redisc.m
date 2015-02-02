function [mat_out]=redisc(mat_in,pas_redisc, pacific)

% ENTREE : mat_in: matrice tortue de la forme :
%                  - jourcnes (decimal)
%                  - flag
%                  - lon
%                  - lat
%                  - eventuellement d'autres choses derrières (Ug, Vg,
%                    Ng, Cg, etc.)
%          pas_redisc : pas en secondes
%
%	AUTEUR	: Charlotte Girard
%	DATE	: 15/12/2006


siz_mat_in=size(mat_in) ;
nblignes=siz_mat_in(1);

%Conversion pas_redisc (en sec) en decimal
pas_decim =pas_redisc/86400;

%Création du vecteur temps brut(vertical) en secondes
mat_tps = zeros(nblignes,1);
temps_orig=mat_in(1,1)*1440*60;
            
%Remplissage du vecteur mat_tps (temps bruts)
mat_tps(:,1)=mat_in(:,1)*1440*60 - temps_orig;

%Creation du nouveau vecteur temps (ttes les x heures)
temps_final = mat_tps(nblignes,1);
nombre_de_pas = fix(temps_final/pas_redisc)+1 ; % (nbvaleurs = nombre_de_pas + 1...)
for k=1:nombre_de_pas
   mat_tps_final(k,1) = (k-1)*pas_redisc;
end
mat_tps_final(k+1,1) = mat_tps(nblignes);

%Creation de la matrice finale
mat_out=zeros(nombre_de_pas+1,4);
mat_out(:,2)=0;  %mise à zero de la col flag pour garder le mm format que les fichiers lovi et epan       
for i=1:nombre_de_pas
   %Colonne des longitudes (sauf dernier) 
   mat_out(i,3)=interp1(mat_tps(:,1),mat_in(:,3),mat_tps_final(i,1));
   %Colonne des latitudes (sauf dernier) 
   mat_out(i,4)=interp1(mat_tps(:,1),mat_in(:,4),mat_tps_final(i,1));
end
%Lon lat dernier point
mat_out(i+1,3)= mat_in(nblignes,3);
mat_out(i+1,4)= mat_in(nblignes,4);

%Colonnes jourCNES (decimal)
%cas premiere ligne
mat_out(1,1) = mat_in(1,1);
jour= mat_out(1,1); 
%cas lignes suivantes
for i=2:nombre_de_pas
  jour=jour+pas_decim;
  mat_out(i,1)=jour;
end
%cas dernière loc (forcage)
mat_out(nombre_de_pas+1,1)=mat_in(nblignes,1);


%
          
            