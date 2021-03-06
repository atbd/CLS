function plot_ModLuth_Traj (handles, iniMatrix, locMatrix, resMatrix)

try
	set(handles.fig_trace, 'visible', 'on');

	[pathstr,name,ext,versn] = fileparts(get(handles.str_input, 'String'));
	name = strrep(name, '_', '-');

	% on affiche ici de tout fa�on, toutes les donn�es initiales
	plot_iniTraj (iniMatrix, handles);

	% visualisation de points �limin�s parcequ'ils �taient
	% classe Z ou doublons ou exc�s de vitesse ou en terre
	vec_flags = [1;2;3;6];
	vec_col = [[0.5 0.5 0.5]; ...
			  [0 0 1]; ...
			  [1 0 0]; ...
			  [0 1 1]];
	plot_elimines(iniMatrix, vec_flags, vec_col, handles);
		
	val = get(handles.listTraitement,'Value');	
	switch(val)	
		case 3					  
			% visualisation des outliers
			vec_flags = 4;
			vec_col = [0 0 1];
			plot_elimines(iniMatrix, vec_flags, vec_col, handles); 
			%estim�s par regresion
			vec = resMatrix(find(resMatrix(:,2) == 0), 3:4);

			if ~isempty(vec)
				col =  [0 0 0];
				line (vec(:, 1), vec(:,2), 'Marker','.', ...
					  'LineStyle', 'none', 'Color',col);
			end			
			%estim�s par interpolation lin�aire
			vec2 = resMatrix(find(resMatrix(:,2)==1),3:4);
			if (~isempty(vec2))
				col = [1 0 0];
				line (vec2(:, 1), vec2(:,2), 'Marker', '.',...
					  'LineStyle', 'none', 'Color',col);
			end
		end

		line(resMatrix(:,3), resMatrix(:,4),'Color', [0 0 0]);

catch
	axes(handles.fig_trace);
	worldmap world;
end