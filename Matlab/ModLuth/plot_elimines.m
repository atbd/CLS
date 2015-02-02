function plot_elimines (M, vec_flag, couleurs, handles)
%
%   plotTraj (iniMatrix, handles)
%  
%   Function pour aficher les points éliminés (par de cercles)
%
%   INPUT :
%   M			:	Matrice avec la colonne 8 indicant le flag
%	vec_flag	:	Vecteur indicant les flags à visualiser
%	couleurs	:	Vecteur	avec les couleurs pour chaque flag.
%   handles		:   handle vers la figure d'affichage
%   
%   AUTHOR  :   BCA
%   DATE    :   10/2006


col_lat = 5;
col_lon = 6;
col_flag = 9;

axes(handles.fig_trace)

%les données par flag
for(i = 1:length(vec_flag))
	vec = M(find(M(:,col_flag) == vec_flag(i)), :);
	if ~isempty(vec)
		line (vec(:, col_lon),vec(:,col_lat), 'Marker', 'o', ...
			  'Color', couleurs (i,:), 'LineStyle', 'none');
	end
end



	
