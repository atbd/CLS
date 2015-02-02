function save_freq(inFile, outFile)

[res, balise, reference, m] = readDiag (inFile);


m = cleanData (m);
[nl nc] = size(m);


% le fichier text
fid_out = fopen (outFile, 'w');
r(:,1) = m(:,1) + m(:,2)/(24*60*60);
r(:,2) = m(:,4);
for i=1:nl
	fprintf(fid_out, '%5.2f\t%9.2f\n', r(i,1), r(i,2));
end
fclose(fid_out);

% le graph
figure;
plot (r(:,1),r(:,2)-401000000);
set(gca,'XLimMode','manual'); 
set(gca,'XLim', [ceil(min(r(:,1))) ceil(max(r(:,1)))]);
