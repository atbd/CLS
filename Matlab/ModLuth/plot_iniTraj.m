function plot_iniTraj (iniMatrix, handles)
%
%   plotTraj (iniMatrix, handles)
%  
%   Function pour aficher les points éliminés avant traitement
%
%   INPUT :
%   iniMatrix   :	Matrice avec la colonne 8 indicant le flag
%   handles		:   handle vers la figure d'affichage
%   
%   AUTHOR  :   BCA
%   DATE    :   10/2006

col_lc = 3;
col_lat = 5;
col_lon = 6;

[latLim, lonLim] = getLim(iniMatrix, col_lat,col_lon);

reset(handles.fig_trace)
axes(handles.fig_trace)
cla;

isGraphOK = false;

%if (get(handles.ckb_hrcote, 'Value') == true)
% 	try
% 		BATHY = MakeBATHY (lonLim(1), lonLim(2),latLim(1), latLim(2) , 10800, get(handles.ckb_pacific, 'Value'));
%         %[BATHY.data,BATHY.lat,BATHY.lon] = extract_1m([latLim(1), latLim(2),lonLim(1), lonLim(2)],1);
% 		coast = (BATHY.data > 0);
% 		axes(handles.fig_trace);
% 		axis equal;
% 		imcontour(BATHY.lon, BATHY.lat,coast,1, 'Color', [0.5 0.5 0.5]);
% 		axis xy;
% 		isGraphOK = true;
% 	catch
% 		msgbox('Il n''y pas assez de mémoire pour la haute résolution');
% 		isGraphOK = false;
% 	end
% end
		
if (get(handles.ckb_hrcote, 'Value') == true)
    resolution = 10800;
else
    resolution = 360*4;
end

try
    BATHY = MakeBATHY (lonLim(1), lonLim(2),latLim(1), latLim(2) , resolution, get(handles.ckb_pacific, 'Value'));
    coast = (BATHY.data > 0);
    axes(handles.fig_trace);
    axis equal;
    imcontour(BATHY.lon, BATHY.lat,coast,1, 'Color', [0.5 0.5 0.5]);
    axis xy;
    xlim([min(BATHY.lon) max(BATHY.lon)])
    ylim([min(BATHY.lat) max(BATHY.lat)])
    isGraphOK = true;
catch
    msgbox('Il n''y pas assez de mémoire pour la haute résolution');
    isGraphOK = false;
end


if (~isGraphOK)
	load coast;
	plot(long, lat, 'color', [0.5 0.5 0.5]);	
	axis equal;
	axis([lonLim latLim]);

	
end

%les données par classe

couleurs = [[0.5 0.5 0.5];[1 0 0];[0 0.902 0];...
			[0 0 1];[0.8 0.4 0.2];[1 0 1];[0 0.8 0.9]];
lc_classes = [-9;-2;-1;0;1;2;3];

for(i = 1:length(lc_classes))
	lc_clas = iniMatrix(find(iniMatrix(:,col_lc) == lc_classes(i)), :);
	if ~isempty(lc_clas)
		line (lc_clas(:, col_lon), lc_clas(:,col_lat), 'Marker', '+',...
			'LineStyle', 'none', 'Color', couleurs (i,:));
	end
end


