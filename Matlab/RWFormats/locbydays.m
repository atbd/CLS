function locbydays(dsfile)

[res, balise, reference, mat] = readDS (dsfile);

fday = mat(1,1);
lday = mat(end,1);

for i=fday:lday
    ind = find(mat(:,1)==i);
    if ~isempty(ind)
        disp( [num2str(i) ' - ' num2str(length(ind))]);
    else
        disp( [num2str(i) ' - 0']);
    end
end
