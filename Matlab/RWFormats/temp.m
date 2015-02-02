mat = mat_78524;

listdays = unique(mat(:,1));
for i=1:length(listdays)
    d = listdays(i);
    ind = find(mat(:,1)==d);
    disp( [num2str(d) ' - ' num2str(length(ind))]);
end
